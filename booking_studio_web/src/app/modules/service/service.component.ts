import { Component, OnInit, Type } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { BehaviorSubject, catchError, debounceTime, delay, finalize, map, Observable, of, Subject, switchMap, tap } from 'rxjs';
import { IEmployeesListQuery } from 'src/app/models/employee/employee.model';
import { IServiceDetail, IServicesList, IServicesListQuery, ServicesListQuery } from 'src/app/models/service/service.model';
import { PAGE_SIZE_OPTIONS, Status } from 'src/app/shared/constants/app.constants';
import { AddServiceComponent } from './add-service/add-service.component';
import { isEmpty } from 'src/app/shared/helpers/is-empty';
import { LoadingService } from 'src/app/shared/components/loading/loading.service';
import { ServiceService } from 'src/app/cores/https/service/service.service';
import { Category, TypeService } from 'src/app/shared/constants/app.constants';
import { SubSink } from 'src/app/shared/models/sub-sink/sub-sink.model';
import { EditServiceComponent } from './edit-service/edit-service.component';
import { DetailsServiceComponent } from './details-service/details-service.component';
import { ConfirmationDialogComponent } from 'src/app/shared/components/confirmation-dialog/confirmation-dialog.component';
import { Direction, Sort } from 'src/app/models/service/service-sort.model';
import { SortBy } from 'src/app/models/service/service-sort.model';
import { SelectionModel } from '@angular/cdk/collections';
@Component({
  selector: 'app-service',
  templateUrl: './service.component.html',
  styleUrls: ['./service.component.scss']
})
export class ServiceComponent implements OnInit {

  panelOpenState = false;
  displayedColumns = ['select' ,'category', 'type', 'serviceName', 'price', 'status', 'action'];
  displayedColumnFilters = ['selectFilter' ,'categoryFilter', 'typeFilter', 'serviceNameFilter', 'priceFilter', 'statusFilter', 'actionFilter']
  selection = new SelectionModel<IServiceDetail>(true, []);
  subSink = new SubSink();
  serviceList$:  Observable<IServiceDetail[]>;
  servicesListQuerySubject$ = new BehaviorSubject<Partial<IServicesListQuery>>({});
  pagination = {
    pageIndex: 0,
    pageSize: PAGE_SIZE_OPTIONS[0],
    totalRecords: 0,
    pageSizeOptions: PAGE_SIZE_OPTIONS
  }
  selectAllOption = {
    Text: "All",
    Value: ""
  }
  selectedCategory: any;
  categoryList = Category;
  categoryFilterSubject$ = new Subject<string>();
  filterCategory: string;
  typeList = TypeService;
  selectedType: any;
  typeFilterSubject$ = new Subject<string>();
  filterType: string;
  statusList = Status;
  selectedStatus: any;
  statusFilterSubject$ = new Subject<string>();
  filterStatus: string;
  serviceNameFilterSubject$ = new Subject<string>();
  filterServiceName: string;
  sorting?: Sort;
  serviceListTmp: IServicesList;
  idListUpdateBanner: number[] = [];
  listBannersService: any;
  
  constructor(
    private dialog: MatDialog,
    private loadingService: LoadingService,
    private serviceService: ServiceService,
  ) { }

  ngOnInit(): void {
    this.setSelectOption();
    this.filterObservable();
    this.loadData();
    this.serviceList$ = this.initServicesListObservable();
    this.getBannersService();
  }

  //To display default option
  setSelectOption(){
    this.selectedCategory = this.selectAllOption.Value;
    this.selectedType = this.selectAllOption.Value;
    this.selectedStatus = this.selectAllOption.Value;
  }

  loadData(){
    const query = new ServicesListQuery();
    query.currentPage = 1;
    query.rowsPerPage = this.pagination.pageSize;
    query.category = this.filterCategory ?? null;
    query.type = this.filterType ?? null;
    query.status = this.filterStatus ?? null;
    query.sortHeader = this.sorting?.sortBy ?? null;
    query.sortOrder = this.sorting?.direction ?? null;
    this.servicesListQuerySubject$.next(query);
  }

  initServicesListObservable(): Observable<IServiceDetail[]> {
    return this.servicesListQuerySubject$.pipe(
      tap((query: IEmployeesListQuery) => {
        console.log("Query before", query)
        Object.keys(query).forEach((k) => {
          if(typeof query[k] != 'number') {
            isEmpty(query[k]) && delete query[k];
          }
          if(query[k] === -1){
            delete query[k];
          }
        })
      }),
      switchMap((query) => this.queryServicesListObservable(query))
    );
  }

