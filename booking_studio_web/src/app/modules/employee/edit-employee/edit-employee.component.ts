import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { debounceTime } from 'rxjs/operators';
import { EmployeeService } from 'src/app/cores/https/employee/employee.service';
import { EmployeeEdit, IEmployeeDetail } from 'src/app/models/employee/employee.model';

@Component({
  selector: 'app-edit-employee',
  templateUrl: './edit-employee.component.html',
  styleUrls: ['./edit-employee.component.scss']
})
export class EditEmployeeComponent implements OnInit {

  editEmployeeForm: FormGroup;
  dataReceive: IEmployeeDetail;
  employeeEdit = new EmployeeEdit();
  firstName: string;
  lastName: string;
  constructor(
    private formBuilder: FormBuilder,
    private employeeService: EmployeeService,
    private dialogRef: MatDialogRef<EditEmployeeComponent>,
    @Inject(MAT_DIALOG_DATA) public data: IEmployeeDetail
  ) { }

  ngOnInit(): void {
    this.initForm();
    this.onEditEmployeeFormValueChange();
  }

  initForm(){
    this.dataReceive = this.data;
    let [firstName, ...lastName] = this.dataReceive.name.split(" ");
    this.firstName = firstName;
    this.lastName =  lastName.join(" ") 
    this.editEmployeeForm = this.formBuilder.group({
      badgeId: [this.dataReceive.badgeId, Validators.required],
      firstName: [this.firstName, Validators.required],
      lastName: [this.lastName, Validators.required],
      email: [this.dataReceive.email, Validators.required]
    });
  }

  onEditEmployeeFormValueChange(){
    this.editEmployeeForm.valueChanges.pipe(debounceTime(600)).subscribe(
      (value) => {

      }
    )
  }

  

  clkSave(){
    setTimeout(() => {
      this.employeeEdit.id = this.dataReceive.id;
      this.employeeEdit.badgeId = this.editEmployeeForm.controls["badgeId"].value;
      this.employeeEdit.firstName = this.editEmployeeForm.controls["firstName"].value;
      this.employeeEdit.lastName = this.editEmployeeForm.controls["lastName"].value;
      this.employeeEdit.email = this.editEmployeeForm.controls["email"].value;
      this.employeeService.updateEmployee(this.employeeEdit).subscribe((res) => {
        if(res.status === 200){
          this.dialogRef.close(true);
        }
      })
    }, 500);
  }

}
