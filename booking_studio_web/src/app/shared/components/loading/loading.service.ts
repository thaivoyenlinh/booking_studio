import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, share } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoadingService {

  loading = new BehaviorSubject<boolean>(false);
  loading$: Observable<boolean> = this.loading.asObservable();
  constructor() { }

  showLoading(){
    this.loading.next(true);
  }

  hideLoading(){
    this.loading.next(false);
  }
}
