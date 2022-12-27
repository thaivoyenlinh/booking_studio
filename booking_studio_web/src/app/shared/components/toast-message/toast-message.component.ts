import { Component, Inject, OnInit } from '@angular/core';
import { MatSnackBarRef, MAT_SNACK_BAR_DATA } from '@angular/material/snack-bar';

@Component({
  selector: 'app-toast-message',
  templateUrl: './toast-message.component.html',
  styleUrls: ['./toast-message.component.scss']
})
export class ToastMessageComponent implements OnInit {

  message: any;
  constructor(public snackBarRef: MatSnackBarRef<ToastMessageComponent>,
              @Inject(MAT_SNACK_BAR_DATA) public data: any) { }

  ngOnInit() {
    // console.log(this.message.title);
    this.message = this.data
  }

}
