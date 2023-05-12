import 'package:excel/excel.dart';

import '../models/tour.dart';
import '../util/map_geo_util.dart';

class ExcelConverter{
  Future<Excel> createExcel(List<Tour> tours) async{
    final excel = Excel.createExcel();
    final sheet = excel['Tours'];

    // Add headers
    sheet.appendRow([
      TourKeys.tourId,
      TourKeys.uid,
      TourKeys.startPoint,
      TourKeys.endPoint,
      TourKeys.startTime,
      TourKeys.endTime,
      TourKeys.totalTime,
    ]);

    // Add tour data
    for (final tour in tours) {
      sheet.appendRow([
        tour.tourId,
        tour.uid,
        '${getAddressFromLatLong(tour.startPoint)}',
        '${getAddressFromLatLong(tour.endPoint)}',
        tour.startTime?.toString(),
        tour.endTime?.toString(),
        tour.totalTime ?? '',
      ]);
    }

    excel.save(fileName: 'My_Excel_File_Name.xlsx');
    return excel;
  }
}