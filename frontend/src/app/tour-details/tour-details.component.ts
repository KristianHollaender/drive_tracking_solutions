import {Component, Inject, OnInit} from '@angular/core';
import {Tour} from "../models/Tour";
import {FormControl, FormGroup} from "@angular/forms";
import {FireService} from "../fire.service";
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";
import {MatSnackBar} from "@angular/material/snack-bar";
import {TourOverviewComponent} from "../tour-overview/tour-overview.component";
import {GoogleMapsModule} from "@angular/google-maps";


@Component({
  selector: 'app-tour-details',
  templateUrl: './tour-details.component.html',
  styleUrls: ['./tour-details.component.scss']
})
export class TourDetailsComponent{

  tour: Tour | undefined;
  isLoading: boolean | undefined;
  geoCoder = new google.maps.Geocoder();
  startPointAddress : any;


  startPoint = {
    lat: parseFloat(this.data.tour.startPoint._latitude),
    lng: parseFloat(this.data.tour.startPoint._longitude),
  };

  startPointLocation = this.geoCoder.geocode({ location: this.startPoint }, function(results, status) {
    let startPointAddress;
    if (status === google.maps.GeocoderStatus.OK) {
      if (!(results) || results[0]) {
        // Extract the address from the geocoder response
        if (results) {
          startPointAddress = results[0].formatted_address;
        }
        console.log("Start Point Address:", startPointAddress);
      } else {
        console.log("No results found.");
      }
    } else {
      console.log("Geocoder failed due to: " + status);
    }
  });

  endPoint = {
    lat: parseFloat(this.data.tour.endPoint._latitude),
    lng: parseFloat(this.data.tour.endPoint._longitude)
  };



  center: google.maps.LatLngLiteral = this.startPoint;
  zoom = 8;
  markerOptions: google.maps.MarkerOptions = {draggable: false};
  markerPositions: google.maps.LatLngLiteral[] = [];

  addMarker(event: google.maps.MapMouseEvent) {
    // @ts-ignore
    this.markerPositions.push(event.latLng.toJSON());
  }

  viewTour = new FormGroup({
    uid: new FormControl(this.data.tour.uid),
    tourId: new FormControl(this.data.tour.tourId),
    startTime: new FormControl(this.data.tour.startTime),
    endTime: new FormControl(this.data.tour.endTime),
    totalTime: new FormControl(this.data.tour.totalTime),
    totalPauseTime: new FormControl(this.data.tour.totalPauseTime),
    startPoint: new FormControl(this.startPointLocation),
    endPoint: new FormControl(this.endPoint.lat + ' , ' + this.startPoint.lat),
    note: new FormControl(this.data.tour.note),
  });


  constructor(private fireService: FireService,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private _snackBar: MatSnackBar,
              private dialogRef: MatDialogRef<TourOverviewComponent>,
              ) {
    console.log(this.startPointLocation);
  }

  //Method for closing the matDialog
  tourId: any;
  async close() {
    this.isLoading = false;
    this.dialogRef.close();
  }


}
