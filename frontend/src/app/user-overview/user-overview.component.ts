import {Component, OnInit} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import {MatTableDataSource} from "@angular/material/table";
import {User} from "../models/User";

@Component({
  selector: 'app-user-overview',
  templateUrl: './user-overview.component.html',
  styleUrls: ['./user-overview.component.scss']
})
export class UserOverviewComponent implements OnInit{
  displayedColumns: string[] = ['id', 'email', 'firstname', 'lastname'];
  dataSource!: MatTableDataSource<User>;


  constructor(public fireService: FireService, private router: Router) {
  }

  ngOnInit() {
    this.fireService.getUsers();
    this.dataSource = new MatTableDataSource(this.fireService.users);
  }

  async signOut(){
    await this.fireService.signOut().then(() => {
      this.router.navigate(['']);
    })
      .catch((error) => {
        console.log(error);
      });
  }



}
