import {Component, OnInit, ViewChild} from '@angular/core';
import {Router} from "@angular/router";
import {MatSidenav} from "@angular/material/sidenav";
import {BreakpointObserver} from "@angular/cdk/layout";
import {FireService} from "../fire.service";

@Component({
  selector: 'app-side-nav',
  templateUrl: './side-nav-admin.component.html',
  styleUrls: ['./side-nav-admin.component.scss']
})
export class SideNavAdminComponent implements OnInit {

  profilePicture: any;
  private user: any;

  requests: any[] = [];
  errors: any[] = [];

  @ViewChild(MatSidenav)
  sidenav!: MatSidenav;

  constructor(private router: Router, private observer: BreakpointObserver, private fireService: FireService) {
  }

  async ngOnInit() {
    this.observer.observe(['(max-width: 1500px)']).subscribe((res) => {
      if (res.matches) {
        this.sidenav.mode = 'over';
        this.sidenav.close();
      } else {
        this.sidenav.mode = 'side';
        this.sidenav.open();
      }
    });
  }

  /**
   * Method for logging out, removing token from localstorage and reroutes to loginPage again.
   */
  async logOut() {
    await this.fireService.signOut().then(() => {
      this.router.navigate(['']);
    })
      .catch((error) => {
        console.log(error);
      });
  }

}
