import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { IServiceDetail } from 'src/app/models/service/service.model';

@Component({
  selector: 'app-details-service',
  templateUrl: './details-service.component.html',
  styleUrls: ['./details-service.component.scss']
})
export class DetailsServiceComponent implements OnInit {

  constructor(
    private dialogRef: MatDialogRef<DetailsServiceComponent>,
    @Inject(MAT_DIALOG_DATA) public data: IServiceDetail
  ) { }

  ngOnInit(): void {
    console.log(this.data)
  }

}
