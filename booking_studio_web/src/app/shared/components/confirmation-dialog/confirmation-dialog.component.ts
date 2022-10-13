import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-confirmation-dialog',
  templateUrl: './confirmation-dialog.component.html',
  styleUrls: ['./confirmation-dialog.component.scss']
})
export class ConfirmationDialogComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA)
    public data: {
      title: string;
      content: string;
      yesFunc?: (value?: any) => any;
      noFunc?: (value?: any) => any;
    }
  ) { }

  ngOnInit(): void {
  }

  clkYes() {
    if(this.data.yesFunc){
      this.data.yesFunc();
    }
  }

  clkNo(){
    if(this.data.noFunc){
      this.data.noFunc();
    }
  }

}
