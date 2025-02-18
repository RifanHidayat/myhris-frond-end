// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:siscom_operasional/controller/izin_controller.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/date_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_textButton.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormPengajuanIzin extends StatefulWidget {
  List? dataForm;
  FormPengajuanIzin({Key? key, this.dataForm}) : super(key: key);
  @override
  _FormPengajuanIzinState createState() => _FormPengajuanIzinState();
}

class _FormPengajuanIzinState extends State<FormPengajuanIzin> {
  var controller = Get.put(IzinController());

  var izinTerpakai = 0.obs;
  var jumlahCuti = 0.obs;
  DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    controller.percentIzin.value = 0.0;
    // UtilsAlert.showToast(
    //                       "datea detail  ${widget.dataForm![0][0]['id']}");
    if (widget.dataForm![1] == true) {
    //  controller.loaDataTipe(durasi: 2.toString());
    // print("datea detail  ${widget.dataForm![0]['start_date']}")
       
      var convertDariTanggal = widget.dataForm![0]['start_date'];
      var convertSampaiTanggal = widget.dataForm![0]['end_date'];
      controller.isBackdate.value = widget.dataForm![0]['back_date'].toString();

      controller.dariTanggal.value.text = "$convertDariTanggal";
      controller.sampaiTanggal.value.text = "$convertSampaiTanggal";
          //  controller.startdate.value = "$convertDariTanggal";
      controller.endDate.value = "$convertSampaiTanggal";
       controller.startDate.value = "$convertDariTanggal";


      controller.jamAjuan.value.text = widget.dataForm![0]['time_plan'];
      controller.sampaiJamAjuan.value.text =
          widget.dataForm![0]['time_plan_to'].toString();
      controller.alasan.value.text = "${widget.dataForm![0]['reason']}";
      controller.namaFileUpload.value = "${widget.dataForm![0]['leave_files']}";
      controller.validasiTypeWhenEdit("${widget.dataForm![0]['name']}");
      controller.tanggalBikinPengajuan.value =
          "${widget.dataForm![0]['atten_date']}";
      controller.idEditFormTidakMasukKerja.value =
          "${widget.dataForm![0]['id']}";
      controller.emDelegationEdit.value =
          "${widget.dataForm![0]['em_delegation']}";
      controller
          .validasiEmdelegation("${widget.dataForm![0]['em_delegation']}");
      controller.nomorAjuan.value.text =
          "${widget.dataForm![0]['nomor_ajuan']}";
      controller.durasiIzin.value =
          int.parse(widget.dataForm![0]['leave_duration']);
      controller.screenTanggalSelected.value = false;
      var listDateTerpilih = widget.dataForm![0]['date_selected'].split(',');
      List<DateTime> getDummy = [];
      for (var element in listDateTerpilih) {
        var convertDate = DateTime.parse(element);
        getDummy.add(convertDate);
        print("tanggaln dumy ${getDummy}");
      }
      getDummy.sort();

      if (getDummy.isNotEmpty) {
        _controller.selectedRange = PickerDateRange(
          getDummy[0],
          getDummy[getDummy.length - 1],
        );
      }
      setState(() {
        controller.tanggalSelectedEdit.value = getDummy;
      });

      if (widget.dataForm![0]['input_time'] == null) {
      } else {
        controller.inputTime.value =
            int.parse(widget.dataForm![0]['input_time'].toString());
      }


         

                controller.percentIzin.value = 0;
                controller.gantiTypeAjuan(controller.selectedDropdownFormTidakMasukKerjaTipe.value);

                var data = controller.allTipe.value
                    .where((element) =>controller.selectedDropdownFormTidakMasukKerjaTipe.value
                        .toString()
                        .toLowerCase()
                        .trim()
                        .contains("${element['name']} - ${element['category']}"
                            .toString()
                            .toLowerCase()
                            .trim()))
                    .toList();
                // controller.loadTypeSakit();
                if (data[0]['input_time'] == null) {
                } else {
                  controller.inputTime.value =
                      int.parse(data[0]['input_time'].toString());
                }
                print(data[0]['back_date'].toString());
                controller.isBackdate.value = data[0]['back_date'].toString();
                print("new data upload file ${data[0]['input_time']}");
                controller.isRequiredFile.value =
                    data[0]['upload_file'].toString();

                if (data[0]['leave_day'] > 0) {
                  print("new data ${data[0]['id']}");

                  controller
                      .loadDataAjuanIzinCategori(id: data[0]['type_id'])
                      .then((value) {
                    if (value == true) {
                      controller.showDurationIzin.value = true;
                      controller.jumlahIzin.value = data[0]['leave_day'];
                      controller.percentIzin.value = double.parse(((int.parse(
                                  controller.izinTerpakai.value.toString()) /
                              int.parse(
                                  controller.jumlahIzin.value.toString())))
                          .toString());
                    }
                  });
                } else {
                  controller.showDurationIzin.value = false;
                }
    } else {
      //controller.loadTypeSakit();
      controller.startDate.value = '';
      controller.endDate.value = '';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('ini tanggal selected ${controller.tanggalSelected}');
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight) * 1,
        child: Container(
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
            centerTitle: true,
            title: Text(
              "Pengajuan Izin",
              style: GoogleFonts.inter(
                  color: Constanst.fgPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            leading: IconButton(
              icon: Icon(
                Iconsax.arrow_left,
                color: Constanst.fgPrimary,
                size: 24,
              ),
              onPressed: () {
                controller.tempNamaTipe1.value = "Semua Tipe";
                controller.loadTypeSakit();
                // controller.changeTypeSelected(2);
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
      body: WillPopScope(
          onWillPop: () async {
            controller.tempNamaTipe1.value = "Semua Tipe";
            controller.loadTypeSakit();
            //  controller.changeTypeSelected(2);
            Get.back();
            return true;
          },
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Obx(() => controller.showDurationIzin.value == true?
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(color: Constanst.fgBorder)),
                      child: controller.showDurationIzin.value
                          ? informasiSisaCuti()
                          : SizedBox(),
                    ),
                    // : const SizedBox()),
                    const SizedBox(height: 16),
                    Obx(() => controller.isLoadingzin.value == true
                        ? SizedBox()
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(color: Constanst.fgBorder)),
                            child: Column(
                              children: [
                                // formAjuanTanggal(),
                                formTanggalCutiMelahirkan(),
                                // controller.inputTime.value == 0
                                //     ? formAjuanTanggal()
                                //     : formAjuanTanggal1(),
                                Obx(() => controller.showTipe.value == false
                                    ? SizedBox()
                                    : formTipe()),
                                // Text(AppData.informasiUser![0].dep_group.toString()),
                                controller.inputTime.value == 0
                                    ? const SizedBox()
                                    : controller.inputTime.value == 1
                                        ? formJam()
                                        : controller.inputTime.value == 2
                                            ? formJam2Waktu()
                                            : SizedBox(),
                                formDelegasiKepada(),
                                formUploadFile(),
                                formAlasan(),
                              ],
                            ))),
                  ],
                ),
              ),
            ),
          )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16.0),
            ),
            color: Constanst.colorWhite,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2.0),
                blurRadius: 12.0,
              )
            ]),
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
              child: TextButtonWidget(
                title: "Kirim",
                onTap: () {
                  if (controller.inputTime.value == 1) {
                    controller.jamAjuan.value = controller.sampaiJamAjuan.value;
                  }
                  print(
                      "tangagl mulai  ${controller.sampaiJamAjuan.value.text}");
                  print("tanggal selesai  ${controller.jamAjuan.value.text}");
                  if (controller.jumlahIzin.value > 0) {
                    print("jumlah izin ${controller.jumlahIzin.value}");
                    if (controller.percentIzin.value >= 1) {
                      UtilsAlert.showToast(
                          "Pemakaian izin telah melewati batas maksimal");
                    } else {
                      if (controller.showDurationIzin.value == true) {
                        var totalTerpakai =
                            controller.tanggalSelected.value.length +
                                controller.izinTerpakai.value;
                        if (totalTerpakai > controller.jumlahIzin.value) {
                          UtilsAlert.showToast(
                              "Pemakaian izin telah melewati batas maksimal1");
                        } else {
                          controller
                              .validasiKirimPengajuan(widget.dataForm![1]);
                        }
                      } else {
                        controller.validasiKirimPengajuan(widget.dataForm![1]);
                      }
                    }
                  } else {
                    controller.validasiKirimPengajuan(widget.dataForm![1]);
                  }
                },
                colorButton: Constanst.colorPrimary,
                colortext: Constanst.colorWhite,
                border: BorderRadius.circular(8.0),
              )),
        ),
      ),
    );
  }

  Widget formTipe() {
    return InkWell(
      onTap: () async {
        await showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(17, 235, 17, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: const BoxConstraints(
            minWidth: 395.0,
            // minHeight: 50.0,
            maxWidth: 395.0,
            // maxHeight: 100.0,
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.allTipeFormTidakMasukKerja.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              // onTap: () => controller.selectedTypeCuti.value = value,

              onTap: () {
                print(value);
                print("tes");

                controller.percentIzin.value = 0;
                controller.gantiTypeAjuan(value);

                var data = controller.allTipe.value
                    .where((element) => value
                        .toString()
                        .toLowerCase()
                        .trim()
                        .contains("${element['name']} - ${element['category']}"
                            .toString()
                            .toLowerCase()
                            .trim()))
                    .toList();
                // controller.loadTypeSakit();
                if (data[0]['input_time'] == null) {
                } else {
                  controller.inputTime.value =
                      int.parse(data[0]['input_time'].toString());
                }
                print(data[0]['back_date'].toString());
                controller.isBackdate.value = data[0]['back_date'].toString();
                print("new data upload file ${data[0]['input_time']}");
                controller.isRequiredFile.value =
                    data[0]['upload_file'].toString();

                if (data[0]['leave_day'] > 0) {
                  print("new data ${data[0]['id']}");

                  controller
                      .loadDataAjuanIzinCategori(id: data[0]['type_id'])
                      .then((value) {
                    if (value == true) {
                      controller.showDurationIzin.value = true;
                      controller.jumlahIzin.value = data[0]['leave_day'];
                      controller.percentIzin.value = double.parse(((int.parse(
                                  controller.izinTerpakai.value.toString()) /
                              int.parse(
                                  controller.jumlahIzin.value.toString())))
                          .toString());
                    }
                  });
                } else {
                  controller.showDurationIzin.value = false;
                }
                // controller.selectedTypeCuti.value = selectedValue!;
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Constanst.fgPrimary),
                ),
              ),
            );
          }).toList(),
        );
      },
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Iconsax.note_2,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tipe Izin*",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.selectedDropdownFormTidakMasukKerjaTipe
                                  .value,
                              style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Constanst.fgPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Iconsax.arrow_down_1,
                    size: 20, color: Constanst.fgPrimary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(
              height: 0,
              thickness: 1,
              color: Constanst.fgBorder,
            ),
          ),
          // Container(
          //   height: 50,
          //   decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: Constanst.borderStyle1,
          //       border: Border.all(
          //           width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: DropdownButtonHideUnderline(
          //       child: DropdownButton<String>(
          //         isDense: true,
          //         autofocus: true,
          //         focusColor: Colors.grey,
          //         items: controller.allTipeFormTidakMasukKerja.value
          //             .map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(
          //               value,
          //               style: TextStyle(fontSize: 14),
          //             ),
          //           );
          //         }).toList(),
          //         value:
          //             controller.selectedDropdownFormTidakMasukKerjaTipe.value,
          //         onChanged: (selectedValue) {
          //           controller.percentIzin.value = 0;
          //           controller.gantiTypeAjuan(selectedValue);
          //           var data = controller.allTipe.value
          //               .where((element) => selectedValue
          //                   .toString()
          //                   .toLowerCase()
          //                   .contains(element['name'].toString().toLowerCase()))
          //               .toList();
          //           if (data[0]['leave_day'] > 0) {
          //             print("data ${data[0]['id']}");
          //             print("data ${data[0]['leave_day'].toString()}");
          //             controller
          //                 .loadDataAjuanIzinCategori(id: data[0]['type_id'])
          //                 .then((value) {
          //               if (value == true) {
          //                 controller.showDurationIzin.value = true;
          //                 controller.jumlahIzin.value = data[0]['leave_day'];
          //                 controller
          //                     .percentIzin.value = double.parse(((int.parse(
          //                             controller.izinTerpakai.value
          //                                 .toString()) /
          //                         int.parse(
          //                             controller.jumlahIzin.value.toString())))
          //                     .toString());
          //               }
          //             });
          //           } else {
          //             controller.showDurationIzin.value = false;
          //           }
          //         },
          //         isExpanded: true,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget formTanggalCutiMelahirkan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("Tanggal*", style: TextStyle(fontWeight: FontWeight.bold)),
        // widget.dataForm![1] == true
        //     ? controller.selectedTypeCuti.value
        //             .toString()
        //             .toLowerCase()
        //             .toLowerCase()
        //             .contains("Cuti Melahirkan".toLowerCase())
        //         ? SizedBox()
        //         : customTanggalDariSampaiDari()
        //     : SizedBox(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 50,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: InkWell(
                  onTap: () {
                    DatePicker.showPicker(
                      context,
                      pickerModel: CustomDatePicker(
                          currentTime: DateTime.now(), minTime: DateTime(2000)),
                      onConfirm: (time) {
                        if (time != null) {
                        
                          controller.startDate.value =
                              DateFormat('yyyy-MM-dd').format(time).toString();
                              controller.dariTanggal.value.text =
                              DateFormat('yyyy-MM-dd').format(time).toString();

                          if (controller.startDate.value != '' &&
                              controller.endDate.value != '') {
                            controller.loaDataTipe(
                                durasi: controller.durasiIzin.value.toString());
                          } else {


                          }
                          print("$time");
                        }
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 15, child: const Icon(Iconsax.calendar_2)),
                        Expanded(
                          flex: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextLabell(
                                text: "Tanggal Mulai *",
                                color: Constanst.fgPrimary,
                                size: 14,
                                weight: FontWeight.w400,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextLabell(
                                    text: controller.startDate.value == ""
                                        ? controller.startDate.value
                                        : DateFormat('dd MMM yyyy', 'id')
                                            .format(DateTime.parse(controller
                                                .startDate.value
                                                .toString())),
                                    color: Constanst.fgPrimary,
                                    weight: FontWeight.w500,
                                    size: 16,
                                  ),
                                  Icon(Iconsax.arrow_down_1,
                                      size: 20, color: Constanst.fgPrimary),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 50,
              child: InkWell(
                onTap: () {
                  if (controller.startDate.value == "") {
                    UtilsAlert.showToast("Tanggal Mulai belum diisi");
                    return;
                  }
                  print("kesini");
                  DatePicker.showPicker(
                    context,
                    pickerModel: CustomDatePicker(
                      // minTime: DateTime(
                      //     DateTime.now().year,
                      //     DateTime.now().month - 1,
                      //     int.parse(
                      //         AppData.informasiUser![0].beginPayroll.toString())),
                      // maxTime: DateTime(DateTime.now().year, DateTime.now().month,
                      //     DateTime.now().day),
                      currentTime: DateTime.now(),
                      minTime: DateTime(2000),
                    ),
                    onConfirm: (time) {
                      if (time != null) {
                        controller.endDate.value = DateFormat('yyyy-MM-dd')
                            .format(
                                DateFormat('yyyy-MM-dd').parse(time.toString()))
                            .toString();

controller.sampaiTanggal.value.text = DateFormat('yyyy-MM-dd')
                            .format(
                                DateFormat('yyyy-MM-dd').parse(time.toString()))
                            .toString();

                        DateTime tempStartDate = DateTime.parse(
                            DateFormat('yyyy-MM-dd')
                                .format(DateFormat('yyyy-MM-dd')
                                    .parse(controller.startDate.value))
                                .toString());
                        DateTime tempEndDate = DateTime.parse(
                            DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(
                                    controller.endDate.value.toString()))
                                .toString());
                        // Define two DateTime objects representing the two dates
                        DateTime date1 = DateTime(tempStartDate.year,
                            tempStartDate.month, tempStartDate.day);
                        DateTime date2 = DateTime(tempEndDate.year,
                            tempEndDate.month, tempEndDate.day);

                        // Calculate the difference between the two dates
                        Duration difference = date2.difference(date1);
                        controller.durasiIzin.value = difference.inDays + 1;

                        print("durasi izin  ${controller.durasiIzin.value}");
                        for (var i = tempStartDate;
                            i.isBefore(tempEndDate) ||
                                i.isAtSameMomentAs(tempEndDate);
                            i = i.add(Duration(days: 1))) {
                          controller.tanggalSelected.value.add(i);
                        }
                        if (controller.startDate.value ==
                            controller.endDate.value) {
                          controller.tanggalSelected.value = [];
                          controller.tanggalSelected.value
                              .add(controller.startDate.value);
                        }
                        print("tanggal teralkhir ${controller.tanggalSelected.value}");
                        controller.jumlahIzin.value =
                            controller.durasiIzin.value;
                        controller.loaDataTipe(
                            durasi: controller.durasiIzin.value.toString());

                        // controller.durasi.value =
                        //     difference.inDays + 1;

                        // absenController.tglAjunan.value =
                        //     DateFormat('yyyy-MM-dd').format(time).toString();
                        // absenController.checkAbsensi();

                        // absenController.getPlaceCoordinateCheckin();
                        // absenController.getPlaceCoordinateCheckout();

                        // var filter = DateFormat('yyyy-MM').format(time);
                        // var array = filter.split('-');
                        // var bulan = array[1];
                        // var tahun = array[0];
                        // controller.bulanSelectedSearchHistory.value = bulan;
                        // controller.tahunSelectedSearchHistory.value = tahun;
                        // controller.bulanDanTahunNow.value = "$bulan-$tahun";
                        // this.controller.bulanSelectedSearchHistory.refresh();
                        // this.controller.tahunSelectedSearchHistory.refresh();
                        // this.controller.bulanDanTahunNow.refresh();
                        // controller.loadHistoryAbsenUser();
                      }
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 15, child: Icon(Iconsax.calendar_2)),
                      Expanded(
                        flex: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextLabell(
                              text: "Tanggal Selesai *",
                              color: Constanst.fgPrimary,
                              size: 14,
                              weight: FontWeight.w400,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextLabell(
                                    text: controller.endDate.value == ""
                                        ? controller.endDate.value
                                        : DateFormat('dd MMM yyyy', 'id')
                                            .format(DateTime.parse(controller
                                                .endDate.value
                                                .toString())),
                                    color: Constanst.fgPrimary,
                                    weight: FontWeight.w500,
                                    size: 16,
                                  ),
                                ),
                                Icon(Iconsax.arrow_down_1,
                                    size: 20, color: Constanst.fgPrimary),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
        ),
      ],
    );
  }

  Widget formAjuanTanggal() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.calendar_2,
                size: 26,
              ),
              const SizedBox(width: 12),
              Text("Pilih Tanggal*",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary)),
            ],
          ),
          // widget.dataForm![1] == true
          //     ? customTanggalDariSampaiDari()
          //     : SizedBox(),

          // controller.screenTanggalSelected.value == true ||
          //         widget.dataForm![1] == false
          //     ?
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Constanst.fgBorder)),
            child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0,
                child: Obx(() => SfDateRangePicker(
                      controller: _controller,
                      selectionMode: DateRangePickerSelectionMode.range,
                      minDate: controller.isBackdate.value == "0"
                          ? DateTime(2000)
                          : DateTime.now(),
                      initialSelectedRanges: [
                        PickerDateRange(
                            DateTime.now(), DateTime.parse("2024-07-16"))
                      ],
                      monthCellStyle: const DateRangePickerMonthCellStyle(
                        weekendTextStyle: TextStyle(color: Colors.red),
                        blackoutDateTextStyle: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough),
                      ),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        // print(args.value);

                        // Konversi menjadi List<DateTime>
                        List<DateTime> dateList = [];
                        DateTime startDate =
                            args.value.startDate ?? args.value.endDate;
                        DateTime endDate =
                            args.value.endDate ?? args.value.startDate;

                        print("tanggall terpilih ${startDate}");

                        // Tambahkan rentang tanggal ke dalam daftar
                        for (DateTime date = startDate;
                            date.isBefore(endDate.add(Duration(days: 1)));
                            date = date.add(Duration(days: 1))) {
                          dateList.add(date);
                        }

                        // Cetak hasil
                        print('tes ini apa $dateList');

                        if (controller.idEditFormTidakMasukKerja.value != "") {
                          controller.tanggalSelectedEdit.value = dateList;
                          this.controller.tanggalSelectedEdit.refresh();
                        } else {
                          controller.tanggalSelected.value = dateList;
                          this.controller.tanggalSelected.refresh();
                        }
                      },
                    ))),
          )
          // : SizedBox(),
        ],
      ),
    );
  }

  Widget formAjuanTanggal1() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Iconsax.calendar_2,
                size: 26,
              ),
              const SizedBox(width: 12),
              Text("Pilih Tanggal*",
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Constanst.fgPrimary)),
            ],
          ),
          // widget.dataForm![1] == true
          //     ? customTanggalDariSampaiDari()
          //     : SizedBox(),

          // controller.screenTanggalSelected.value == true ||
          //         widget.dataForm![1] == false
          //     ?
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Constanst.fgBorder)),
            child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0,
                child: Obx(() => SfDateRangePicker(
                      minDate: controller.isBackdate.value == "0"
                          ? DateTime(2000)
                          : DateTime.now(),
                      selectionMode: DateRangePickerSelectionMode.single,
                      initialSelectedRanges: [
                        PickerDateRange(DateTime.now(), DateTime.now())
                      ],
                      monthCellStyle: const DateRangePickerMonthCellStyle(
                        weekendTextStyle: TextStyle(color: Colors.red),
                        blackoutDateTextStyle: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.lineThrough),
                      ),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        print(args.value);
                        print("");

                        // Konversi menjadi List<DateTime>
                        List<DateTime> dateList = [];
                        dateList.add(args.value);
                        // DateTime startDate =
                        //     args.value.startDate ?? args.value.endDate;
                        // DateTime endDate =
                        //     args.value.endDate ?? args.value.startDate;

                        // Tambahkan rentang tanggal ke dalam daftar
                        // for (DateTime date = startDate;
                        //     date.isBefore(endDate.add(Duration(days: 1)));
                        //     date = date.add(Duration(days: 1))) {
                        //   dateList.add(date);
                        // }

                        // Cetak hasil
                        print(dateList);

                        if (controller.idEditFormTidakMasukKerja.value != "") {
                          controller.tanggalSelectedEdit.value = dateList;
                          this.controller.tanggalSelectedEdit.refresh();
                        } else {
                          controller.tanggalSelected.value = dateList;
                          this.controller.tanggalSelected.refresh();
                        }
                      },
                    ))),
          )
          // : SizedBox(),
        ],
      ),
    );
  }

  Widget customTanggalDariSampaiDari() {
    return Container(
        height: 50,
        width: MediaQuery.of(Get.context!).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Constanst.borderStyle1,
            border: Border.all(
                width: 0.5, color: Color.fromARGB(255, 211, 205, 205))),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 90,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Constanst.convertDate1(
                            "${controller.dariTanggal.value.text}")),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("sd"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(Constanst.convertDate1(
                              "${controller.sampaiTanggal.value.text}")),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: IconButton(
                    onPressed: () {
                      controller.screenTanggalSelected.value =
                          !controller.screenTanggalSelected.value;
                    },
                    icon: Icon(
                      Iconsax.edit,
                      size: 18,
                    ),
                  ),
                )
              ],
            )));
  }

  Widget formJam() {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 8,
              ),
              Text(
                "jam Izin",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Constanst.borderStyle1,
                          border: Border.all(
                              width: 0.5,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                              onTap: () {
                                showTimePicker(
                                  context: Get.context!,
                                  initialTime: TimeOfDay.now(),
                                  // initialEntryMode: TimePickerEntryMode.dial,
                                ).then((value) {
                                  if (value == null) {
                                    UtilsAlert.showToast('gagal pilih jam');
                                  } else {
                                    var convertJam = value.hour <= 9
                                        ? "0${value.hour}"
                                        : "${value.hour}";
                                    var convertMenit = value.minute <= 9
                                        ? "0${value.minute}"
                                        : "${value.minute}";
                                    controller.sampaiJamAjuan.value.text =
                                        "$convertJam:$convertMenit";
                                    this.controller.sampaiJamAjuan.refresh();
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 5),
                                child: Text(
                                  "${controller.sampaiJamAjuan.value.text.toString()}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget formJam2Waktu() {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 8,
              ),
              Text(
                "Dari jam *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Constanst.borderStyle1,
                          border: Border.all(
                              width: 0.5,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                              onTap: () {
                                showTimePicker(
                                  context: Get.context!,
                                  initialTime: TimeOfDay.now(),
                                  // initialEntryMode: TimePickerEntryMode.dial,
                                ).then((value) {
                                  if (value == null) {
                                    UtilsAlert.showToast('gagal pilih jam');
                                  } else {
                                    var convertJam = value.hour <= 9
                                        ? "0${value.hour}"
                                        : "${value.hour}";
                                    var convertMenit = value.minute <= 9
                                        ? "0${value.minute}"
                                        : "${value.minute}";
                                    controller.jamAjuan.value.text =
                                        "$convertJam:$convertMenit";
                                    this.controller.jamAjuan.refresh();
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 5),
                                child: Text(
                                  "${controller.jamAjuan.value.text}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 8,
              ),
              Text(
                "Sampai Jam *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(Get.context!).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: Constanst.borderStyle1,
                          border: Border.all(
                              width: 0.5,
                              color: Color.fromARGB(255, 211, 205, 205))),
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: InkWell(
                              onTap: () {
                                showTimePicker(
                                  context: Get.context!,
                                  initialTime: TimeOfDay.now(),
                                  // initialEntryMode: TimePickerEntryMode.dial,
                                ).then((value) {
                                  if (value == null) {
                                    UtilsAlert.showToast('gagal pilih jam');
                                  } else {
                                    var convertJam = value.hour <= 9
                                        ? "0${value.hour}"
                                        : "${value.hour}";
                                    var convertMenit = value.minute <= 9
                                        ? "0${value.minute}"
                                        : "${value.minute}";
                                    controller.sampaiJamAjuan.value.text =
                                        "$convertJam:$convertMenit";
                                    this.controller.sampaiJamAjuan.refresh();
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 5),
                                child: Text(
                                  "${controller.sampaiJamAjuan.value.text.toString()} ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget formDelegasiKepada() {
    return InkWell(
      onTap: () async {
        print(controller.allEmployeeDelegasi.value);
        await showMenu(
          context: context,
          position: controller.viewFormWaktu.value == false
              ? const RelativeRect.fromLTRB(17, 635, 17, 0)
              : const RelativeRect.fromLTRB(17, 665, 17, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.allEmployeeDelegasi.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              onTap: () {
                controller.selectedDropdownFormTidakMasukKerjaDelegasi.value =
                    value;
                print(controller
                    .selectedDropdownFormTidakMasukKerjaDelegasi.value);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Constanst.fgPrimary),
                ),
              ),
            );
          }).toList(),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.profile_add,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delegasikan Tugas kepada*",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.selectedDropdownFormTidakMasukKerjaDelegasi
                              .value,
                          style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Iconsax.arrow_down_1,
                    size: 20, color: Constanst.fgPrimary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(
              height: 0,
              thickness: 1,
              color: Constanst.fgBorder,
            ),
          ),
        ],
      ),
    );
  }

  Widget formUploadFile() {
    return InkWell(
      onTap: () async {
        controller.takeFile();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Iconsax.document_upload,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => controller.isRequiredFile.value == "1"
                          ? Text(
                              "Unggah File*",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary),
                            )
                          : Text(
                              "Unggah File",
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Constanst.fgPrimary),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Ukuran file max 5 MB",
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgSecondary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            controller.takeFile();
                          },
                          customBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1.0,
                                    color: Color.fromARGB(255, 211, 205, 205))),
                            child: Icon(
                              Iconsax.add,
                              size: 26,
                              color: Constanst.fgSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.namaFileUpload.value.length > 20
                              ? '${controller.namaFileUpload.value.substring(0, 15)}...'
                              : controller.namaFileUpload.value,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Constanst.fgPrimary),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(
              height: 0,
              thickness: 1,
              color: Constanst.fgBorder,
            ),
          ),
        ],
      ),
    );
  }

  Widget formAlasan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Iconsax.textalign_justifyleft, size: 24),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Catatan",
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Constanst.fgPrimary),
              ),
              TextFormField(
                controller: controller.alasan.value,
                decoration: const InputDecoration(
                  hintText: 'Tulis catatan disini',
                  border: InputBorder.none,
                ),
                style: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget informasiSisaCuti() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/5_cuti.svg',
                      height: 22,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Izin Pribadi",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: Constanst.fgPrimary,
                          fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  "${controller.jumlahIzin.value} Total",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.fgSecondary,
                      fontSize: 12),
                ),
                // Expanded(
                //     child: Text(
                //   "${controller.izinTerpakai.value}/${controller.jumlahIzin.value}",
                //   textAlign: TextAlign.right,
                // )),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Center(
                child: LinearPercentIndicator(
                  barRadius: const Radius.circular(100.0),
                  lineHeight: 8.0,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  percent: controller.percentIzin.value,
                  progressColor: Constanst.colorPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${controller.jumlahIzin.value - controller.izinTerpakai.value} Tersisa",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.infoLight,
                      fontSize: 12),
                ),
                Text(
                  "${controller.izinTerpakai.value} Terpakai",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: Constanst.color4,
                      fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
