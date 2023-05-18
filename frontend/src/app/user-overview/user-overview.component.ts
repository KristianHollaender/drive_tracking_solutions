import {Component, OnInit} from '@angular/core';
import {FireService} from "../fire.service";

@Component({
  selector: 'app-user-overview',
  templateUrl: './user-overview.component.html',
  styleUrls: ['./user-overview.component.scss']
})
export class UserOverviewComponent implements OnInit{
  displayedColumns: string[] = ['id', 'email', 'firstName', 'lastName'];


  constructor(private fireService: FireService) {
  }

  async ngOnInit() {

  }


}
