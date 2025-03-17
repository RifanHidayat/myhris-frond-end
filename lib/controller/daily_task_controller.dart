import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:pdf/widgets.dart';
import 'package:siscom_operasional/model/daily_task_model.dart';
import 'package:siscom_operasional/screen/daily_task/daily_task.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

import 'package:siscom_operasional/model/daily_task_model.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';


class DailyTaskController extends GetxController {
  var tipeAlphaAbsen = 0.obs;
  var catatanAlpha = ''.obs;
  var allTask = <DailyTaskModel>[].obs;
  var listTask = [].obs;

  var idTask = ''.obs;
  var tanggalTask = TextEditingController().obs;
  var task = [].obs;
  var catatan = TextEditingController().obs;
  Rx<DateTime> initialDate = DateTime.now().obs;
  var statusForm = false.obs;
  var tahunSelectedSearchHistory = ''.obs;
  var bulanSelectedSearchHistory = ''.obs;
  var bulanDanTahunNow = "".obs;
  var monitoringList = [].obs;
  var date = DateTime.now().obs;
  var tanggal = ''.obs;
  var emId = ''.obs;
  var tempNamaStatus1 = "".obs;
  var tempTask = ''.obs;
  var tempDifficulty = 0.obs;
  var tempTitle = ''.obs;
  var tempTanggalSelesai = ''.obs;
  var tempStatus = 0.obs;

  @override
  void onReady() async {
    await getTimeNow();
  }

  void updateStatus(int index, String status) {
    listTask[index]['dropdown'] = status;
    listTask[index]['tgl_finish'] == '' &&
            listTask[index]['dropdown'] == 'Finished'
        ? listTask[index]['tgl_finish'] =
            Constanst.convertDate("${DateTime.now()}")
        : listTask[index]['dropdown'] == 'Ongoing'
            ? listTask[index]['tgl_finish'] = ''
            : listTask[index]['tgl_finish'];
    listTask.refresh();
  }

  void getMonitor() async {
    monitoringList.clear();
    var connect = Api.connectionApi("get", {}, "getDailyMonitoring");
    connect.then(
      (dynamic response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)['data'];
          print(data);
          monitoringList.add(data);
          print(monitoringList);
          tempNamaStatus1.value = monitoringList[0][0]['full_name'];
          emId.value = monitoringList[0][0]['em_id'];
          print('ini emid dari monitoring ${emId.value}');
          loadAllTask(emId.value);
        } else {
          // Get.snackbar("error", "gagal");
        }
      },
    );
  }

  void kirimDailyTask() {
    if (tanggalTask.value.text == '' || tanggalTask.value.text == '') {
      Get.back();
      UtilsAlert.showToast('Tanggal Tidak boleh kosong');
      return;
    }
    bool isTaskEmpty = listTask.any(
        (task) => task['judul'].trim().isEmpty || task['task'].trim().isEmpty);
    if (isTaskEmpty) {
      Get.back();
      UtilsAlert.showToast('Judul task atau rincian tidak boleh kosong');
      return;
    }
    var polaInput =
        DateFormat('EEEE, dd-MM-yyyy', 'id'); // 'id' untuk lokal Indonesia
    var polaOutput = DateFormat('yyyy-MM-dd');
    var atten_date;
    var emId = AppData.informasiUser![0].em_id;
    try {
      var parsedDate = polaInput.parse(tanggalTask.value.text);
      atten_date = polaOutput.format(parsedDate);
      print('Tanggal Terformat: $atten_date');
    } catch (e) {
      print('Format tanggal tidak valid: ${tanggalTask.value.text}');
    }

    print(task);

    Map<String, dynamic> body = {
      'atten_date': atten_date,
      'em_id': emId,
      'id': listTask.isEmpty ? "" : task[0]['daily_task_id'],
      'list_task': listTask,
    };
    
    if (statusForm.value == false) {
      var connect = Api.connectionApi("post", body, "insertTaskDaily");
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        if (res.statusCode == 200) {
          print(valueBody);
          Get.back();
          Get.back();
          loadAllTask(emId);
          UtilsAlert.showToast(valueBody.message);
        } else {
          UtilsAlert.showToast(valueBody['message']);
          print(valueBody['message']);
          Get.back();
        }
      });
    } else {
      var connect = Api.connectionApi("post", body, "updateTaskDaily");
      connect.then((dynamic res) {
        var valueBody = jsonDecode(res.body);
        if (res.statusCode == 200) {
          print(valueBody);
          Get.back();
          Get.back();
          loadAllTask(emId);
          UtilsAlert.showToast(valueBody['message']);
        } else {
          UtilsAlert.showToast(valueBody['message']);
          print(valueBody['message']);
          Get.back();
        }
      });
    }
  }

  Future<void> getTimeNow() async {
    var dt = DateTime.parse(AppData.endPeriode);
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";
    tanggal.value = '${dt.year}-${dt.month}-${dt.hour}';
  }

  void loadAllTask(emId) {
    allTask.clear();
    Map<String, dynamic> body = {
      'atten_date': tanggal.value,
      'em_id': emId,
      'bulan': bulanSelectedSearchHistory.value,
      'tahun': tahunSelectedSearchHistory.value,

    };
    var connect = Api.connectionApi("post", body, "getAllTaskDaily");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);

        print('ini data daily ${valueBody['data']}');
        for (var element in valueBody['data'][0]) {
          allTask.add(DailyTaskModel(
              date: element['date'] ?? '',

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

              breakoutTime: element['total_status_0'],
              breakoutNote: element['total_status_1'],
              breakoutPict: element['jumlah_task'],

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

  Future<void> loadTask(id) async {
    listTask.clear();
    task.clear();
    Map<String, dynamic> body = {'id': id};
    try {
      var res = await Api.connectionApi("post", body, "getTaskDaily");
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        var dataList =
            valueBody['data'] is List ? valueBody['data'] : [valueBody['data']];
        task.addAll(dataList);
        for (var tas in dataList) {
          listTask.add({
            'id': tas['id'],
            'judul': tas['judul'],
            'task': tas['rincian'],
            'level': tas['level'],
            'status': tas['status'],
            'tgl_finish': tas['tgl_finish'] == null
                ? ''
                : Constanst.convertDate(tas['tgl_finish'])
          });
        }

        print('ini task $task');
        Get.back();
      } else {
        print("Error: ${res.statusCode} - ${res.body}");
      }
    } catch (e) {
      print("Exception saat load task: $e");
    }
  }

}
