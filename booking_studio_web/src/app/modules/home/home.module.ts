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

@NgModule({
  declarations: [
    HomeComponent,
    EmployeeComponent,
    ServiceComponent,
    AddEmployeeComponent,
    EditEmployeeComponent,
  ],
  imports: [
    CommonModule,
    MaterialModule,
    RouterModule,
    SharedModule,
  ]
})
export class HomeModule { }
