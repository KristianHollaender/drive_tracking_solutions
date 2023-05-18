import {Component, OnInit} from '@angular/core';
import {FireService} from "../fire.service";

@Component({
  selector: 'app-tour-overview',
  templateUrl: './tour-overview.component.html',
  styleUrls: ['./tour-overview.component.scss']
})
export class TourOverviewComponent implements OnInit{
  constructor(private fireService: FireService) {

  }
  async ngOnInit() {

  }

}
