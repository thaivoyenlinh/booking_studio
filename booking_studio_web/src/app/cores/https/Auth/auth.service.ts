import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { EmailValidator } from '@angular/forms';
import { Observable } from 'rxjs';
import { IUser } from 'src/app/models/authentication/user.model';
import { map } from "rxjs/operators";

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  baseURL = 'https://localhost:5001';
  isLoggedIn: boolean;
  currentUser: IUser = {
    username: null,
    email: null,
    result: null,
    token: null,
  }
  constructor(private http: HttpClient) {}

  login(request: any): Observable<IUser>{
    return this.http.post<IUser>(this.baseURL + '/identity/login', request).pipe(
      map((res) => {
        this.isLoggedIn = res.result.succeeded;
        this.currentUser.username = res.username;
        this.currentUser.email = res.email;

        localStorage.setItem('token', res.token);
        return this.currentUser;
      })
    );
  }

  logout(){
    this.isLoggedIn = false;
  }

  register(request: any) : Observable<void>{
    return this.http.post<void>(this.baseURL + '/identity/register', request);
  }

}
