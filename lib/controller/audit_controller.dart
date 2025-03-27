import 'dart:convert';

import 'package:get/get.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';

class AuditController extends GetxController {
  // Define your variables and methods here

  // Example variable
  var auditList = [].obs;

  // Example method to fetch audit data
  void fetchAuditData() {
    auditList.clear();
    var dataUser = AppData.informasiUser;
    var getEmpid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmpid,
      'offset': 10,
      'limit': 10,
      'status': '',
      'status_audit' : '',
      'tipe_form': '',
      'branch_id': ''
    };
    var connect = Api.connectionApi("post", body, "audit");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      print('ini load aktifitas $valueBody');
      auditList.add(valueBody['data']);
    });
  }

  // Example method to add an audit entry
  void addAuditEntry(Map<String, dynamic> entry) {
    auditList.add(entry);
  }

  // Example method to remove an audit entry
  void removeAuditEntry(int index) {
    auditList.removeAt(index);
  }
}