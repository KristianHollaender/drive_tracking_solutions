import {Component, Inject, OnInit} from '@angular/core';
import {Tour} from "../models/Tour";
import {FormControl, FormGroup} from "@angular/forms";
import {FireService} from "../fire.service";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {MatSnackBar} from "@angular/material/snack-bar";
import {TourOverviewComponent} from "../tour-overview/tour-overview.component";
import {response} from "express";
import {object} from "firebase-functions/lib/v1/providers/storage";
import {Pause} from "../models/Pause";


@Component({
  selector: 'app-tour-details',
  templateUrl: './tour-details.component.html',
  styleUrls: ['./tour-details.component.scss']
})
export class TourDetailsComponent implements OnInit{

  async ngOnInit() {
    await this.getStartPointAddress();
    await this.getEndPointAddress();
    await this.setEndAndStartMarkers();
    await this.centerMapBetweenMarkers();
    await this.getDriverName();
    await this.getPauses();
  }


  tour: Tour | undefined;
  pauses: [] = [];
  isLoading: boolean | undefined;
  geoCoder = new google.maps.Geocoder();


  startPoint = {
    lat: parseFloat(this.data.tour.startPoint._latitude),
    lng: parseFloat(this.data.tour.startPoint._longitude),
  };
  async getStartPointAddress(){
    const response = await this.geoCoder.geocode({location: this.startPoint});
    const result = response.results[0];
    const startPointAddress = result.formatted_address;
    console.log(startPointAddress);
    this.viewTour.get('startPoint')?.setValue(startPointAddress)
  }


  endPoint = {
    lat: parseFloat(this.data.tour.endPoint._latitude),
    lng: parseFloat(this.data.tour.endPoint._longitude)
  };
  async getEndPointAddress(){
    const response = await this.geoCoder.geocode({location: this.endPoint});
    const result = response.results[0];
    const endPointAddress = result.formatted_address;
    console.log(endPointAddress);
    this.viewTour.get('endPoint')?.setValue(endPointAddress)
  }

  async getDriverName(){
    const user = await this.fireService.getUserById(this.data.tour.uid);
    const firstName = user.firstname;
    const lastName = user.lastname
    const driverName = firstName + ' ' + lastName;
    this.viewTour.get('uid')?.setValue(driverName);
  }

  async getPauses() {
    const pauses = await this.fireService.getPauseData(this.data.tour.tourId);
    const pauseData: Pause[] = [];

    for (let pause of pauses) {
      const startTime = pause.startTime;
      const endTime = pause.endTime;
      const pauseId = pause.pauseId;
      const totalTime = pause.totalTime;

      //TODO FIX THIS SO IT DOESNT DO AN ARRAY OF 8 BUT ARRAY OF PAUSES WITH VARIABLES ABOVE
      pauseData.push(startTime, endTime, pauseId, totalTime);
    }
    console.log(pauseData);
  }

  center: google.maps.LatLngLiteral = this.startPoint;
  zoom = 5.75;
  startPosition: google.maps.LatLngLiteral[] = [];
  endPosition: google.maps.LatLngLiteral[] = [];

  setEndAndStartMarkers() {
    // @ts-ignore
    this.startPosition.push(this.startPoint);
    this.endPosition.push(this.endPoint);
  }

  centerMapBetweenMarkers() {
    const avgLat = (this.startPoint.lat + this.endPoint.lat) / 2;
    const avgLng = (this.startPoint.lng + this.endPoint.lng) / 2;
    this.center = { lat: avgLat, lng: avgLng };
  }

  viewTour = new FormGroup({
    uid: new FormControl(""),
    tourId: new FormControl(this.data.tour.tourId),
    startTime: new FormControl(this.formatTime(this.data.tour.startTime)),
    endTime: new FormControl(this.formatTime(this.data.tour.startTime)),
    totalTime: new FormControl(this.data.tour.totalTime),
    totalPauseTime: new FormControl(this.data.tour.totalPauseTime),
    startPoint: new FormControl(""),
    endPoint: new FormControl(""),
    note: new FormControl(this.data.tour.note),
  });


  constructor(private fireService: FireService,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private _snackBar: MatSnackBar,
              private dialogRef: MatDialogRef<TourOverviewComponent>,
  ) {}

  //Method for closing the matDialog
  tourId: any;

  async close() {
    this.isLoading = false;
    this.dialogRef.close();
  }

  // Function to format time as a string
  formatTime(time) {
    return new Date(time).toLocaleString("en-US");
  }




}
