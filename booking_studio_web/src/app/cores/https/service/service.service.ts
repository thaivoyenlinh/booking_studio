import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { shareReplay } from 'rxjs';
import { IBannersService, IServiceDetail, IServicesList, IServicesListQuery, ServiceEdit } from 'src/app/models/service/service.model';
import { environment } from 'src/app/shared/models/environment/envconfig.model';

@Injectable({
  providedIn: 'root'
})
export class ServiceService {

  baseURL = environment.serverURL; 
  constructor(private http: HttpClient) { }

  getServicesList(query: Partial<IServicesListQuery>) {
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
    const url = `${this.baseURL}/service/pagination?${urlQueries.join('&')}`;
    return this.http.get<IServicesList>(url).pipe(shareReplay());
  }

  getAllTmp(){
    const url = `${this.baseURL}/service/pagination?CurrentPage=1&RowsPerPage=100`;
    return this.http.get<IServicesList>(url).pipe(shareReplay());
  }

  addService(data: any) {
    const newForm = new FormData();
    newForm.append('Category', data.category);
    newForm.append('Type', data.type);
    newForm.append('ServiceName', data.serviceName);
    newForm.append('ServiceDetails', data.serviceDetails);
    newForm.append('price', data.price);
    newForm.append('Discount', data.discount);
    newForm.append('Status', data.status);
    newForm.append('BannerImage', data.fileUploadBanner._files[0], data.fileUploadBanner._fileNames)
    for (let i = 0; i < data.fileUpload._files.length; i++) {
      newForm.append("Image", data.fileUpload._files[i], data.fileUpload._files[i].name);
    }
    return this.http.post(this.baseURL + '/service/add', newForm);
  }

  getServiceDetails(serviceId: number){
    const url = `${this.baseURL}/service/details?Id=${serviceId}`;
    return this.http.get<IServiceDetail>(url).toPromise();
  }

  updateService(params: ServiceEdit){
    const url = `${this.baseURL}/service/update`;
    return this.http.put<IServiceDetail>(url, params, {
      //to get status of api
      headers: {
        'content-type': 'application/json',
      },
      observe: 'response',
    });
  }

  deleteService(serviceId: number){
    console.log("employeeId service",serviceId);
    const url = `${this.baseURL}/service/delete?ServiceId=${serviceId}`;
    return this.http.delete(url);
  }

  updateSliderBanner(listId: any){
    const params = { "id": listId}
    const url = `${this.baseURL}/service/update-banner`;
    return this.http.post<IServiceDetail>(url, params
    );
  }

  getBannersService(){
    const url = `${this.baseURL}/service/banners`;
    return this.http.get<IBannersService>(url);
  }

  removeServiceFromBanner(serviceId: number){
    const url = `${this.baseURL}/service/removeServiceFromBanner?serviceId=${serviceId}`;
    return this.http.post(url, "");
  }

}
