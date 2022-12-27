import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { shareReplay } from 'rxjs';
import { IEmployeeDetail, EmployeeEdit, IEmployeesList, IEmployeesListQuery, IAccountInfo } from 'src/app/models/employee/employee.model';
import { environment } from 'src/app/shared/models/environment/envconfig.model';

@Injectable({
  providedIn: 'root'
})
export class EmployeeService {

  baseURL = environment.serverURL; 
  constructor(private http: HttpClient) { }

  addEmployee(data: any, userAccountInfo: IAccountInfo) {
    const newForm = new FormData();
    newForm.append('BadgeId', data.badgeId);
    newForm.append('FirstName', data.firstName);
    newForm.append('LastName', data.lastName);
    newForm.append('PhoneNumber', data.phoneNumber);
    newForm.append('Email', data.email);
    newForm.append('Image', data.fileUpload._files[0], data.fileUpload._fileNames);
    newForm.append('EmployeeAccountId', userAccountInfo.userId);
    newForm.append('AccountPasswordGenerate', userAccountInfo.passwordGenerate)
    return this.http.post(this.baseURL + '/employee/add', newForm);
  }

  createEmployeeAccount(data: any)  {
    let role = "Employee";
    let userName = (data.firstName + data.lastName + data.badgeId).replace( /\s/g, '').toLowerCase();
    let password = this.generatePassword(10);
    const newForm = new FormData();
    newForm.append('Username', userName);
    newForm.append('Password', password);
    newForm.append('Email', data.email);
    newForm.append('Role', role);
    return this.http.post(this.baseURL + '/identity/register', newForm, {responseType: 'text'});
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

  getEmployeeDetails(employeeAccountId: string){
    const url = `${this.baseURL}/employee/details?EmployeeAccountId=${employeeAccountId}`;
    return this.http.post<IEmployeeDetail>(url,'').toPromise()
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
    const url = `${this.baseURL}/employee/delete?EmployeeId=${employeeId}`;
    return this.http.delete(url);
  }

  generatePassword( len ) {
    let length = (len)?(len):(10);
    let string = "abcdefghijklmnopqrstuvwxyz";
    let numeric = '0123456789';
    let punctuation = '!@#$%&';
    let password = "";
    let character = "";
    while( password.length<length ) {
        let entity1 = Math.ceil(string.length * Math.random()*Math.random());
        let entity2 = Math.ceil(numeric.length * Math.random()*Math.random());
        let entity3 = Math.ceil(punctuation.length * Math.random()*Math.random());
        let hold = string.charAt( entity1 );
        hold = (password.length%2==0)?(hold.toUpperCase()):(hold);
        character += hold;
        character += numeric.charAt( entity2 );
        character += punctuation.charAt( entity3 );
        password = character;
    }
    password=password.split('').sort(function(){return 0.5-Math.random()}).join('');
    return password.substr(0,len);
  }

}
