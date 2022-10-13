import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { Router } from '@angular/router';
import { LoadingService } from '../loading/loading.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
})
export class HeaderComponent implements OnInit {
  @Output() toggleSideBarForMe: EventEmitter<any> = new EventEmitter();
  constructor(private router: Router, private loadingService: LoadingService) {}

  ngOnInit(): void {}

  toggleSideBar() {
    this.toggleSideBarForMe.emit();
  }

  logOut = () => {
    this.loadingService.loading.next(true);
    setTimeout(() => {
      this.loadingService.loading.next(false);
      this.router.navigateByUrl('/');
      localStorage.removeItem('token');
    }, 500);
  };
}
