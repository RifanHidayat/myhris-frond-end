import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/custom_dialog.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class AuditController extends GetxController {
  var auditList = [].obs;
  var detailAudit = [].obs;
  var listEmployee = [].obs;
  var searchTl = [].obs;
  var searchSp = [].obs;
  var tahunSelectedSearchHistory = ''.obs;
  var bulanSelectedSearchHistory = ''.obs;
  var bulanDanTahunNow = ''.obs;
  var date = DateTime.now().obs;
  var tempNamaStatus1 = ''.obs;
  var emId = ''.obs;
  var filterStatus = ''.obs;
  var tempFilterStatus = 'Semua Status'.obs;
  var filterTipeForm = ''.obs;
  var tempFilterTipeForm = 'Semua Tipe Form'.obs;
  var filterStatusAudit = ''.obs;
  var tempfilterStatusAudit = 'Semua Status Audit'.obs;
  var offset = 0.obs;
  var isLoadingMore = false.obs;
  var alasanReject = TextEditingController().obs;
  var branchList = <String>[
    'Semua Cabang',
    'PT. SHAN INFORMASI SISTEM',
    'PT. REFORMASI ANUGERAH JAVA JAYA',
  ].obs;
  var listStatusPengajuan = <Map<String, String>>[].obs;
  var konsekuemsiList = [].obs;
  var statusPemgajuanIzin = ''.obs;

  void updateListStatus() {
    print('ini di update gak sih');
    print('ini di update gak sih${searchSp}');
    print('searchSp: ${searchSp.value}, searchTl: ${searchTl.value}');
    print(searchSp.isEmpty || searchTl.isEmpty);
    listStatusPengajuan.value = searchSp.isNotEmpty || searchTl.isNotEmpty
        ? [
            {'name': "None", 'value': "none"},
            {'name': "Surat Peringatan", 'value': "surat_peringatan"}
          ]
        : [
            {'name': "None", 'value': "none"},
            {'name': "Teguran Lisan", 'value': "teguran_lisan"},
            {'name': "Surat Peringatan", 'value': "surat_peringatan"}
          ];
    listStatusPengajuan.refresh();
    print(listStatusPengajuan);
  }

  String getBranchIdByName(String branchName) {
    Map<String, String> branchMapping = {
      'Semua Cabang': '',
      'PT. SHAN INFORMASI SISTEM': '1',
      'PT. REFORMASI ANUGERAH JAVA JAYA': '2',
    };

    return branchMapping[branchName] ?? '';
  }

  var selectedBranch = 'Semua Cabang'.obs;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchAuditData();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent &&
          !isLoadingMore.value) {
        loadMoreData();
      }
    });
  }

  Future<void> searchSuratPeringatan(em_id) async {
    searchSp.value.clear();
    Map<String, dynamic> body = {
      'em_id': em_id,
    };

    var connect = Api.connectionApi("post", body, 'surat_peringatan_search');
    await connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        for (var element in valueBody['data']) {
          var data = {
            'nomor': element['nomor'],
            'nama': element['nama'],
            'exp': element['exp_date'],
            'status': element['status']
          };
          searchSp.value.add(data);
        }
        updateListStatus();
      } else {
        UtilsAlert.showToast('yah error');
      }
    });
  }

  Future<void> searchTeguranLisan(em_id) async {
    searchTl.value.clear();
    Map<String, dynamic> body = {
      'em_id': em_id,
    };

    var connect = Api.connectionApi("post", body, 'teguran_lisan_search');
    await connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        print('ini tl $valueBody');
        for (var element in valueBody['data']) {
          var data = {
            'nomor': element['nomor'],
            'nama': element['nama'],
            'exp': element['exp_date'],
            'status': element['status']
          };
          searchTl.value.add(data);
        }
        print(valueBody);
        updateListStatus();
      } else {
        UtilsAlert.showToast('yah error');
      }
    });
  }

  void fetchAuditData({bool isLoadMore = false}) {
    if (!isLoadMore) {
      // listEmployee.clear();
      auditList.clear();
      offset.value = 0; // Reset offset jika bukan load more
    }
    isLoadingMore.value = true;
    Map<String, dynamic> body = {
      'tahun': tahunSelectedSearchHistory.value,
      'bulan': bulanSelectedSearchHistory.value,
      'em_id': emId.value,
      'offset': offset.value,
      'limit': 5,
      'status': filterStatus.value,
      'status_audit': filterStatusAudit.value,
      'tipe_form': filterTipeForm.value,
      'branch_id': getBranchIdByName(selectedBranch.value)
    };
    var connect = Api.connectionApi("post", body, "audit");
    connect.then((dynamic res) {
      if (res.statusCode == 200) {
        var valueBody = jsonDecode(res.body);
        if (valueBody['data'] != null && valueBody['data'].isNotEmpty) {
          auditList.addAll(valueBody['data']);
          offset.value += 5;
        }
        print('ini audit list: $auditList');
        isLoadingMore.value = false;
      } else {
        UtilsAlert.showToast(res.message);
      }
    });
  }

  Future<void> getTimeNow() async {
    var dt = DateTime.parse(AppData.endPeriode);
    bulanSelectedSearchHistory.value = "${dt.month}";
    tahunSelectedSearchHistory.value = "${dt.year}";
    bulanDanTahunNow.value = "${dt.month}-${dt.year}";
    // tanggal.value = '${dt.year}-${dt.month}-${dt.hour}';
  }

  void getFilterEmployee() {
    listEmployee.clear();
    var dataUser = AppData.informasiUser;
    var getEmpid = dataUser![0].em_id;
    Map<String, dynamic> body = {
      'em_id': getEmpid,
    };
    var connect = Api.connectionApi("post", body, "audit/filter/employee");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      // print('ini load employee $valueBody');
      listEmployee.add({'em_id': '', 'full_name': 'Semua Karyawan'});
      listEmployee.addAll(valueBody['data']);
      print('ini load employee $listEmployee');
      tempNamaStatus1.value = listEmployee[0]['full_name'];
      emId.value = listEmployee[0]['em_id'];
    });
  }

  void showDetailRiwayat(detailData) {
    var nomorAjuan = detailData['nomor'];
    var tanggalMasukAjuan = detailData['atten_date'];
    var namaTypeAjuan = detailData['tipe_form'];
    var categoryAjuan = detailData['tipe_pengajuan'];
    var namaPengaju = detailData['full_name'];
    var jabatanPengaju = detailData['jabatan'];
    var inputTime = detailData['input_time'];
    var alasan = detailData['keterangan'];
    var durasi = detailData['leave_duration'];
    var typeAjuan = detailData['status'];
    var leave_files = detailData['leave_files'];
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                      height: 6,
                      width: 34,
                      decoration: BoxDecoration(
                          color: Constanst.colorNeutralBgTertiary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ))),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Constanst.colorNonAktif)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "No. Pengajuan",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                nomorAjuan,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tanggal Pengajuan",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Constanst.fgSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Constanst.convertDate6("$tanggalMasukAjuan"),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Constanst.fgPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Constanst.colorNonAktif)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nama pengaju",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$namaPengaju - $jabatanPengaju",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Nama Pengajuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$categoryAjuan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Catatan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Constanst.fgSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$alasan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Constanst.fgPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        leave_files == "" ||
                                leave_files == "NULL" ||
                                leave_files == null
                            ? const SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: Constanst.border,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "File disematkan",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Constanst.fgSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                      onTap: () {
                                        // viewLampiranAjuan(leave_files);
                                      },
                                      child: Text(
                                        "$leave_files",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.infoLight,
                                        ),
                                      )),
                                  const SizedBox(height: 12),
                                ],
                              ),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: Constanst.border,
                        ),
                        const SizedBox(height: 12),
                        typeAjuan == 'Rejected'
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Iconsax.close_circle,
                                    color: Constanst.color4,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Rejected",
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary,
                                                fontSize: 14)),
                                        const SizedBox(height: 6),
                                        Text(
                                          '',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w400,
                                              color: Constanst.fgSecondary,
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : typeAjuan == "Approve" ||
                                    typeAjuan == "Approve 1" ||
                                    typeAjuan == "Approve 2"
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Iconsax.tick_circle,
                                        color: Colors.green,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text("Approved",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14)),
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Iconsax.timer,
                                        color: Constanst.color3,
                                        size: 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Pending Approval",
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  color: Constanst.fgPrimary,
                                                  fontSize: 14)),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ),
                typeAjuan == 'Approve2' ||
                        detailData['status_audit'] == 'Rejected'
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Constanst
                                  .border, // Set the desired border color
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              detailData['status_audit'] == 'Rejected'
                                  ? showGeneralDialog(
                                      barrierDismissible: false,
                                      context: Get.context!,
                                      barrierColor:
                                          Colors.black54, // space around dialog
                                      transitionDuration:
                                          Duration(milliseconds: 200),
                                      transitionBuilder:
                                          (context, a1, a2, child) {
                                        return ScaleTransition(
                                          scale: CurvedAnimation(
                                              parent: a1,
                                              curve: Curves.elasticOut,
                                              reverseCurve:
                                                  Curves.easeOutCubic),
                                          child: CustomDialog(
                                            // our custom dialog
                                            title: "Peringatan",
                                            content:
                                                "Apakah Anda yakin ingin membatalkan penolakan? "
                                                "Surat Peringatan atau Teguran Lisan yang sudah diterbitkan "
                                                "akan ditarik kembali.",
                                            positiveBtnText: "Batalkan",
                                            negativeBtnText: "Kembali",
                                            style: 1,
                                            buttonStatus: 1,
                                            positiveBtnPressed: () {
                                              approvAudit(detailData);
                                            },
                                          ),
                                        );
                                      },
                                      pageBuilder: (BuildContext context,
                                          Animation animation,
                                          Animation secondaryAnimation) {
                                        return null!;
                                      },
                                    )
                                  : showBottomApproval(detailData);
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Constanst.color4,
                                backgroundColor: Constanst.colorWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                // padding: EdgeInsets.zero,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
                            child: Text(
                              detailData['status_audit'] == 'Rejected'
                                  ? 'Approve'
                                  : 'Reject',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      detailData['status_audit'] == 'Rejected'
                                          ? Constanst.color5
                                          : Constanst.color4,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }

  void showBottomApproval(detailData) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.8, // 80% layar
            minChildSize: 0.5, // Bisa mengecil
            maxChildSize: 1.0, // Bisa full screen
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Iconsax.tick_circle,
                                color: Colors.green,
                                size: 24,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8, top: 2),
                                child: Text(
                                  "Menyetujui",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            var sp = searchSp;
                            return searchSp.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Constanst.infoLight1,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Iconsax.info_circle5,
                                          color: Constanst.colorPrimary,
                                          size: 26,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            sp[0]['status'] == 'Approve'
                                                ? "Karyawan ${sp[0]['nama']} mempunyai surat peringatan yang sedang aktif dengan nomor ${sp[0]['nomor']} berakhir pada tanggal ${sp[0]['exp']}"
                                                : 'Karyawan ${sp[0]['nama']} mempunyai surat peringatan dengan nomor ${sp[0]['nomor']}, status: ${sp[0]['status']}',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                color: Constanst.fgSecondary,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox();
                          }),
                          SizedBox(height: 12),
                          Obx(() {
                            var tl = searchTl;
                            return searchTl.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Constanst.infoLight1,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Iconsax.info_circle5,
                                          color: Constanst.colorPrimary,
                                          size: 26,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            tl[0]['status'] == 'Approve'
                                                ? "Karyawan ${tl[0]['nama']} mempunyai teguran lisan yang sedang aktif dengan nomor ${tl[0]['nomor']} berakhir pada tanggal ${tl[0]['exp']}"
                                                : 'Karyawan ${tl[0]['nama']} mempunyai teguran lisan dengan nomor ${tl[0]['nomor']}, status: ${tl[0]['status']}',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                color: Constanst.fgSecondary,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox();
                          }),
                          const SizedBox(height: 12),
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(
                                  listStatusPengajuan.length, (index) {
                                var data = listStatusPengajuan[index];
                                return statusPemgajuanIzin.value ==
                                        data['value']
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 12),
                                        child: InkWell(
                                          onTap: () {
                                            statusPemgajuanIzin.value =
                                                data['value'].toString();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Constanst.infoLight1,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.infoLight),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          statusPemgajuanIzin.value =
                                              data['value'].toString();
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.secondary),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 30,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 5),
                                                    child: Row(
                                                      children: [
                                                        TextLabell(
                                                          text: data['name'],
                                                        ),
                                                      ],
                                                    ))),
                                          ),
                                        ),
                                      );
                              }),
                            );
                          }),
                          const SizedBox(
                            height: 16,
                          ),
                          Obx(() {
                            return statusPemgajuanIzin.value == 'none'
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                Constanst.borderStyle1,
                                            border: Border.all(
                                                width: 1.0,
                                                color: const Color.fromARGB(
                                                    255, 211, 205, 205))),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: TextField(
                                            cursorColor: Colors.black,
                                            controller: alasanReject.value,
                                            maxLines: null,
                                            maxLength: 225,
                                            autofocus: true,
                                            decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    "Pelanggaran yang di lakukan"),
                                            keyboardType:
                                                TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.done,
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                height: 2.0,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      TextLabell(
                                        text: "Konsekuensi",
                                        size: 12,
                                        weight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Obx(() {
                                        return konsekuemsiList.length == 0
                                            ? Text(
                                                'Buat konsekuensi dengan klik tombol dibawah',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 11),
                                              )
                                            : Column(
                                                children: List.generate(
                                                    konsekuemsiList.length,
                                                    (index) {
                                                  var data =
                                                      konsekuemsiList[index];
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 90,
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              data['konsekuensi'] =
                                                                  value;
                                                            },
                                                            controller:
                                                                TextEditingController(
                                                                    text: data[
                                                                        'konsekuensi']),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    height: 2.0,
                                                                    color: Colors
                                                                        .black),
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  'Masukan konsekuensi', // Menambahkan teks petunjuk saat field kosong
                                                              border:
                                                                  OutlineInputBorder(), // Menambahkan border di sekitar text field
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat aktif
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Constanst
                                                                        .Secondary), // Warna border saat field difokuskan
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 10,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  konsekuemsiList
                                                                      .removeAt(
                                                                          index);
                                                                  konsekuemsiList
                                                                      .refresh();
                                                                },
                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red,
                                                                )))
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                      }),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          konsekuemsiList
                                              .add({"konsekuensi": ""});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: Constanst.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Constanst.onPrimary)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                              TextLabell(
                                                text: "Konsekuensi",
                                                color: Constanst.colorWhite,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                          }),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButtonWidget(
                                  title: "Kembali",
                                  onTap: () => Navigator.pop(Get.context!),
                                  colorButton: Colors.red,
                                  colortext: Colors.white,
                                  border: BorderRadius.circular(8.0),
                                ),
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButtonWidget(
                                  title: "Menyetujui",
                                  onTap: () {
                                    bool data = konsekuemsiList.any(
                                        (konsekuensi) =>
                                            konsekuensi['konsekuensi']
                                                .trim()
                                                .isEmpty);
                                    if (statusPemgajuanIzin.value != 'none') {
                                      if (alasanReject.value.text != "") {
                                        if (data) {
                                          UtilsAlert.showToast(
                                              "Harap hapus terlebih dahulu konsekuensi yang kosong");
                                          return;
                                        } else {
                                          Navigator.pop(Get.context!);
                                          approvAudit(detailData);
                                          print(konsekuemsiList);
                                        }
                                      } else {
                                        UtilsAlert.showToast(
                                            "Harap isi alasan terlebih dahulu");
                                      }
                                    } else {
                                      Navigator.pop(Get.context!);
                                      print(konsekuemsiList);
                                      approvAudit(detailData);
                                      // validasiMenyetujui(true, em_id);
                                    }
                                  },
                                  colorButton: Constanst.colorPrimary,
                                  colortext: Colors.white,
                                  border: BorderRadius.circular(8.0),
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              );
            });
      },
    );
  }

  void approvAudit(detailData) {
    Map<String, dynamic> body = {
      'konsekuensi': statusPemgajuanIzin.value,
      'list_konsekuensi': konsekuemsiList,
      'status': detailData['status_audit'] == 'Rejected' ? '' : 'Rejected',
      'tipe_form': detailData['tipe_pengajuan'],
      'full_name': detailData['full_name']
    };
    var connect =
        Api.connectionApi("post", body, "audit/${detailData['id']}/approval");
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      if (res.statusCode == 200) {
        Get.back();
        Get.back();
        statusPemgajuanIzin.value = '';
        konsekuemsiList.clear();
        UtilsAlert.showToast(valueBody['message']);
      } else {
        UtilsAlert.showToast(valueBody['message']);
      }
    });
  }

  void getDetailAudit(id, tipeForm) {
    detailAudit.clear();
    var dataUser = AppData.informasiUser;
    var getEmpid = dataUser![0].em_id;

    var connect = Api.connectionApi(
      "get",
      {},
      "audit/$id",
      params: '&tipe_form=${tipeForm}&id=${id}',
    );
    connect.then((dynamic res) {
      var valueBody = jsonDecode(res.body);
      print(valueBody);
      detailAudit.add(valueBody['data']);
      print('ini load employee $detailAudit');
      showDetailRiwayat(detailAudit[0]);
    });
  }

  // Example method to remove an audit entry
  void loadMoreData() {
    fetchAuditData(isLoadMore: true);
  }
}
