import { Injectable } from '@angular/core';
import { environment } from 'src/app/shared/models/environment/envconfig.model';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class DashboardService {

  baseURL = environment.serverURL; 
  constructor(private http: HttpClient) { }

  getDataForChartRevenue(year){
    const url = `${this.baseURL}/receipt/getReceiptChartData?year=${year}`;
    return this.http.get(url);
  }
}
