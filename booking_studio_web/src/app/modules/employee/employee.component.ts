import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { AddEmployeeComponent } from './add-employee/add-employee.component';
import { MatTableDataSource } from '@angular/material/table';
import { Observable, BehaviorSubject, switchMap, tap, of, catchError, finalize, delay, Subject, debounceTime } from 'rxjs';
import { EmployeeListQuery, IEmployeeDetail, IEmployeesListQuery } from 'src/app/models/employee/employee.model';
import { PAGE_SIZE_OPTIONS } from 'src/app/shared/constants/app.constants';
import { EmployeeService } from 'src/app/cores/https/employee/employee.service';
import { EditEmployeeComponent } from './edit-employee/edit-employee.component';
import { SubSink } from 'src/app/shared/models/sub-sink/sub-sink.model';
import { ConfirmationDialogComponent } from 'src/app/shared/components/confirmation-dialog/confirmation-dialog.component';
import { LoadingService } from 'src/app/shared/components/loading/loading.service';
import { Direction, Sort, SortBy } from 'src/app/models/employee/employee-sort.model';
import { query } from '@angular/animations';
import { isEmpty } from 'src/app/shared/helpers/is-empty';

@Component({
  selector: 'app-employee',
  templateUrl: './employee.component.html',
  styleUrls: ['./employee.component.scss']
})
export class EmployeeComponent implements OnInit {

  displayedColumns = ['name', 'badgeId', 'email', 'action'];
  displayedColumnFilters = ['nameFilter']
  subSink = new SubSink();
  employees: any;
  employeeListQuerySubject$ = new BehaviorSubject<Partial<IEmployeesListQuery>>({});
  employeeList$: Observable<IEmployeeDetail[]>;
  nameFilterSubject$ = new Subject<string>();
  filterName: string;
  pagination = {
    pageIndex: 0,
    pageSize: PAGE_SIZE_OPTIONS[0],
    totalRecords: 0,
    pageSizeOptions: PAGE_SIZE_OPTIONS
  }
  sorting?: Sort;
  Direction: Direction;
  latestBadgeId: number;
  
  constructor(
      private dialog: MatDialog,
      private employeeService: EmployeeService,
      private loadingService: LoadingService
    ) { }

  ngOnInit() {
    this.filterObservable();
    this.loadData();
    this.employeeList$ = this.initEmployeesListObservable();
  }

  loadData(){
    const query = new EmployeeListQuery();
    query.currentPage = 1;
    query.rowsPerPage = this.pagination.pageSize;
    query.name = this.filterName ?? null;
    query.sortHeader = this.sorting?.sortBy ?? null;
    query.sortOrder = this.sorting?.direction ?? null;
    this.employeeListQuerySubject$.next(query);
  }

  initEmployeesListObservable(): Observable<IEmployeeDetail[]> {
    return this.employeeListQuerySubject$.pipe(
      tap((query: IEmployeesListQuery) => {
        Object.keys(query).forEach((k) => {
          if(typeof query[k] != 'number') {
            isEmpty(query[k]) && delete query[k];
          }
          if(query[k] === -1){
            delete query[k];
          }
        })
      }),
      switchMap((query) => this.queryEmployeesListObservable(query))
    );
  }

  queryEmployeesListObservable(query: Partial<IEmployeesListQuery>) : Observable<IEmployeeDetail[]>{
    this.loadingService.showLoading();
    return this.employeeService.getEmployeesList(query).pipe(
      delay(300),
      tap((res)=> {
        this.latestBadgeId = res.rows.slice(-1).pop().badgeId;
        this.updatePaginator(res);
      }),
      switchMap((res) => of(res.rows)),
      catchError((error) => {
        console.error(error);
        return of([]);
      }),
      finalize(() => this.loadingService.hideLoading())
    )
  }

  updatePaginator(res) {
    this.pagination.totalRecords = res.totalRecords;
    this.pagination.pageIndex = res.currentPage ? res.currentPage - 1 : 0;
  }

  clkAddEmployee(){
    const dialogRef = this.dialog.open(AddEmployeeComponent, {
      data: {
        latestBadgeId: this.latestBadgeId,
        noFunc: () => {
          dialogRef.close();
        },
        yesFunc: () => {
          dialogRef.close();
          this.loadData();
        }
      }
    });
  }

  clkEdit(element){
    this.employeeService.getEmployeeDetails(element.id).then(
      (res) => {
        if(res) {
          const dialogRef = this.dialog.open(EditEmployeeComponent, {
            disableClose: true,
            autoFocus: false,
            data: {
              id: res.id,
              badgeId: res.badgeId,
              name: res.name,
              email: res.email
            }
          });
          this.subSink.add(
            dialogRef.afterClosed().subscribe((resAction) => {
              if(resAction) {
                this.loadData();
              }
            })
          )
        }
      }
    );
  }

  clkDelete(element) {
    console.log("element",element);
    const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
      width: '500px',
      height: 'auto',
      data: {
        title: "Delete Selected Employee",
        content: 'Are you sure delete the selected Employee?',
        noFunc: () => {
          dialogRef.close();
        },
        yesFunc: () => {
          this.employeeService.deleteEmployee(element.id).subscribe((res) => {
            if(res['status'] == 200){
              dialogRef.close();
              this.loadData();
            }
          });
        }
      }
    });
  }

  onPageChange(event: any){
    this.pagination.pageIndex = event.pageIndex;
    this.pagination.pageSize = event.pageSize;
    this.employeeListQuerySubject$.next(
      this.concatEmployeesListQuery({
        currentPage: this.pagination.pageIndex + 1,
        rowsPerPage: this.pagination.pageSize,
      })
    )
  }

  filterObservable(): void {
    this.subSink.add(
      this.nameFilterSubject$.pipe(
        debounceTime(600),
        tap(async (value) => {
          this.filterName = value;
          this.employeeListQuerySubject$.next(
            this.concatEmployeesListQuery({
              name: value,
              currentPage: 1,
              rowsPerPage: this.pagination.pageSize,
            })
          )
        })
      ).subscribe()
    );
  }

  handleSorting(sort: SortBy){
    if(this.sorting && this.sorting.sortBy === sort){
      this.sorting.direction = 
        this.sorting.direction === Direction.asc
          ? Direction.desc
          : Direction.asc;
    } else {
      this.sorting = { sortBy: sort, direction: Direction.asc };
    }
    this.loadData();
  }

  showDirectionIcon(sort: SortBy){
    return this.sorting && this.sorting.sortBy === sort
      ? `sort-by-${this.sorting.direction === Direction.asc ? 'asc' : 'desc'}`
      : `sortable`
  }

  concatEmployeesListQuery(data: Partial<IEmployeesListQuery>) : Partial<IEmployeesListQuery>{
    const currentQuery = this.employeeListQuerySubject$.getValue();
    return { ...currentQuery, ...data };
  }

  get sortBy() {
    return SortBy;
  }

  get direction(){
    return Direction;
  }
}
