import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ServiceService } from 'src/app/cores/https/service/service.service';

@Component({
  selector: 'app-add-service',
  templateUrl: './add-service.component.html',
  styleUrls: ['./add-service.component.scss']
})
export class AddServiceComponent implements OnInit {

  addServiceForm: FormGroup;
  selectAllOption = {
    Text: "All",
    Value: ""
  }
  status = [
    { Text: "Active", Value: 0 },
    { Text: "InActive", Value: 1 }
  ]

  discountOptions = [
    { Text: "10%", Value: 10 },
    { Text: "15%", Value: 15 },
    { Text: "20%", Value: 20 },
  ]

  constructor(
    private formBuilder: FormBuilder,
    private dialogRef: MatDialogRef<any>,
    private serviceService: ServiceService,
    @Inject(MAT_DIALOG_DATA)
    public data: {
      categoryList: any;
      typeList: any;
      yesFunc: (value?: any) => any;
      noFunc: (value?: any) => any;
    }
  ) { }

  ngOnInit(): void {
    this.addServiceForm = this.formBuilder.group({
      category: [''],
      type: [''],
      serviceName: [''],
      serviceDetails: [''],
      price: [''],
      discount: [''],
      status: [0],
      fileUploadBanner: [''],
      fileUpload: ['']
    })
  }

  clkSave(){
    setTimeout(() => {
      this.serviceService
        .addService(this.addServiceForm.value)
        .subscribe((res) => {
          console.log("res",res);
          console.log(res['status']);
          if (res['status']) {
            this.data.yesFunc();
            this.dialogRef.close(true);
          }
        });
    }, 500);
  }
}
