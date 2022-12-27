import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ICustomerDetail, ICustomersList, ICustomersListQuery } from 'src/app/models/customer/customer.model';
import { environment } from 'src/app/shared/models/environment/envconfig.model';
import { shareReplay } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CustomerService {

  baseURL = environment.serverURL; 
  constructor(private http: HttpClient) { }

  getCustomersList(query: Partial<ICustomersListQuery>) {
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
    const url = `${this.baseURL}/customer/pagination?${urlQueries.join('&')}`;
    return this.http.get<ICustomersList>(url).pipe(shareReplay());
  }

  getAllUser(){
    const url = `${this.baseURL}/customer/getAllCustomer`;
    return this.http.get(url);
  }

  getEmployeeDetails(employeeAccountId: string){
    const url = `${this.baseURL}/customer/details?CustomerAccountId=${employeeAccountId}`;
    return this.http.post<ICustomerDetail>(url,'').toPromise()
  }

}
