import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:siscom_operasional/model/bpjs_kesehatan.dart';
import 'package:siscom_operasional/model/bpjs_ketenagakerjaan.dart';

import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class BpjsController extends GetxController {
  RxBool isLoadingBpjsKesehatan = true.obs;
  RxBool isLoadingBpjsKetenagakerjaan = true.obs;
  RxString bpjsKesehatanNumber = "".obs;
  RxString BpjsKetenagakerjaanNumber = "".obs;

  RxString bulanKeseehatan =
      DateTime.now().month.toString().padLeft(2, '0').obs;
  RxString tahunKesehatan = DateTime.now().year.toString().obs;

  RxString bulanKetenagakerjaan =
      DateTime.now().month.toString().padLeft(2, '0').obs;
  RxString tahunKetenagakerjaan = DateTime.now().year.toString().obs;
  var bpjsKesehatan = <BpjsKesehatanModel>[].obs;
  var bpjsKetenagakerjaan = <BpjsKetenagakerjaanModel>[].obs;

  Future<void> fetchBpjsKesehatan() async {
    isLoadingBpjsKesehatan.value = true;
    Map<String, dynamic> body = {
      'em_id': AppData.informasiUser![0].em_id,
      'tahun': tahunKesehatan.value,
      'bulan': bulanKeseehatan.value,
    };

    print("data respon  ");

    var connect = Api.connectionApi("post", body, "bpjs-kesehatan");
    try {
      connect.then((dynamic value) {
        var valueBody = jsonDecode(value.body);
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          print("data respon :${data}");

          bpjsKesehatan.value = BpjsKesehatanModel.fromJsonToList(data);
          isLoadingBpjsKesehatan.value = false;
        } else {
          bpjsKesehatan.value = [];
          isLoadingBpjsKesehatan.value = false;
        }
      });
      bpjsKesehatan.value = [];
    } catch (e) {
      print("error ${e}");
      isLoadingBpjsKesehatan.value = false;
    }
  }

  Future<void> fetchBpjsKetenagakerjaam() async {
    isLoadingBpjsKetenagakerjaan.value = true;
    Map<String, dynamic> body = {
      'em_id': AppData.informasiUser![0].em_id,
      'tahun': tahunKetenagakerjaan.value,
      'bulan': bulanKetenagakerjaan.value,

      // 'nomor_bpjs_tenega_kerja': BpjsKetenagakerjaanNumber.value
    };
    print("Isi body :${body}");

    var connect = Api.connectionApi("post", body, "bpjs-ketanagakerjaan");
    try {
      connect.then((value) {
        var valueBody = jsonDecode(value.body);
        print("Hasil ${valueBody}");
        if (valueBody['status'] == true) {
          var data = valueBody['data'];
          bpjsKetenagakerjaan.value =
              BpjsKetenagakerjaanModel.fromJsonToList(data);
          isLoadingBpjsKetenagakerjaan.value = false;
        } else {
          bpjsKetenagakerjaan.value = [];
          isLoadingBpjsKetenagakerjaan.value = false;
        }
      });
      bpjsKetenagakerjaan.value = [];
    } catch (e) {
      isLoadingBpjsKetenagakerjaan.value = false;
    }
  }

  Future<void> employeDetaiBpjs() async {
    print("employee detail bpjs");
    var dataUser = AppData.informasiUser;
    final box = GetStorage();
    var id = dataUser![0].em_id;
    print("em id ${id}");
    Map<String, dynamic> body = {'val': 'em_id', 'cari': id};
    var connect = Api.connectionApi("post", body, "whereOnce-employee");
    connect.then((dynamic res) {
      if (res == false) {
        //UtilsAlert.koneksiBuruk();
      } else {
        if (res.statusCode == 200) {
          var valueBody = jsonDecode(res.body);
          var data = valueBody['data'];
          bpjsKesehatanNumber.value = data[0]['em_bpjs_kesehatan'];
          BpjsKetenagakerjaanNumber.value = data[0]['em_bpjs_tenagakerja'];
        }
        // Get.back();
      }
    });
  }
}