  queryServicesListObservable(query: Partial<IServicesListQuery>) : Observable<IServiceDetail[]>{
    console.log("Query",query);
    this.loadingService.showLoading();
    return this.serviceService.getServicesList(query).pipe(
      delay(300),
      tap((res)=> {
        this.serviceListTmp = res;
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

  formatNumber (num) {
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1.")
  }

  updatePaginator(res) {
    this.pagination.totalRecords = res.totalRecords;
    this.pagination.pageIndex = res.currentPage ? res.currentPage - 1 : 0;
  }

  changeCategory(event){
    if(event.source._selected == true && event.isUserInput == true){
      this.categoryFilterSubject$.next(event.source.value);
    }
  }

  changeType(event){
    if(event.source._selected == true && event.isUserInput == true){
      this.typeFilterSubject$.next(event.source.value);
    }
  }

  changeStatus(event){
    if(event.source._selected == true && event.isUserInput == true){
      this.statusFilterSubject$.next(event.source.value);
    }
  }

  filterObservable(): void {
    this.subSink.add(
      this.categoryFilterSubject$.asObservable().pipe(
        tap(async (value) => {
          this.filterCategory = value;
          this.servicesListQuerySubject$.next(
            this.concatServicesListQuery({
              category: value,
              currentPage: 1,
              rowsPerPage: this.pagination.pageSize,
            })
          )
        })
      ).subscribe()
    );
    this.subSink.add(
      this.typeFilterSubject$.pipe(
        tap(async (value) => {
          this.filterType = value;
          this.servicesListQuerySubject$.next(
            this.concatServicesListQuery({
              type: value,
              currentPage: 1,
              rowsPerPage: this.pagination.pageSize,
            })
          )
        })
      ).subscribe()
    );
    this.subSink.add(
      this.serviceNameFilterSubject$.pipe(
        debounceTime(600),
        tap(async (value) => {
          this.filterServiceName = value;
          this.servicesListQuerySubject$.next(
            this.concatServicesListQuery({
              serviceName: value,
              currentPage: 1,
              rowsPerPage: this.pagination.pageSize,
            })
          )
        })
      ).subscribe()
    );
    this.subSink.add(
      this.statusFilterSubject$.pipe(
        tap(async (value) => {
          this.filterStatus = value;
          this.servicesListQuerySubject$.next(
            this.concatServicesListQuery({
              status: value,
              currentPage: 1,
              rowsPerPage: this.pagination.pageSize,
            })
          )
        })
      ).subscribe()
    );
  }

  concatServicesListQuery(data: Partial<IServicesListQuery>) : Partial<IServicesListQuery>{
    const currentQuery = this.servicesListQuerySubject$.getValue();
    return { ...currentQuery, ...data };
  }

  clkAddService(){
    const dialogRef = this.dialog.open(AddServiceComponent, {
      data: {
        categoryList: this.categoryList,
        typeList: this.typeList,
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
    this.serviceService.getServiceDetails(element.id).then(
      (res) => {
        if(res) {
          const dialogRef = this.dialog.open(EditServiceComponent, {
            disableClose: true,
            autoFocus: false,
            data: {
              id: res.id,
              category: res.category,
              type: res.type,
              serviceName: res.serviceName,
              serviceDetails: res.serviceDetails,
              price: res.price,
              status: res.status,
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

  clkInformationDetails(element){
    this.serviceService.getServiceDetails(element.id).then(
      (res) => {
        if(res) {
          const dialogRef = this.dialog.open(DetailsServiceComponent, {
            disableClose: false,
            autoFocus: false,
            width: "800px",
            data: {
              id: res.id,
              category: res.category,
              type: res.type,
              serviceName: res.serviceName,
              serviceDetails: res.serviceDetails,
              price: res.price,
              status: res.status,
              image: res.image
            }
          });
          this.subSink.add(
            dialogRef.afterClosed().subscribe((resAction) => {
              if(resAction) {
                // this.loadData();
              }
            })
          )
        }
      }
    );
  }

  clkDelete(element){
    const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
      width: '500px',
      height: 'auto',
      data: {
        title: "Delete Selected Service",
        content: 'Are you sure delete the selected Service?',
        noFunc: () => {
          dialogRef.close();
        },
        yesFunc: () => {
          this.serviceService.deleteService(element.id).subscribe((res) => {
            if(res['status'] == 200){
              dialogRef.close();
              this.loadData();
            }
          });
        }
      }
    });
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

  isAllSelected() {
    const numSelected = this.selection.selected.length;
    const numRows = this.serviceListTmp.totalRecords;
    return numSelected === numRows;
  }

  masterToggle() {
    this.isAllSelected() ?
        this.selection.clear() :
        this.serviceListTmp.rows.forEach(row => this.selection.select(row));
  }

  getBannersService(){
    this.serviceService.getBannersService().subscribe(
      (res) => {
        this.listBannersService = res['rows']
        console.log(this.listBannersService)
      }
    );
  }

  clkAddBannerService(){
    console.log(this.listBannersService.length);
    if( this.listBannersService.length + this.selection.selected.length < 5 && 
      this.selection.selected.length > 0){
      this.selection.selected.forEach(
        item => {
          this.idListUpdateBanner.push(item.id)
        }
        )
      this.serviceService.updateSliderBanner(this.idListUpdateBanner)
      .subscribe(
        (res) => {
          this.idListUpdateBanner = []
          // this.loadData();
          this.getBannersService();
          this.selection.clear();
        }
      );
    } else {
      const dialogRef = this.dialog.open(ConfirmationDialogComponent, {
        width: '500px',
        height: 'auto',
        data: {
          title: "Warning",
          content: 'Banner must have at least one service and a maximum of five services',
          okFunc: () => {
            dialogRef.close();
          },
        }
      });
    }
  }

  onPageChange(event: any) {
    this.pagination.pageIndex = event.pageIndex;
    this.pagination.pageSize = event.pageSize;
    this.servicesListQuerySubject$.next(
      this.concatEmployeesListQuery({
        currentPage: this.pagination.pageIndex + 1,
        rowsPerPage: this.pagination.pageSize,
      })
    );
  }

  concatEmployeesListQuery(
    data: Partial<IEmployeesListQuery>
  ): Partial<IEmployeesListQuery> {
    const currentQuery = this.servicesListQuerySubject$.getValue();
    return { ...currentQuery, ...data };
  }

  get sortBy() {
    return SortBy;
  }

  get direction(){
    return Direction;
  }

  clkConfirm(serviceId){
    const status = 1;
    this.loadingService.showLoading();
    this.serviceService.removeServiceFromBanner(serviceId).subscribe(
      (res) => {
        this.loadingService.hideLoading();
        // this.loadData();
        this.getBannersService();
      }
    );
  }

}
