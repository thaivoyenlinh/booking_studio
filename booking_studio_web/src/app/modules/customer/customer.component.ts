import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { BehaviorSubject, catchError, debounceTime, delay, finalize, Observable, of, Subject, switchMap, tap } from 'rxjs';
import { CustomerService } from 'src/app/cores/https/customer/customer.service';
import { CustomersListQuery, ICustomerDetail, ICustomersListQuery } from 'src/app/models/customer/customer.model';
import { ConfirmationDialogComponent } from 'src/app/shared/components/confirmation-dialog/confirmation-dialog.component';
import { LoadingService } from 'src/app/shared/components/loading/loading.service';
import { PAGE_SIZE_OPTIONS } from 'src/app/shared/constants/app.constants';
import { isEmpty } from 'src/app/shared/helpers/is-empty';
import { SubSink } from 'src/app/shared/models/sub-sink/sub-sink.model';

@Component({
  selector: 'app-customer',
  templateUrl: './customer.component.html',
  styleUrls: ['./customer.component.scss']
})
export class CustomerComponent implements OnInit {
  displayedColumns = ['fullName', 'address', 'phoneNumber', 'action'];
  displayedColumnFilters = ['nameFilter', 'addressFilter', 'phoneNumberFilter', 'actionFilter'];
  subSink = new SubSink();
  pagination = {
    pageIndex: 0,
    pageSize: PAGE_SIZE_OPTIONS[0],
    totalRecords: 0,
    pageSizeOptions: PAGE_SIZE_OPTIONS,
  };
  nameFilterSubject$ = new Subject<string>();
  addressFilterSubject$ = new Subject<string>();
  filterName: string;
  filterAddress: string;
  customerList$: Observable<ICustomerDetail[]>;
  customerListQuerySubject$ = new BehaviorSubject<Partial<ICustomersListQuery>>({});
  constructor(
    private dialog: MatDialog,
    private loadingService: LoadingService,
    private customerService: CustomerService
  ) { }

  ngOnInit(): void {
    this.filterObservable();
    this.loadData();
    this.customerList$ = this.initCustomersListObservable();
  }

  loadData() {
    const query = new CustomersListQuery();
    query.currentPage = 1;
    query.rowsPerPage = this.pagination.pageSize;
    query.name = this.filterName ?? null;
    query.address = this.filterAddress ?? null;
    // query.sortHeader = this.sorting?.sortBy ?? null;
    // query.sortOrder = this.sorting?.direction ?? null;
    this.customerListQuerySubject$.next(query);
  }

  initCustomersListObservable(): Observable<ICustomerDetail[]> {
    return this.customerListQuerySubject$.pipe(
      tap((query: ICustomersListQuery) => {
        Object.keys(query).forEach((k) => {
          if (typeof query[k] != 'number') {
            isEmpty(query[k]) && delete query[k];
          }
          if (query[k] === -1) {
            delete query[k];
          }
        });
      }),
      switchMap((query) => this.queryCustomersListObservable(query))
    );
  }

  queryCustomersListObservable(
    query: Partial<ICustomersListQuery>
  ): Observable<ICustomerDetail[]> {
    this.loadingService.showLoading();
    return this.customerService.getCustomersList(query).pipe(
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

  filterObservable(): void {
    this.subSink.add(
      this.nameFilterSubject$
        .pipe(
          debounceTime(600),
          tap(async (value) => {
            this.filterName = value;
            this.customerListQuerySubject$.next(
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
    this.subSink.add(
      this.addressFilterSubject$
        .pipe(
          debounceTime(600),
          tap(async (value) => {
            this.filterAddress = value;
            this.customerListQuerySubject$.next(
              this.concatEmployeesListQuery({
                address: value,
                currentPage: 1,
                rowsPerPage: this.pagination.pageSize,
              })
            );
          })
        )
        .subscribe()
    );
  }

  clkEdit(element) {
    // this.customerService.getEmployeeDetails(element.id).then((res) => {
    //   if (res) {
    //     const dialogRef = this.dialog.open(EditEmployeeComponent, {
    //       disableClose: true,
    //       autoFocus: false,
    //       data: {
    //         id: res.id,
    //         badgeId: res.badgeId,
    //         name: res.name,
    //         email: res.email,
    //       },
    //     });
    //     this.subSink.add(
    //       dialogRef.afterClosed().subscribe((resAction) => {
    //         if (resAction) {
    //           this.loadData();
    //         }
    //       })
    //     );
    //   }
    // });
  }

  clkDelete(element) {
    // console.log('element', element);
    // const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
    //   width: '500px',
    //   height: 'auto',
    //   data: {
    //     title: 'Delete Selected Employee',
    //     content: 'Are you sure delete the selected Employee?',
    //     noFunc: () => {
    //       dialogRef.close();
    //     },
    //     yesFunc: () => {
    //       this.employeeService.deleteEmployee(element.id).subscribe((res) => {
    //         if (res['status'] == 200) {
    //           dialogRef.close();
    //           this.loadData();
    //         }
    //       });
    //     },
    //   },
    // });
  }

  onPageChange(event: any) {
    this.pagination.pageIndex = event.pageIndex;
    this.pagination.pageSize = event.pageSize;
    this.customerListQuerySubject$.next(
      this.concatEmployeesListQuery({
        currentPage: this.pagination.pageIndex + 1,
        rowsPerPage: this.pagination.pageSize,
      })
    );
  }

  concatEmployeesListQuery(
    data: Partial<ICustomersListQuery>
  ): Partial<ICustomersListQuery> {
    const currentQuery = this.customerListQuerySubject$.getValue();
    return { ...currentQuery, ...data };
  }

}
