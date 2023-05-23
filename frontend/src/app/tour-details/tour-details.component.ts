import {Component, Inject, OnInit} from '@angular/core';
import {Tour} from "../models/Tour";
import {FormControl, FormGroup} from "@angular/forms";
import {FireService} from "../fire.service";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {MatSnackBar} from "@angular/material/snack-bar";
import {TourOverviewComponent} from "../tour-overview/tour-overview.component";


@Component({
  selector: 'app-tour-details',
  templateUrl: './tour-details.component.html',
  styleUrls: ['./tour-details.component.scss']
})
export class TourDetailsComponent{

  tour: Tour | undefined;
  isLoading: boolean | undefined;

  viewTour = new FormGroup({
    uid: new FormControl(this.data.tour.uid),
    tourId: new FormControl(this.data.tour.tourId),
    startTime: new FormControl(this.data.tour.startTime),
    endTime: new FormControl(this.data.tour.endTime),
    totalTime: new FormControl(this.data.tour.totalTime),
    totalPauseTime: new FormControl(this.data.tour.totalPauseTime),
    startPoint: new FormControl(this.data.tour.startPoint),
    endPoint: new FormControl(this.data.tour.endPoint),
    note: new FormControl(this.data.tour.note),
  });

  constructor(private fireService: FireService,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private _snackBar: MatSnackBar,
              private dialogRef: MatDialogRef<TourOverviewComponent>) {

  }


  //Method for closing the matDialog
  tourId: any;
  async close() {
    this.isLoading = false;
    this.dialogRef.close();
  }


}
