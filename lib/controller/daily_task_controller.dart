import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/model/daily_task_model.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';

class DailyTaskController extends GetxController {
  var tipeAlphaAbsen = 0.obs;
  var catatanAlpha = ''.obs;
  var allTask = <DailyTaskModel>[].obs;
  var listTask = [].obs;
  var tanggalTask = TextEditingController().obs;
  var task = [].obs;
  var catatan = TextEditingController().obs;
    Rx<DateTime> initialDate = DateTime.now().obs;

  
  
  void kirimDailyTask() {
    var polaInput = DateFormat('EEEE, dd-MM-yyyy', 'id'); // 'id' untuk lokal Indonesia
  var polaOutput = DateFormat('yyyy-MM-dd');
  var atten_date;
  try {
    // Parsing tanggal sesuai pola input
    var parsedDate = polaInput.parse(tanggalTask.value.text);
    
    // Format kembali tanggal menjadi 'yyyy-MM-dd'
    atten_date = polaOutput.format(parsedDate);

    print('Tanggal Terformat: $atten_date');
  } catch (e) {
    print('Format tanggal tidak valid: ${tanggalTask.value.text}');
  }

    Map<String, dynamic> body = {
      'atten_date': atten_date,
      'em_id': AppData.informasiUser![0].em_id,
      'list_task': listTask,
    };
    var connect = Api.connectionApi("post", body, "insertTaskDaily");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);
        
        }
    });
  }

  void loadAllTask() {
    allTask.clear();
    Map<String, dynamic> body = {
      'atten_date': '2025-03-06',
      'em_id': AppData.informasiUser![0].em_id,
      'bulan': '03',
      'tahun': '2025',
    };
    var connect = Api.connectionApi("post", body, "getAllTaskDaily");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print(valueBody);
        for (var element in valueBody['data'][0]) {
          allTask.add(DailyTaskModel(
              date: element['date']?? '',
              id: element['id'] ?? 0,
              em_id: element['em_id'] ?? "",
              atten_date: element['tgl_buat'],
              signin_time: element['signin_time'] ?? "",
              signout_time: element['signout_time'] ?? "",
              working_hour: element['working_hour'] ?? "",
              place_in: element['place_in'] ?? "",
              place_out: element['place_out'] ?? "",
              absence: element['absence'] ?? "",
              overtime: element['overtime'] ?? "",
              earnleave: element['earnleave'] ?? "",
              status: element['status'] ?? "",
              signin_longlat: element['signin_longlat'] ?? "",
              signout_longlat: element['signout_longlat'] ?? "",
              att_type: element['att_type'] ?? "",
              signin_pict: element['signin_pict'] ?? "",
              signout_pict: element['signout_pict'] ?? "",
              signin_note: element['signin_note'] ?? "",
              signout_note: element['signout_note'] ?? "",
              signin_addr: element['signin_addr'] ?? "",
              signout_addr: element['signout_addr'] ?? "",
              reqType: element['reg_type'] ?? 0,
              atttype: element['atttype'] ?? 0,
              namaLembur: element['lembur'],
              namaTugasLuar: element['tugas_luar'],
              namaCuti: element['cuti'],
              namaSakit: element['sakit'],
              namaIzin: element['izin'],
              namaDinasLuar: element['dinas_luar'],
              offDay: element['off_date'],
              namaHariLibur: element['hari_libur'],
              jamKerja: element['jam_kerja'],
              jamPulang: element['jam_pulang'],
              breakoutTime: element['breakout_time'],
              breakoutNote: element['breakout_note'],
              breakoutPict: element['breakout_pict'],
              breakoutPlace: element['place_break_out'],
              breakinTime: element['breakin_time'],
              breakinNote: element['breakin_note'],
              breakinPict: element['breakin_pict'],
              breakinPlace: element['place_break_in'],
              breakinAddr: element['breakin_addr'],
              breakoutAddr: element['breakout_addr'],
              statusView: element['status_view'] ?? false));
        }
      }
    });
  }

  void loadTask(id) {
    task.clear();
    Map<String, dynamic> body = {
      'id': id,
    };
    var connect = Api.connectionApi("post", body, "getTaskDaily");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('ini isi nya : ${valueBody}');
        task.add(valueBody['data']);
        print('ini  task $task');
      }
    });
  }

}
