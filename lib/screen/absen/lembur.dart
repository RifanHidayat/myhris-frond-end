// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/dashboard_controller.dart';
import 'package:siscom_operasional/controller/global_controller.dart';
import 'package:siscom_operasional/controller/lembur_controller.dart';
import 'package:siscom_operasional/screen/absen/form/form_lembur.dart';
import 'package:siscom_operasional/screen/absen/laporan/laporan_lembur.dart';
import 'package:siscom_operasional/screen/init_screen.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class Lembur extends StatefulWidget {
  @override
  _LemburState createState() => _LemburState();
}

class _LemburState extends State<Lembur> {
  final controller = Get.put(LemburController());
  var controllerGlobal = Get.find<GlobalController>();
  final dashboardController = Get.put(DashboardController());
  var idx = 0;

  @override
  void initState() {
    super.initState();
    Api().checkLogin();
    controller.loadDataLembur();
    if (Get.arguments != null) {
      idx = Get.arguments;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (controller.listLembur.isNotEmpty) {
          for (var item in controller.listLembur.value) {
            if (item['id'] == idx) {
              var alasanReject = item['alasan_reject'] ?? "";
              var approve;
              if (item['approve2_by'] == "" ||
                  item['approve2_by'] == "null" ||
                  item['approve2_by'] == null) {
                approve = item['approve_by'];
              } else {
                approve = item['approve2_by'];
              }
              controller.showDetailLembur(item, approve, alasanReject);
            }
          }
        }
      });
    }
  }

  Future<void> refreshData() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
        child: Obx(
          () => Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              backgroundColor: Constanst.colorWhite,
              elevation: 0,
              // leadingWidth: controller.statusFormPencarian.value ? 50 : 16,
              titleSpacing: 0,
              centerTitle: false,
              title: controller.statusFormPencarian.value
                  ? SizedBox(
                      height: 40,
                      child: TextFormField(
                        // controller: controller.searchController,
                        controller: controller.cari.value,
                        onFieldSubmitted: (value) {
                          if (controller.cari.value.text == "") {
                            UtilsAlert.showToast(
                                "Isi form cari terlebih dahulu");
                          } else {
                            // UtilsAlert.loadingSimpanData(
                            //     Get.context!, "Mencari Data...");
                            controller.cariData(value);
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.inter(
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                            color: Constanst.fgPrimary,
                            fontSize: 15),
                        cursorColor: Constanst.onPrimary,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Constanst.colorNeutralBgSecondary,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: const BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            hintText: "Cari data...",
                            hintStyle: GoogleFonts.inter(
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                                color: Constanst.fgSecondary,
                                fontSize: 14),
                            prefixIconConstraints:
                                BoxConstraints.tight(const Size(46, 46)),
                            suffixIconConstraints:
                                BoxConstraints.tight(const Size(46, 46)),
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 8),
                              child: IconButton(
                                icon: Icon(
                                  Iconsax.close_circle5,
                                  color: Constanst.fgSecondary,
                                  size: 24,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  controller.statusCari.value = false;
                                  controller.cari.value.text = "";
                                  controller.loadDataLembur();
                                },
                              ),
                            )),
                      ),
                    )
                  : Text(
                      "Riwayat Lembur",
                      style: GoogleFonts.inter(
                          color: Constanst.fgPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
              actions: [
                controller.statusFormPencarian.value
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Container(),
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: dashboardController.showLaporan.value ==
                                        false
                                    ? 16.0
                                    : 0),
                            child: SizedBox(
                              width: 25,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Iconsax.search_normal_1,
                                  color: Constanst.fgPrimary,
                                  size: 24,
                                ),
                                onPressed: controller.showInputCari,
                                // controller.toggleSearch,
                              ),
                            ),
                          ),
                          Obx(
                            () => controller.showButtonlaporan.value == false
                                ? const SizedBox()
                                : dashboardController.showLaporan.value == false
                                    ? const SizedBox()
                                    : IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Iconsax.document_text,
                                          color: Constanst.fgPrimary,
                                          size: 24,
                                        ),
                                        onPressed: () => Get.to(LaporanLembur(
                                          title: 'lembur',
                                        )),
                                        // controller.toggleSearch,
                                      ),
                          ),
                        ],
                      ),
              ],
              leading: controller.statusFormPencarian.value
                  ? IconButton(
                      icon: Icon(
                        Iconsax.arrow_left,
                        color: Constanst.fgPrimary,
                        size: 24,
                      ),
                      onPressed: controller.showInputCari,
                      // onPressed: () {
                      //   controller.cari.value.text = "";
                      //   Get.back();
                      // },
                    )
                  : IconButton(
                      icon: Icon(
                        Iconsax.arrow_left,
                        color: Constanst.fgPrimary,
                        size: 24,
                      ),
                      onPressed: () {
                        controller.cari.value.clear();
                        controller.onClose();
                        Get.back();
                      },
                      // onPressed: () {
                      //   controller.cari.value.text = "";
                      //   Get.back();
                      // },
                    ),
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          controller.onClose();
          Get.back();
          return true;
        },
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.bulanDanTahunNow.value == ""
                    ? const SizedBox()
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(
                          //   flex: 60,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(right: 8),
                          //     child: pencarianData(),
                          //   ),
                          // ),
                          // pickDate(),
                          const SizedBox(width: 4),
                          status()
                        ],
                      ),

                // listStatusAjuan(),
                const SizedBox(height: 4),
                Flexible(
                    child: RefreshIndicator(
                        color: Constanst.colorPrimary,
                        onRefresh: refreshData,
                        child: controller.listLembur.value.isEmpty
                            ? Center(
                                child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    controller.loadingString.value ==
                                            "Memuat Data..."
                                        ? Container()
                                        : SvgPicture.asset(
                                            'assets/empty_screen.svg',
                                            height: 228,
                                          ),
                                    const SizedBox(height: 16),
                                    Text(
                                      controller.loadingString.value,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Constanst.fgPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 85),
                                  ],
                                ),
                              ))
                            : riwayatLembur()))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constanst.colorPrimary,
        onPressed: () {
          // controller.getTypeLembur();
          Get.to(FormLembur(
            dataForm: const [[], false],
          ));
        },
        child: const Icon(
          Iconsax.add,
          size: 34,
        ),
      ),
    );
  }

  String getMonthName(int monthNumber) {
    // Menggunakan pustaka intl untuk mengonversi angka bulan menjadi teks
    final monthFormat = DateFormat.MMMM('id');
    DateTime date = DateTime(2000, monthNumber,
        1); // Tahun dan hari bebas, yang penting bulan sesuai
    return monthFormat.format(date);
  }

  Widget status() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: Constanst.fgBorder)),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          showBottomStatus(Get.context!);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.tempNamaStatus1.value,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Constanst.fgSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Iconsax.arrow_down_1,
                size: 18,
                color: Constanst.fgSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomStatus(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pilih Status",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Constanst.fgPrimary,
                        ),
                      ),
                      InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          onTap: () => Navigator.pop(Get.context!),
                          child: Icon(
                            Icons.close,
                            size: 26,
                            color: Constanst.fgSecondary,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Divider(
                    thickness: 1,
                    height: 0,
                    color: Constanst.border,
                  ),
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() => Column(
                        children: List.generate(
                            controller.dataTypeAjuan.value.length, (index) {
                          var namaType =
                              controller.dataTypeAjuan[index]['nama'];
                          var status =
                              controller.dataTypeAjuan[index]['status'];
                          return InkWell(
                            onTap: () {
                              controller.changeTypeAjuan(controller
                                  .dataTypeAjuan.value[index]['nama']);

                              controller.tempNamaStatus1.value = namaType;
                              Get.back();
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      Text(
                                        namaType,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Constanst.fgPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  controller.tempNamaStatus1.value == namaType
                                      ? InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Constanst.onPrimary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            controller.tempNamaStatus1.value =
                                                namaType;
                                            Get.back();
                                          },
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Constanst.onPrimary),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          );
                        }),
                      )),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      print('Bottom sheet closed');
    });
  }

  Widget listStatusAjuan() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
          itemCount: controller.dataTypeAjuan.value.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var namaType = controller.dataTypeAjuan[index]['nama'];
            var status = controller.dataTypeAjuan[index]['status'];
            return InkWell(
              highlightColor: Constanst.colorPrimary,
              onTap: () => controller.changeTypeAjuan(
                  controller.dataTypeAjuan.value[index]['nama']),
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                margin: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  color: status == true
                      ? Constanst.colorPrimary
                      : Constanst.colorNonAktif,
                  borderRadius: Constanst.borderStyle1,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      namaType == "Approve"
                          ? Icon(
                              Iconsax.tick_square,
                              size: 14,
                              color: status == true
                                  ? Colors.white
                                  : Constanst.colorText2,
                            )
                          : namaType == "Approve 1"
                              ? Icon(
                                  Iconsax.tick_square,
                                  size: 14,
                                  color: status == true
                                      ? Colors.white
                                      : Constanst.colorText2,
                                )
                              : namaType == "Approve 2"
                                  ? Icon(
                                      Iconsax.tick_square,
                                      size: 14,
                                      color: status == true
                                          ? Colors.white
                                          : Constanst.colorText2,
                                    )
                                  : namaType == "Rejected"
                                      ? Icon(
                                          Iconsax.close_square,
                                          size: 14,
                                          color: status == true
                                              ? Colors.white
                                              : Constanst.colorText2,
                                        )
                                      : namaType == "Pending"
                                          ? Icon(
                                              Iconsax.timer,
                                              size: 14,
                                              color: status == true
                                                  ? Colors.white
                                                  : Constanst.colorText2,
                                            )
                                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        child: Text(
                          namaType,
                          style: TextStyle(
                              fontSize: 12,
                              color: status == true
                                  ? Colors.white
                                  : Constanst.colorText2,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget pencarianData() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: Constanst.borderStyle5,
          border: Border.all(color: Constanst.colorNonAktif)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 10),
              child: Icon(Iconsax.search_normal_1),
            ),
          ),
          Expanded(
            flex: 85,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                height: 40,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 85,
                      child: TextField(
                        controller: controller.cari.value,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Cari"),
                        style: TextStyle(
                            fontSize: 14.0, height: 1.0, color: Colors.black),
                        onChanged: (value) {
                          controller.cariData(value);
                        },
                      ),
                    ),
                    !controller.statusCari.value
                        ? SizedBox()
                        : Expanded(
                            flex: 15,
                            child: IconButton(
                              icon: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                controller.statusCari.value = false;
                                controller.cari.value.text = "";
                                controller.onReady();
                              },
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget riwayatLembur() {
    debugPrint('ini data riwayat lebur ${controller.listLembur.value}');
    return ListView.builder(
        physics: controller.listLembur.value.length <= 8
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.listLembur.value.length,
        itemBuilder: (context, index) {
          var statusDraft =
              controller.listLembur.value[index]['status_pengajuan'];
          var dariJam = controller.listLembur.value[index]['dari_jam'];
          var nomorAjuan = controller.listLembur.value[index]['nomor_ajuan'];
          var sampaiJam = controller.listLembur.value[index]['sampai_jam'];
          var tanggalPengajuan =
              controller.listLembur.value[index]['atten_date'];
          var status;
          if (controller.valuePolaPersetujuan.value == "1") {
            status = controller.listLembur.value[index]['status'];
          } else {
            status = controller.listLembur.value[index]['status'] == "Approve"
                ? "Approve 1"
                : controller.listLembur.value[index]['status'] == "Approve2"
                    ? "Approve 2"
                    : controller.listLembur.value[index]['status'];
          }
          var namaTypeAjuan = controller.listLembur.value[index]['type'];
          var alasan;
          if (controller.listLembur.value[index]['alasan2'] == "" ||
              controller.listLembur.value[index]['alasan2'] == "null" ||
              controller.listLembur.value[index]['alasan2'] == null) {
            alasan = controller.listLembur.value[index]['alasan1'];
          } else {
            alasan = controller.listLembur.value[index]['alasan2'];
          }
          var approveDate = controller.listLembur.value[index]['approve_date'];
          var uraian = controller.listLembur.value[index]['uraian'];
          var approve;
          print(
              'ini approve2 by oke${controller.listLembur.value[index]['approve2_by']}');
          if (controller.listLembur.value[index]['approve2_by'] == "" ||
              controller.listLembur.value[index]['approve2_by'] == "null" ||
              controller.listLembur.value[index]['approve2_by'] == null) {
            approve = controller.listLembur.value[index]['approve_by'];
          } else {
            approve = controller.listLembur.value[index]['approve2_by'];
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Constanst.colorNonAktif)),
                    child: InkWell(
                      customBorder: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onTap: () {
                        controller.showDetailLembur(
                            controller.listLembur[index], approve, alasan);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 12, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lembur",
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text("NO.$nomorAjuan",
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 4),
                            Text(Constanst.convertDate5("$tanggalPengajuan"),
                                style: GoogleFonts.inter(
                                    color: Constanst.fgSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 4),
                            // Text('$dariJam sd $sampaiJam',
                            //     textAlign: TextAlign.justify,
                            //     style: GoogleFonts.inter(
                            //         color: Constanst.fgSecondary,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w400)),
                            // Text(
                            //   '$uraian',
                            //   textAlign: TextAlign.justify,
                            //   style: TextStyle(
                            //       fontSize: 14, color: Constanst.colorText2),
                            // ),
                            const SizedBox(height: 12),
                            Divider(
                                height: 0,
                                thickness: 1,
                                color: Constanst.border),
                            const SizedBox(height: 8),
                            // Container(
                            //   margin: EdgeInsets.only(right: 8),
                            //   decoration: BoxDecoration(
                            //     color: status == 'Approve'
                            //         ? Constanst.colorBGApprove
                            //         : status == 'Approve 1'
                            //             ? Constanst.colorBGApprove
                            //             : status == 'Approve 2'
                            //                 ? Constanst.colorBGApprove
                            //                 : status == 'Rejected'
                            //                     ? Constanst.colorBGRejected
                            //                     : status == 'Pending'
                            //                         ? Constanst.colorBGPending
                            //                         : Colors.grey,
                            //     borderRadius: Constanst.borderStyle1,
                            //   ),
                            //   child: Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 3, right: 3, top: 5, bottom: 5),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         status == 'Approve'
                            //             ? Icon(
                            //                 Iconsax.tick_square,
                            //                 color: Constanst.color5,
                            //                 size: 14,
                            //               )
                            //             : status == 'Approve 1'
                            //                 ? Icon(
                            //                     Iconsax.tick_square,
                            //                     color: Constanst.color5,
                            //                     size: 14,
                            //                   )
                            //                 : status == 'Approve 2'
                            //                     ? Icon(
                            //                         Iconsax.tick_square,
                            //                         color: Constanst.color5,
                            //                         size: 14,
                            //                       )
                            //                     : status == 'Rejected'
                            //                         ? Icon(
                            //                             Iconsax.close_square,
                            //                             color: Constanst.color4,
                            //                             size: 14,
                            //                           )
                            //                         : status == 'Pending'
                            //                             ? Icon(
                            //                                 Iconsax.timer,
                            //                                 color: Constanst.color3,
                            //                                 size: 14,
                            //                               )
                            //                             : SizedBox(),
                            //         Padding(
                            //           padding: const EdgeInsets.only(left: 3),
                            //           child: Text(
                            //             '$status',
                            //             textAlign: TextAlign.center,
                            //             style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 color: status == 'Approve'
                            //                     ? Colors.green
                            //                     : status == 'Approve 1'
                            //                         ? Colors.green
                            //                         : status == 'Approve 2'
                            //                             ? Colors.green
                            //                             : status == 'Rejected'
                            //                                 ? Colors.red
                            //                                 : status == 'Pending'
                            //                                     ? Constanst.color3
                            //                                     : Colors.black),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            if (status == 'Rejected')
                              Row(
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
                                        Text(
                                          "Rejected by $approve",
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Constanst.fgPrimary,
                                              fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          alasan.toString(),
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
                            else
                              status == "Approve" ||
                                      status == "Approve 1" ||
                                      status == "Approve 2"
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Iconsax.tick_circle,
                                          color: Colors.green,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Approved by $approve",
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    color: Constanst.fgPrimary,
                                                    fontSize: 14),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                alasan.toString(),
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Constanst.fgSecondary,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
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
                                            InkWell(
                                                onTap: () {
                                                  var dataEmployee = {
                                                    'nameType':
                                                        '$namaTypeAjuan',
                                                    'nomor_ajuan':
                                                        '$nomorAjuan',
                                                  };
                                                  controllerGlobal
                                                      .showDataPilihAtasan(
                                                          dataEmployee);
                                                },
                                                child: Text(
                                                    "Konfirmasi via Whatsapp",
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            Constanst.infoLight,
                                                        fontSize: 14))),
                                          ],
                                        ),
                                      ],
                                    ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  statusDraft == 'draft' ?
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Transform.rotate(
                      angle:
                          -0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red
                              .withOpacity(0.8), // Warna latar belakang
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          "DRAFT",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Warna teks
                          ),
                        ),
                      ),
                    ),
                  )
                  : SizedBox()
                ],
              )
            ],
          );
        });
  }
}
