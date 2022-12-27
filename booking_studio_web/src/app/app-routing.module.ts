import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './modules/auth/login/login.component';
import { RegisterComponent } from './modules/auth/register/register.component';
import { EmployeeComponent } from './modules/employee/employee.component';
import { HomeComponent } from './modules/home/home.component';
import { ServiceComponent } from './modules/service/service.component';
import { AuthGuard } from './cores/guards/auth.guard';
import { DashboardComponent } from './modules/dashboard/dashboard.component';
import { CustomerComponent } from './modules/customer/customer.component';
import { ScheduleComponent } from './modules/schedule/schedule.component';
import { EmployeeManagementComponent } from './modules/employee-management/employee-management.component';

const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: "full" },
  {
    path: 'home',
    component: HomeComponent,
    canActivate: [AuthGuard],
    children: [
      { path: 'dashboard', component: DashboardComponent },
      {
        path: 'employee',
        component: EmployeeComponent,
      },
      { path: 'employee-management', component: EmployeeManagementComponent},
      { path: 'service', component: ServiceComponent },
      { path: 'customer', component: CustomerComponent },
      { path: 'schedule', component: ScheduleComponent}
    ],
  },
  { path: 'register', component: RegisterComponent },
  { path: 'login', component: LoginComponent },
  { path: '**', redirectTo: '/login' },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
