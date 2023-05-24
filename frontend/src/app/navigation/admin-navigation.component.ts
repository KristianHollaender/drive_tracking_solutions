import {Component, OnInit, ViewChild} from '@angular/core';
import {Router} from "@angular/router";
import {MatSidenav} from "@angular/material/sidenav";
import {BreakpointObserver} from "@angular/cdk/layout";
import {FireService} from "../fire.service";

@Component({
  selector: 'app-navigation',
  templateUrl: './admin-navigation.component.html',
  styleUrls: ['./admin-navigation.component.scss']
})
export class AdminNavigationComponent implements OnInit{
  @ViewChild(MatSidenav)
  sidenav!: MatSidenav;
  firstname: string = '';
  lastname: string = '';

  constructor(private router: Router, public fireService: FireService) {
  }

  async logOut() {
    await this.fireService.signOut().then(() => {
      this.router.navigate(['']);
    })
      .catch((error) => {
        console.log(error);
      });
  }

  async ngOnInit() {
    localStorage.getItem('token');
    this.firstname = this.fireService.user.firstname;
    this.lastname = this.fireService.user.lastname;
    console.log(this.firstname, this.lastname);
  }

}
