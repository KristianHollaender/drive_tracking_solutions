import {Component, OnInit} from '@angular/core';
import {FireService} from "../fire.service";
import {Router} from "@angular/router";
import {MatTableDataSource} from "@angular/material/table";
import {Tour} from "../models/Tour";

@Component({
  selector: 'app-tour-overview',
  templateUrl: './tour-overview.component.html',
  styleUrls: ['./tour-overview.component.scss']
})
export class TourOverviewComponent implements OnInit {
  displayedColumns: string[] = ['id', 'startTime', 'endTime', 'totalTime', 'viewTour'];
  dataSource = new MatTableDataSource<Tour>;

  constructor(public fireService: FireService, private router: Router) {

  }
  async ngOnInit() {
    try {
      const tours = await this.fireService.getTours();
      this.dataSource.data = tours;
    } catch (error) {
      console.error('Error retrieving users:', error);
    }
  }

  async signOut(){
    await this.fireService.signOut().then(() => {
      this.router.navigate(['']);
    })
      .catch((error) => {
        console.log(error);
      });
  }

  async viewTour(tour: Tour){
    alert(`${tour.tourId}`);
  }
}
