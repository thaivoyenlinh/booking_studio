import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { IEmployeeDetail } from 'src/app/models/employee/employee.model';

@Component({
  selector: 'app-details-employee',
  templateUrl: './details-employee.component.html',
  styleUrls: ['./details-employee.component.scss']
})
export class DetailsEmployeeComponent implements OnInit {

  constructor(
    private dialogRef: MatDialogRef<DetailsEmployeeComponent>,
    @Inject(MAT_DIALOG_DATA) public data: IEmployeeDetail
  ) { }

  ngOnInit(): void {
  }

}
