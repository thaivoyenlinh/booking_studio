import { Component, OnInit } from '@angular/core';
import { BehaviorSubject, catchError, debounceTime, delay, finalize, Observable, of, Subject, switchMap, tap } from 'rxjs';
import { ScheduleService } from 'src/app/cores/https/schedule/schedule.service';
import { Direction, Sort, SortBy } from 'src/app/models/schedule/schedule-sort.model';
import { IScheduleDetail, ISchedulesListQuery, SchedulesListQuery } from 'src/app/models/schedule/schedule.model';
import { LoadingService } from 'src/app/shared/components/loading/loading.service';
import { PAGE_SIZE_OPTIONS, StatusSchedule } from 'src/app/shared/constants/app.constants';
import { isEmpty } from 'src/app/shared/helpers/is-empty';
import { SubSink } from 'src/app/shared/models/sub-sink/sub-sink.model';

@Component({
  selector: 'app-schedule',
  templateUrl: './schedule.component.html',
  styleUrls: ['./schedule.component.scss']
})
export class ScheduleComponent implements OnInit {
  displayedColumns = ['date', 'status', 'customerName', 'employeeName', 'action'];
  displayedColumnFilters = ['dateFilter', 'statusFilter', 'customerNameFilter', 'employeeNameFilter', 'actionFilter'];
  scheduleList$: Observable<IScheduleDetail[]>;
  scheduleListQuerySubject$ = new BehaviorSubject<Partial<ISchedulesListQuery>>({});
  pagination = {
    pageIndex: 0,
    pageSize: PAGE_SIZE_OPTIONS[0],
    totalRecords: 0,
    pageSizeOptions: PAGE_SIZE_OPTIONS,
  };
  sorting?: Sort;
  Direction: Direction;
  selectedStatus: any;
  selectAllOption = {
    Text: "All",
    Value: ""
  }
  statusFilterSubject$ = new Subject<string>();
  typeList = StatusSchedule;
  subSink = new SubSink();
  filterStatus: string;
  filterDate: string;
  dateFilterSubject$ = new Subject<string>();

  constructor(
    private loadingService: LoadingService,
    private scheduleService: ScheduleService
  ) { }

  ngOnInit(): void {
    this.setSelectOption();
    this.filterObservable()
    this.loadData();
    this.scheduleList$ = this.initEmployeesListObservable();
  }

  setSelectOption(){
    this.selectedStatus = this.selectAllOption.Value;
  }

  loadData() {
    const query = new SchedulesListQuery();
    query.currentPage = 1;
    query.rowsPerPage = this.pagination.pageSize;
    // query.name = this.filterName ?? null;
    query.sortHeader = this.sorting?.sortBy ?? null;
    query.sortOrder = this.sorting?.direction ?? null;
    this.scheduleListQuerySubject$.next(query);
  }

  initEmployeesListObservable(): Observable<IScheduleDetail[]> {
    return this.scheduleListQuerySubject$.pipe(
      tap((query: ISchedulesListQuery) => {
        Object.keys(query).forEach((k) => {
          if (typeof query[k] != 'number') {
            isEmpty(query[k]) && delete query[k];
          }
          if (query[k] === -1) {
            delete query[k];
          }
        });
      }),
      switchMap((query) => this.queryEmployeesListObservable(query))
    );
  }

  queryEmployeesListObservable(
    query: Partial<ISchedulesListQuery>
  ): Observable<IScheduleDetail[]> {
    this.loadingService.showLoading();
    return this.scheduleService.getSchedulesList(query).pipe(
      delay(300),
      tap((res) => {
        if (res.totalRecords !== 0 && res.rows.length !== 0) {
          this.updatePaginator(res);
        }
      }),
      switchMap((res) => of(res.rows)),
      catchError((error) => {
        console.error(error);
        return of([]);
      }),
      finalize(() => this.loadingService.hideLoading())
    );
  }

  updatePaginator(res) {
    this.pagination.totalRecords = res.totalRecords;
    this.pagination.pageIndex = res.currentPage ? res.currentPage - 1 : 0;
  }

  onPageChange(event: any) {
    this.pagination.pageIndex = event.pageIndex;
    this.pagination.pageSize = event.pageSize;
    this.scheduleListQuerySubject$.next(
      this.concatSchedulesListQuery({
        currentPage: this.pagination.pageIndex + 1,
        rowsPerPage: this.pagination.pageSize,
      })
    );
  }

  concatSchedulesListQuery(
    data: Partial<ISchedulesListQuery>
  ): Partial<ISchedulesListQuery> {
    const currentQuery = this.scheduleListQuerySubject$.getValue();
    return { ...currentQuery, ...data };
  }

  changeType(event){
    if(event.source._selected == true && event.isUserInput == true){
      this.statusFilterSubject$.next(event.source.value);
    }
  }

  handleSorting(sort: SortBy) {
    if (this.sorting && this.sorting.sortBy === sort) {
      this.sorting.direction =
        this.sorting.direction === Direction.asc
          ? Direction.desc
          : Direction.asc;
    } else {
      this.sorting = { sortBy: sort, direction: Direction.asc };
    }
    this.loadData();
  }

  showDirectionIcon(sort: SortBy) {
    return this.sorting && this.sorting.sortBy === sort
      ? `sort-by-${this.sorting.direction === Direction.asc ? 'asc' : 'desc'}`
      : `sortable`;
  }

  filterObservable(): void {
    this.subSink.add(
      this.statusFilterSubject$.asObservable().pipe(
        tap(async (value) => {
          this.filterStatus = value;
          this.scheduleListQuerySubject$.next(
            this.concatSchedulesListQuery({
              status: value,
              currentPage: 1,
              rowsPerPage: this.pagination.pageSize,
            })
          )
        })
      ).subscribe()
    );
    this.subSink.add(
      this.dateFilterSubject$.pipe(
        debounceTime(600),
        tap(async (value) => {
          this.filterDate = value;
          this.scheduleListQuerySubject$.next(
            this.concatSchedulesListQuery({
              date: value,
              currentPage: 1,
              rowsPerPage: this.pagination.pageSize,
            })
          )
        })
      ).subscribe()
    );
  }

  get sortBy() {
    return SortBy;
  }

  get direction() {
    return Direction;
  }

}
