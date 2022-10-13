import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, shareReplay } from 'rxjs';
import { IEmployeeDetail, EmployeeEdit, IEmployeesList, IEmployeesListQuery } from 'src/app/models/employee/employee.model';
import { environment } from 'src/app/shared/models/environment/envconfig.model';

@Injectable({
  providedIn: 'root'
})
export class EmployeeService {

  baseURL = environment.serverURL; 
  constructor(private http: HttpClient) { }

  addEmployee(data: any) {
    const newForm = new FormData();
    newForm.append('BadgeId', data.badgeId);
    newForm.append('FirstName', data.firstName);
    newForm.append('LastName', data.lastName);
    newForm.append('Email', data.email);
    newForm.append('Image', data.fileUpload._files[0], data.fileUpload._fileNames);
    return this.http.post(this.baseURL + '/employee/add', newForm);
  }

  getEmployeesList(query: Partial<IEmployeesListQuery>) {
    const urlQueries = Object.keys(query).reduce((result, queryKey) => {
      const queryValue = query[queryKey];
      if(Array.isArray(queryValue)) {
        queryValue.forEach((value) => 
          result.push(`${queryKey}=${encodeURIComponent(value)}`)
        );
      } else if(queryValue !== undefined && queryValue !== null) {
        result.push(`${queryKey}=${encodeURIComponent(queryValue)}`);
      }
      return result;
    }, []);
    const url = `${this.baseURL}/employee/pagination?${urlQueries.join('&')}`;
    return this.http.get<IEmployeesList>(url).pipe(shareReplay());
  }

  getEmployeeDetails(employeeId: number){
    const url = `${this.baseURL}/employee/details?Id=${employeeId}`;
    return this.http.get<IEmployeeDetail>(url).toPromise();
  }

  updateEmployee(params: EmployeeEdit){
    const url = `${this.baseURL}/employee/update`;
    return this.http.put<IEmployeeDetail>(url, params, {
      //to get status of api
      headers: {
        'content-type': 'application/json',
      },
      observe: 'response',
    });
  }

  deleteEmployee(employeeId: number){
    console.log("employeeId service",employeeId);
    const url = `${this.baseURL}/employee/delete?EmployeeId=${employeeId}`;
    return this.http.delete(url);
  }

}
