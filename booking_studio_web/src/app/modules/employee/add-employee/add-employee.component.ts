import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { EmployeeService } from 'src/app/cores/https/employee/employee.service';

@Component({
  selector: 'app-add-employee',
  templateUrl: './add-employee.component.html',
  styleUrls: ['./add-employee.component.scss'],
})
export class AddEmployeeComponent implements OnInit {
  addEmployeeForm: FormGroup;
  multiple: boolean = false;
  accept: string;
  badgeId: number;
  constructor(
    private fb: FormBuilder,
    private employeeService: EmployeeService,
    private dialogRef: MatDialogRef<any>,
    @Inject(MAT_DIALOG_DATA)
    public data: {
      latestBadgeId: number;
      yesFunc: (value?: any) => any;
      noFunc: (value?: any) => any;
    }
  ) {}

  ngOnInit(): void {
    this.badgeId = this.data.latestBadgeId + 1;
    this.addEmployeeForm = this.fb.group({
      badgeId: [this.badgeId],
      firstName: [''],
      lastName: [''],
      email: [''],
      fileUpload: [''],
    });
  }

  clkSave() {
    setTimeout(() => {
      this.employeeService
        .addEmployee(this.addEmployeeForm.value)
        .subscribe((res) => {
          console.log(res['status']);
          if (res['status']) {
            this.data.yesFunc();
            this.dialogRef.close(true);
          }
        });
    }, 500);
  }
}
