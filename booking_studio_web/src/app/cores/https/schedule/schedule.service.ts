import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { shareReplay } from 'rxjs';
import { ISchedulesList, ISchedulesListQuery } from 'src/app/models/schedule/schedule.model';
import { environment } from 'src/app/shared/models/environment/envconfig.model';

@Injectable({
  providedIn: 'root'
})
export class ScheduleService {

  baseURL = environment.serverURL; 
  constructor(private http: HttpClient) { }


  getSchedulesList(query: Partial<ISchedulesListQuery>) {
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
    const url = `${this.baseURL}/schedule/pagination?${urlQueries.join('&')}`;
    return this.http.get<ISchedulesList>(url).pipe(shareReplay());
  }
}
