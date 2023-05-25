import {Component, Inject, OnInit} from '@angular/core';
import {Tour} from "../models/Tour";
import {FormControl, FormGroup} from "@angular/forms";
import {FireService} from "../fire.service";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {MatSnackBar} from "@angular/material/snack-bar";
import {TourOverviewComponent} from "../tour-overview/tour-overview.component";
import {Pause} from "../models/Pause";
import {CheckPoint} from "../models/CheckPoint";
//@ts-ignore
import moment from 'moment/moment';


@Component({
  selector: 'app-tour-details',
  templateUrl: './tour-details.component.html',
  styleUrls: ['./tour-details.component.scss']
})
export class TourDetailsComponent implements OnInit {
  tour!: Tour;
  tourId: any;
  pauses: Pause[] = [];
  checkpoints: CheckPoint[] = [];

  geoCoder = new google.maps.Geocoder();

  // Getting startPoint from the selected tour
  startPoint = {
    lat: parseFloat(this.data.tour.startPoint._latitude),
    lng: parseFloat(this.data.tour.startPoint._longitude),
  };

  // Getting endPoint from the selected tour
  endPoint = {
    lat: parseFloat(this.data.tour.endPoint._latitude),
    lng: parseFloat(this.data.tour.endPoint._longitude)
  };

  // Getting data from the selected tour
  viewTour = new FormGroup({
    uid: new FormControl(""),
    tourId: new FormControl(this.data.tour.tourId),
    startTime: new FormControl(this.formatTime(this.data.tour.startTime)),
    endTime: new FormControl(this.formatTime(this.data.tour.endTime)),
    totalTime: new FormControl(this.data.tour.totalTime),
    totalPauseTime: new FormControl(this.data.tour.totalPauseTime),
    startPoint: new FormControl(""),
    endPoint: new FormControl(""),
    note: new FormControl(this.data.tour.note),
  });

  zoom = 5.75;
  center: google.maps.LatLngLiteral = this.startPoint;
  startPosition: google.maps.LatLngLiteral[] = [];
  endPosition: google.maps.LatLngLiteral[] = [];
  checkPointPosition: google.maps.LatLngLiteral[] = [];

  constructor(private fireService: FireService,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private _snackBar: MatSnackBar,
              private dialogRef: MatDialogRef<TourOverviewComponent>) {
  }

  async ngOnInit() {
    await this.getDriverName();
    await this.getStartPointAddress();
    await this.getEndPointAddress();
    await this.getPauses()
    await this.setEndAndStartMarkers();
    await this.centerMapBetweenMarkers();
  }

  async getStartPointAddress() {
    const response = await this.geoCoder.geocode({location: this.startPoint});
    const result = response.results[0];
    const startPointAddress = result.formatted_address;
    this.viewTour.get('startPoint')?.setValue(startPointAddress)
  }

  async getEndPointAddress() {
    const response = await this.geoCoder.geocode({location: this.endPoint});
    const result = response.results[0];
    const endPointAddress = result.formatted_address;
    this.viewTour.get('endPoint')?.setValue(endPointAddress)
  }

  async getDriverName() {
    const user = await this.fireService.getUserById(this.data.tour.uid);
    const firstName = user.firstname;
    const lastName = user.lastname
    const driverName = firstName + ' ' + lastName;
    this.viewTour.get('uid')?.setValue(driverName);
  }

  async getCheckPoints() {
    this.checkpoints = await this.fireService.getCheckPointsOnTour(this.data.tour.tourId);
    return this.checkpoints;
  }

  // Places the checkpoints on the Google Map
  async placeCheckpoints() {
    await this.getCheckPoints();
    let checkpointLatLng: google.maps.LatLngLiteral[] = [];
    for (const checkPoint of this.checkpoints) {
      let truckStops = {
        lat: checkPoint['truckStop']['_latitude'],
        lng: checkPoint['truckStop']['_longitude']
      }
      checkpointLatLng.push(truckStops);
    }
    this.checkPointPosition = checkpointLatLng;
    this.center = this.checkPointPosition[0];
    this.zoom = 7.5;
  }

  goToStartPoint() {
    this.center = this.startPoint;
    this.zoom = 10.0;
  }

  goToEndPoint() {
    this.center = this.endPoint;
    this.zoom = 10.0;
  }

  setEndAndStartMarkers() {
    this.startPosition.push(this.startPoint);
    this.endPosition.push(this.endPoint)
  }

  centerMapBetweenMarkers() {
    const avgLat = (this.startPoint.lat + this.endPoint.lat) / 2;
    const avgLng = (this.startPoint.lng + this.endPoint.lng) / 2;
    this.center = {lat: avgLat, lng: avgLng};
  }

  // Function to format time as a string
  formatTime(time) {
    return new Date(time).toLocaleString("en-US");
  }

  // This timestamp is used to format the time from pauses to a better timeformat
  timestamp(timeStamp: Object) {
    var t = new Date(1970, 0, 1); // Epoch
    var seconds = timeStamp['_seconds'];
    t.setSeconds(seconds);
    return moment(t, "YYYYMMDD");
  }

  async getPauses() {
    this.pauses = await this.fireService.getPauseOnTour(this.data.tour.tourId);
  }
}
