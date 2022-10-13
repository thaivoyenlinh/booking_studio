import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ILoginModel } from 'src/app/models/authentication/login.model';
import {
  HttpClient,
  HttpErrorResponse,
  HttpHeaders,
} from '@angular/common/http';
import { FormControl, FormGroup, NgForm } from '@angular/forms';
import { IAuthenticatedResponse } from 'src/app/models/authentication/authenticated-response.model';
import { AuthService } from 'src/app/cores/https/Auth/auth.service';
import { LoadingService } from 'src/app/shared/components/loading/loading.service';
import { delay, finalize, tap } from 'rxjs';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent implements OnInit {
  SignInForm: FormGroup;
  hide = true;
  constructor(
    public router: Router,
    private authService: AuthService,
    private loadingService: LoadingService
  ) {}

  ngOnInit(): void {
    this.SignInForm = new FormGroup({
      username: new FormControl(''),
      password: new FormControl(''),
    });
  }

  onSubmit() {
    if (this.SignInForm.invalid) {
      return;
    } else {
      this.loadingService.showLoading();
      this.authService
        .login(this.SignInForm.value)
        .pipe(
          delay(500),
          finalize(() => this.loadingService.hideLoading()),
          tap(
            (res) => {
              this.router.navigateByUrl('/home');
            },
            (err) => {
              console.log(err.error);
            }
          )
        )
        .subscribe();
    }
  }
}
