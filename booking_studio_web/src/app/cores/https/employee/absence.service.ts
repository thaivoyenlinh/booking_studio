import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { shareReplay } from 'rxjs';
import { IAbsencesList } from 'src/app/models/employee/absence.moodel';
import { environment } from 'src/app/shared/models/environment/envconfig.model';

@Injectable({
  providedIn: 'root'
})
export class AbsenceService {

  baseURL = environment.serverURL; 
  constructor(private http: HttpClient) { }

  getAbsencesList(query: Partial<IAbsencesList>) {
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
    const url = `${this.baseURL}/absence/pagination?${urlQueries.join('&')}`;
    return this.http.get<IAbsencesList>(url).pipe(shareReplay());
  }

  updateStatusAbsence(absenceId: number, status: number){
    const url = `${this.baseURL}/absence/updateStatusAbsence?AbsenceId=${absenceId}&Status=${status}`;
    return this.http.post(url,'');
  }
}
