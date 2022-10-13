import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { tap } from 'rxjs/operators';
import { AuthService } from 'src/app/cores/https/Auth/auth.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent implements OnInit {
  AccountRegistrationForm: FormGroup;
  // genders: ['male', 'female'];
  hide = true;
  hide_passconfirm = true;
  submitted = false;
  constructor(
    private fb: FormBuilder,
    protected router: Router,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
    this.AccountRegistrationForm = this.fb.group ({
      username: new FormControl(''),
      password: new FormControl(''),
      email: new FormControl('')
    })
  }

  onSubmit(){
    const value = this.AccountRegistrationForm.value;
    this.authService.register(value).pipe(
      tap(
        (data) => {
          this.router.navigateByUrl("/");  
        }
      )
    ).subscribe();
  }

  
  previous_page(): void {
    this.router.navigateByUrl("/");
  }

}
