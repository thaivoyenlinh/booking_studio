import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ServiceService } from 'src/app/cores/https/service/service.service';
import { IServiceDetail, ServiceEdit } from 'src/app/models/service/service.model';
import { Category, TypeService } from 'src/app/shared/constants/app.constants';

@Component({
  selector: 'app-edit-service',
  templateUrl: './edit-service.component.html',
  styleUrls: ['./edit-service.component.scss']
})
export class EditServiceComponent implements OnInit {

  editServiceForm: FormGroup;
  dataReceive: IServiceDetail;
  serviceEdit = new ServiceEdit();
  status = [
    { Text: "Active", Value: 0 },
    { Text: "InActive", Value: 1 }
  ]
  categoryList = Category;
  typeList = TypeService;
  constructor(
    private formBuilder: FormBuilder,
    private serviceService: ServiceService,
    private dialogRef: MatDialogRef<EditServiceComponent>,
    @Inject(MAT_DIALOG_DATA) public data: IServiceDetail
  ) { }

  ngOnInit(): void {
    this.initForm();
  }

  initForm(){
    this.dataReceive = this.data;
    this.editServiceForm = this.formBuilder.group({
      category: [this.dataReceive.category, Validators.required],
      type: [this.dataReceive.type, Validators.required],
      serviceName: [this.dataReceive.serviceName, Validators.required],
      serviceDetails: [this.dataReceive.serviceDetails, Validators.required],
      price: [this.dataReceive.price, Validators.required],
      status: [this.dataReceive.status]
    })
  }

  clkSave(){
    setTimeout(() => {
      this.serviceEdit.id = this.dataReceive.id;
      this.serviceEdit.category = this.editServiceForm.controls["category"].value;
      this.serviceEdit.type = this.editServiceForm.controls["type"].value;
      this.serviceEdit.serviceName = this.editServiceForm.controls["serviceName"].value;
      this.serviceEdit.serviceDetails = this.editServiceForm.controls["serviceDetails"].value;
      this.serviceEdit.price = this.editServiceForm.controls["price"].value;
      this.serviceEdit.status = this.editServiceForm.controls["status"].value;
      this.serviceService.updateService(this.serviceEdit).subscribe((res) => {
        if(res.status === 200){
          this.dialogRef.close(true);
        }
      })
    }, 500);
  }

}
