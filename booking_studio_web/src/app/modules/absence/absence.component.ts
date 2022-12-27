import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { BehaviorSubject, catchError, debounceTime, delay, finalize, Observable, of, Subject, switchMap, tap } from 'rxjs';
import { AbsenceService } from 'src/app/cores/https/employee/absence.service';
import { EmployeeService } from 'src/app/cores/https/employee/employee.service';
import { AbsencesListQuery, IAbsenceDetail, IAbsencesListQuery } from 'src/app/models/employee/absence.moodel';
import { Direction, Sort, SortBy } from 'src/app/models/employee/employee-sort.model';
import { EmployeeListQuery, IEmployeeDetail, IEmployeesListQuery } from 'src/app/models/employee/employee.model';
import { ConfirmationDialogComponent } from 'src/app/shared/components/confirmation-dialog/confirmation-dialog.component';
import { LoadingService } from 'src/app/shared/components/loading/loading.service';
import { PAGE_SIZE_OPTIONS } from 'src/app/shared/constants/app.constants';
import { isEmpty } from 'src/app/shared/helpers/is-empty';
import { SubSink } from 'src/app/shared/models/sub-sink/sub-sink.model';
import { AddEmployeeComponent } from '../employee/add-employee/add-employee.component';
import { EditEmployeeComponent } from '../employee/edit-employee/edit-employee.component';

@Component({
  selector: 'app-absence',
  templateUrl: './absence.component.html',
  styleUrls: ['./absence.component.scss']
})
export class AbsenceComponent implements OnInit {
  displayedColumns = ['name', 'date', 'status', 'action'];
  displayedColumnFilters = ['nameFilter'];
  subSink = new SubSink();
  employees: any;
  absenceListQuerySubject$ = new BehaviorSubject<Partial<IAbsencesListQuery>>(
    {}
  );
  employeeList$: Observable<IAbsenceDetail[]>;
  nameFilterSubject$ = new Subject<string>();
  filterName: string;
  pagination = {
    pageIndex: 0,
    pageSize: PAGE_SIZE_OPTIONS[0],
    totalRecords: 0,
    pageSizeOptions: PAGE_SIZE_OPTIONS,
  };
  sorting?: Sort;
  Direction: Direction;
  latestBadgeId: number = 1000;

  constructor(
    private dialog: MatDialog,
    private absenceService: AbsenceService,
    private loadingService: LoadingService
  ) {}

  ngOnInit() {
    this.filterObservable();
    this.loadData();
    this.employeeList$ = this.initEmployeesListObservable();
  }

  loadData() {
    const query = new AbsencesListQuery();
    query.currentPage = 1;
    query.rowsPerPage = this.pagination.pageSize;
    // query.name = this.filterName ?? null;
    // query.sortHeader = this.sorting?.sortBy ?? null;
    // query.sortOrder = this.sorting?.direction ?? null;
    this.absenceListQuerySubject$.next(query);
  }

  initEmployeesListObservable(): Observable<IAbsenceDetail[]> {
    return this.absenceListQuerySubject$.pipe(
      tap((query: IEmployeesListQuery) => {
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
    query: Partial<IAbsencesListQuery>
  ): Observable<IAbsenceDetail[]> {
    this.loadingService.showLoading();
    return this.absenceService.getAbsencesList(query).pipe(
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

  // clkAddEmployee() {
  //   const dialogRef = this.dialog.open(AddEmployeeComponent, {
  //     data: {
  //       latestBadgeId: this.latestBadgeId,
  //       noFunc: () => {
  //         dialogRef.close();
  //       },
  //       yesFunc: () => {
  //         dialogRef.close();
  //         this.loadData();
  //       },
  //     },
  //   });
  // }

  // clkEdit(element) {
  //   this.employeeService.getEmployeeDetails(element.employeeAccountId).then((res) => {
  //     if (res) {
  //       const dialogRef = this.dialog.open(EditEmployeeComponent, {
  //         disableClose: true,
  //         autoFocus: false,
  //         data: {
  //           id: res.id,
  //           badgeId: res.badgeId,
  //           name: res.name,
  //           email: res.email,
  //           phoneNumber: res.phoneNumber
  //         },
  //       });
  //       this.subSink.add(
  //         dialogRef.afterClosed().subscribe((resAction) => {
  //           if (resAction) {
  //             this.loadData();
  //           }
  //         })
  //       );
  //     }
  //   });
  // }

  // clkDelete(element) {
  //   console.log('element', element);
  //   const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
  //     width: '500px',
  //     height: 'auto',
  //     data: {
  //       title: 'Delete Selected Employee',
  //       content: 'Are you sure delete the selected Employee?',
  //       noFunc: () => {
  //         dialogRef.close();
  //       },
  //       yesFunc: () => {
  //         this.employeeService.deleteEmployee(element.id).subscribe((res) => {
  //           if (res['status'] == 200) {
  //             dialogRef.close();
  //             this.loadData();
  //           }
  //         });
  //       },
  //     },
  //   });
  // }

  clkConfirm(absenceId){
    const status = 1;
    this.loadingService.showLoading();
    this.absenceService.updateStatusAbsence(absenceId, status).subscribe(
      (res) => {
        this.loadingService.hideLoading();
        this.loadData();
      }
    );
  }

  onPageChange(event: any) {
    this.pagination.pageIndex = event.pageIndex;
    this.pagination.pageSize = event.pageSize;
    this.absenceListQuerySubject$.next(
      this.concatEmployeesListQuery({
        currentPage: this.pagination.pageIndex + 1,
        rowsPerPage: this.pagination.pageSize,
      })
    );
  }

  filterObservable(): void {
    this.subSink.add(
      this.nameFilterSubject$
        .pipe(
          debounceTime(600),
          tap(async (value) => {
            this.filterName = value;
            this.absenceListQuerySubject$.next(
              this.concatEmployeesListQuery({
                name: value,
                currentPage: 1,
                rowsPerPage: this.pagination.pageSize,
              })
            );
          })
        )
        .subscribe()
    );
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

  concatEmployeesListQuery(
    data: Partial<IEmployeesListQuery>
  ): Partial<IEmployeesListQuery> {
    const currentQuery = this.absenceListQuerySubject$.getValue();
    return { ...currentQuery, ...data };
  }

  get sortBy() {
    return SortBy;
  }

  get direction() {
    return Direction;
  }
}
