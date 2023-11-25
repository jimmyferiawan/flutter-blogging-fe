import 'package:flutter/material.dart';

String datePrettier(String date) {
    Map<String, String> monthConstant = {
        "1": "Januari",
        "2": "Februari",
        "3": "Maret",
        "4": "April",
        "5": "Mei",
        "6": "Juni",
        "7": "Juli",
        "8": "Agustus",
        "9": "September",
        "01": "Januari",
        "02": "Februari",
        "03": "Maret",
        "04": "April",
        "05": "Mei",
        "06": "Juni",
        "07": "Juli",
        "08": "Agustus",
        "09": "September",
        "10": "Oktober",
        "11": "November",
        "12": "Desember",
    };

    String dateResult = "";
    // List<String> spliDate;

    try {
        List<String> splitDate = date.split("-");
        splitDate[1] = monthConstant[splitDate[1]]!;
        dateResult = splitDate.join(" ");
    } catch (e) {
        debugPrint("invalid birtdate response");
    }

    return dateResult;
}

String datePickerParser(String selectedDate) {
    String tanggal = "";
    String dateOnly = "";

    try {
      dateOnly = selectedDate.split(" ")[0];
      tanggal = dateOnly.split("-").reversed.toList().join("-");
    } catch (e) {
      debugPrint("error parsing date picker result ${e.toString()}");
    }

    return tanggal;
}