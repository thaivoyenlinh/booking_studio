import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MaterialModule } from 'src/app/shared/material/material.module';
import { RouterModule } from '@angular/router';
import { SharedModule } from 'src/app/shared/shared.module';

import { HomeComponent } from './home.component';
import { EmployeeComponent } from '../employee/employee.component';
import { ServiceComponent } from '../service/service.component';
import { AddEmployeeComponent } from '../employee/add-employee/add-employee.component';
import { EditEmployeeComponent } from '../employee/edit-employee/edit-employee.component';
import { AddServiceComponent } from '../service/add-service/add-service.component';

import { StatusPipe } from '../service/status.pipe';
import { EditServiceComponent } from '../service/edit-service/edit-service.component';
import { DetailsServiceComponent } from '../service/details-service/details-service.component';
import { DashboardComponent } from '../dashboard/dashboard.component';
import { CustomerComponent } from '../customer/customer.component';
import { ScheduleComponent } from '../schedule/schedule.component';
import { EmployeeManagementComponent } from '../employee-management/employee-management.component';
import { AbsenceComponent } from '../absence/absence.component';
import { DetailsEmployeeComponent } from '../employee/details-employee/details-employee.component';

@NgModule({
  declarations: [
    HomeComponent,
    EmployeeComponent,
    ServiceComponent,
    AddEmployeeComponent,
    EditEmployeeComponent,
    AddServiceComponent,
    StatusPipe,
    EditServiceComponent,
    DetailsServiceComponent,
    DashboardComponent,
    CustomerComponent,
    ScheduleComponent,
    EmployeeManagementComponent,
    AbsenceComponent,
    DetailsEmployeeComponent
  ],
  imports: [
    CommonModule,
    MaterialModule,
    RouterModule,
    SharedModule,
  ]
})
export class HomeModule { }
