import { AfterViewInit, Component, ElementRef, OnInit } from '@angular/core';
import { FormControl } from '@angular/forms';
import { Chart, registerables } from 'chart.js';
import { tap } from 'rxjs';
import { CustomerService } from 'src/app/cores/https/customer/customer.service';
import { DashboardService } from 'src/app/cores/https/dashboard/dashboard.service';
import { ServiceService } from 'src/app/cores/https/service/service.service';
import { SubSink } from 'src/app/shared/models/sub-sink/sub-sink.model';
import { mockData } from './order';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit, AfterViewInit {
  selectYearForChart = new FormControl('2022');
  yearOfChart = this.selectYearForChart.value;
  subSink = new SubSink();
  labels: string[] = [];
  data: number[] = [];
  labelYear: string[] = [];
  dataRevenueChart: {};
  chart;
  numberOfCustomer: number = 0;
  numberOfService: number = 0;
  constructor(
    private dashboardService: DashboardService,
    private customerService: CustomerService,
    private serviceService: ServiceService
  ) { 
    Chart.register(...registerables);
  }

  ngOnInit(): void {
    this.getNumberOfUser();
    this.getNumberOfService()
    console.log(this.numberOfService)
    // mockData.forEach(e => this.labels.push(e.month))
    // mockData.forEach(e => this.data.push(e.total))
    // this.chartGenerat
  }
  
  ngAfterViewInit(): void {
    this.init();
  }

  ngOnDestroy(): void {
    this.subSink.unsubscribe();
  }

  init(){
    this.subSink.add(
      this.dashboardService.getDataForChartRevenue(this.yearOfChart).subscribe(
        (res: any[]) => {
          for(var item of res){
            this.labels.push(item.month)
            this.data.push(item.total)
            if(!this.labelYear.includes(item.year)){
              this.labelYear.push(item.yea)
            }
          }
          var chartExist = Chart.getChart("revenueChart"); // <canvas> id
          if (chartExist != undefined)  
            chartExist.destroy(); 
          this.chartGenerate()
        }
      )
    );
  }

  chartGenerate(){
    // const chart = document.getElementById("revenueChart")
    this.chart = new Chart("revenueChart", {
        type: 'bar',
        data: {
            labels: this.labels,
            datasets: [{
                label: 'Revenue',
                data: this.data,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                ],
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true
                }
            },
            responsive: true
        }
    });
  }

  handleSelectYear(){
    this.yearOfChart = this.selectYearForChart.value;
    this.labels = [];
    this.data = [];
    this.init();
  }

  getNumberOfUser(){
    this.customerService.getAllUser().subscribe(
      (res) => {
        console.log("getNumberOfUser", typeof(res))
        this.numberOfCustomer = Object.keys(res).length;
      }
    );
  }

  getNumberOfService(){
    this.serviceService.getAllTmp().subscribe(
      (res) => {
        console.log("getNumberOfUser", res.totalRecords)
        this.numberOfService = res.totalRecords;
      }
    )
  }
  
}
