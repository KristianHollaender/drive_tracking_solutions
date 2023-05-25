import {Component, OnInit, ViewChild} from '@angular/core';
import {FireService} from "../fire.service";
import {MatTableDataSource} from "@angular/material/table";
import {Tour} from "../models/Tour";
import {MatDialog} from "@angular/material/dialog";
import {TourDetailsComponent} from "../tour-details/tour-details.component";
import {MatPaginator} from "@angular/material/paginator";

@Component({
  selector: 'app-tour-overview',
  templateUrl: './tour-overview.component.html',
  styleUrls: ['./tour-overview.component.scss']
})
export class TourOverviewComponent implements OnInit {
  displayedColumns: string[] = ['driver', 'startTime', 'endTime', 'totalTime', 'viewTour'];
  dataSource = new MatTableDataSource<Tour>;
  isLoading: boolean = true;


  @ViewChild(MatPaginator) paginator!: MatPaginator;


  constructor(public fireService: FireService, private popup: MatDialog,) {
  }

  async ngOnInit() {
    try {
      this.isLoading = true;
      const tours = await this.fireService.getTours();
      this.dataSource.data = await this.populateUserData(tours);
      this.dataSource.paginator = this.paginator;
      this.isLoading = false;
    } catch (error) {
      console.error('Error retrieving users:', error);
    }
  }

  async populateUserData(tours: Tour[]) {
    const updatedTours: Tour[] = [];
    for (let tour of tours) {
      const user = await this.fireService.getUserById(tour.uid);
      const firstName = user.firstname;
      const lastName = user.lastname;
      updatedTours.push(Object.assign({}, tour, {driver: `${firstName} ${lastName}`}));
    }
    console.log(updatedTours);
    return updatedTours;
  }

  async viewTour(row: any) {
    this.popup.open(TourDetailsComponent, {
      data: {
        tour: row
      }
    });
  }

  /**
   * Method for searching in tour-overview table.
   */
  applyFilter(event: Event) {
    const filterValue = (event.target as HTMLInputElement).value;
    this.dataSource.filter = filterValue.trim().toLowerCase();

    if (this.dataSource.paginator) {
      this.dataSource.paginator.firstPage();
      this.dataSource.paginator = this.paginator;
    }
  }
}
