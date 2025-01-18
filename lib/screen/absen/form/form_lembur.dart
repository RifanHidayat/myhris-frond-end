// ignore_for_file: deprecated_member_use
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/lembur_controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FormLembur extends StatefulWidget {
  List? dataForm;
  FormLembur({Key? key, this.dataForm}) : super(key: key);
  @override
  _FormLemburState createState() => _FormLemburState();
}

class _FormLemburState extends State<FormLembur> {
  var controller = Get.put(LemburController());
  final TextEditingController taskEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('ini data lembur ${widget.dataForm![0]}');
      if (widget.dataForm![1] == true) {
        controller.nomorAjuan.value.text =
            "${widget.dataForm![0]['nomor_ajuan']}";
        controller.tanggalLembur.value.text =
            Constanst.convertDate("${widget.dataForm![0]['atten_date']}");
        var convertDariJam = widget.dataForm![0]['dari_jam'].split(":");
        var convertSampaiJam = widget.dataForm![0]['sampai_jam'].split(":");
        var hasilDarijam = "${convertDariJam[0]}:${convertDariJam[1]}";
        var hasilSampaijam = "${convertSampaiJam[0]}:${convertSampaiJam[1]}";
        print('ini hasil Dari $hasilDarijam');
        controller.dariJam.value.text = hasilDarijam;
        controller.sampaiJam.value.text = hasilSampaijam;
        controller.catatan.value.text = widget.dataForm![0]['uraian'];
        controller.statusForm.value = true;
        controller.idpengajuanLembur.value = "${widget.dataForm![0]['id']}";
        controller.emIdDelegasi.value =
            "${widget.dataForm![0]['em_delegation']}";
        controller.checkingDelegation(widget.dataForm![0]['em_delegation']);
        controller.infoIds(widget.dataForm![0]['em_ids']);
      } else {
        controller.statusForm.value = false;
        controller.removeAll();
        addNewTask();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constanst.coloBackgroundScreen,
      appBar: AppBar(
          backgroundColor: Constanst.colorWhite,
          elevation: 0,
          leadingWidth: 50,
          titleSpacing: 0,
          centerTitle: true,
          title: Text(
            "Pengajuan Lembur",
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
              Get.back();
            },
          )),
      body: SingleChildScrollView(
        child: WillPopScope(
            onWillPop: () async {
              Get.back();
              return true;
            },
            child: SafeArea(
              child: Obx(
                () => Column(
                  children: [
                    Obx(() => controller.statusJam.value.isNotEmpty
                        ? Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, left: 16.0),
                            child: UtilsAlert.infoContainer(
                                controller.statusJam.value),
                          )
                        : const SizedBox(height: 18.0)),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 8),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Constanst.fgBorder,
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12))),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              controller.viewTypeLembur.value == false
                                  ? const SizedBox()
                                  : formType(),
                              formHariDanTanggal(),
                              formJam(),
                              formDelegasiKepada(),
                              formTugasKepada(),
                              formCatatan(),
                            ],
                          ),
                        )),
                    formTugas(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            addNewTask();
                          },
                          child: Text(
                            '+  Tambah Task',
                            style: TextStyle(color: Constanst.colorPrimary),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Constanst.colorWhite,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Constanst.colorPrimary),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
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
            child: ElevatedButton(
              onPressed: () {
                print("tes ${controller.dariJam.value.text.toString()}");
                // TimeOfDay _startTime = TimeOfDay(
                //     hour: int.parse(
                //         controller.dariJam.value.text.toString().split(":")[0]),
                //     minute: int.parse(controller.dariJam.value.text
                //         .toString()
                //         .split(":")[1]));
                // TimeOfDay _endTime = TimeOfDay(
                //     hour: int.parse(controller.sampaiJam.value.text
                //         .toString()
                //         .split(":")[0]),
                //     minute: int.parse(controller.sampaiJam.value.text
                //         .toString()
                //         .split(":")[1]));

                // if (_endTime.hour >= _startTime.hour) {
                //   if (_endTime.hour == _startTime.hour) {
                //     if (_endTime.minute < _startTime.minute) {
                //       UtilsAlert.showToast(
                //           "waktu yang dimasukan tidak valid, coba periksa lagi waktu lemburmu");

                //       return;
                //     }
                //   }
                //   print("masuk sini");
                //   controller.validasiKirimPengajuan();
                // } else {

                //   UtilsAlert.showToast(
                //       "waktu yang dimasukan tidak valid, coba periksa lagi waktu lemburmu");
                // }

                //

                controller.validasiKirimPengajuan();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Constanst.colorWhite,
                  backgroundColor: Constanst.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
              child: Text(
                'Kirim',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Constanst.colorWhite),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formType() {
    return InkWell(
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ),
      ),
      onTap: () async {
        await showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(16, 123, 16, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // initialValue: controller.selectedTypeLembur.value,
          items: controller.typeLembur.value
              .map<PopupMenuItem<String>>((String value) {
            return PopupMenuItem<String>(
              value: value,
              padding: EdgeInsets.zero,
              onTap: () {
                print('ini value $value');
                controller.selectedTypeLembur.value = value;
                print('ini value ${controller.selectedTypeLembur.value}');
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
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
                                  "Tipe Lembur*",
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Obx(
                                  () => Text(
                                    controller.selectedTypeLembur.value,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                    ),
                                  ),
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
                );
              },
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
          //           width: 0.5,
          //           color: const Color.fromARGB(255, 211, 205, 205))),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: DropdownButtonHideUnderline(
          //       child: DropdownButton<String>(
          //         isDense: true,
          //         autofocus: true,
          //         focusColor: Colors.grey,
          //         items: controller.typeLembur.value
          //             .map<DropdownMenuItem<String>>((String value) {
          //           return DropdownMenuItem<String>(
          //             value: value,
          //             child: Text(
          //               value,
          //               style: GoogleFonts.inter(fontSize: 14),
          //             ),
          //           );
          //         }).toList(),
          //         value: controller.selectedTypeLembur.value,
          //         onChanged: (selectedValue) {
          //           controller.selectedTypeLembur.value = selectedValue!;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    // if (picked != null && picked != _selectedDate)
    setState(() {
      //_selectedDate = picked;
    });
  }

  Widget formHariDanTanggal() {
    return InkWell(
      onTap: () async {
        // DateTime now = DateTime.now();
        // DateTime firstDateOfMonth =
        //     DateTime(now.year, now.month + 0, 1);
        // DateTime lastDayOfMonth =
        //     DateTime(now.year, now.month + 1, 0);
        var dateSelect = await showDatePicker(
          context: Get.context!,
          firstDate:
              AppData.informasiUser![0].isBackDateLembur.toString() == "0"
                  ? DateTime(2000)
                  : DateTime.now(),
          lastDate: DateTime(2100),
          initialDate: controller.initialDate.value,
          cancelText: 'Batal',
          confirmText: 'Simpan',
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                colorScheme: ColorScheme.dark(
                  primary: Constanst.onPrimary,
                  onPrimary: Constanst.colorWhite,
                  onSurface: Constanst.fgPrimary,
                  surface: Constanst.colorWhite,
                ),
                // useMaterial3: settings.useMaterial3,
                visualDensity: VisualDensity.standard,
                dialogTheme: const DialogTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
                primaryColor: Constanst.fgPrimary,
                textTheme: TextTheme(
                  titleMedium: GoogleFonts.inter(
                    color: Constanst.fgPrimary,
                  ),
                ),
                dialogBackgroundColor: Constanst.colorWhite,
                canvasColor: Colors.white,
                hintColor: Constanst.onPrimary,
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Constanst.onPrimary,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (dateSelect == null) {
          UtilsAlert.showToast("Tanggal tidak terpilih");
        } else {
          controller.initialDate.value = dateSelect;
          controller.tanggalLembur.value.text =
              Constanst.convertDate("$dateSelect");
          this.controller.tanggalLembur.refresh();
          var startTimeParts =
              controller.dariJam.value.text.split(":").map(int.parse).toList();
          var endTimeParts = controller.sampaiJam.value.text
              .split(":")
              .map(int.parse)
              .toList();

          var startTime =
              TimeOfDay(hour: startTimeParts[0], minute: startTimeParts[1]);
          var endTime =
              TimeOfDay(hour: endTimeParts[0], minute: endTimeParts[1]);
          final currentDate = controller.initialDate.value;
          final nextDate = currentDate.add(const Duration(days: 1));

          if (endTime.hour < startTime.hour ||
              (endTime.hour == startTime.hour &&
                  endTime.minute < startTime.minute)) {
            controller.statusJam.value =
                "Lembur dari tanggal ${Constanst.convertDate1(currentDate.toString())} jam ${controller.dariJam.value.text} s/d tanggal ${Constanst.convertDate1(nextDate.toString())} jam ${controller.sampaiJam.value.text}";
          } else {
            controller.statusJam.value = "";
          }
          // DateTime now = DateTime.now();
          // if (now.month == dateSelect.month) {
          //   controller.initialDate.value = dateSelect;
          //   controller.tanggalLembur.value.text =
          //       Constanst.convertDate("$dateSelect");
          //   this.controller.tanggalLembur.refresh();
          // } else {
          //   UtilsAlert.showToast(
          //       "Tidak bisa memilih tanggal di luar bulan ini");
          // }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Iconsax.calendar_2,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hari & Tanggal*",
                          style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Constanst.fgPrimary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.tanggalLembur.value.text,
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

  Widget formJam() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  showTimePicker(
                    context: Get.context!,
                    initialTime: TimeOfDay.now(),
                    // initialEntryMode: TimePickerEntryMode.input,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.light(
                              primary: Constanst.onPrimary,
                            ),
                            // useMaterial3: settings.useMaterial3,
                            dialogTheme: const DialogTheme(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)))),
                            primaryColor: Constanst.fgPrimary,
                            textTheme: TextTheme(
                              titleMedium: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                              ),
                            ),
                            dialogBackgroundColor: Constanst.colorWhite,
                            canvasColor: Colors.white,
                            hintColor: Constanst.onPrimary,
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Constanst.onPrimary,
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                    },
                  ).then((value) {
                    if (value == null) {
                      UtilsAlert.showToast('gagal pilih jam');
                    } else {
                      var convertJam =
                          value.hour <= 9 ? "0${value.hour}" : "${value.hour}";
                      var convertMenit = value.minute <= 9
                          ? "0${value.minute}"
                          : "${value.minute}";
                      controller.dariJam.value.text =
                          "$convertJam:$convertMenit";
                      this.controller.dariJam.refresh();

                      var startTimeParts = controller.dariJam.value.text
                          .split(":")
                          .map(int.parse)
                          .toList();
                      var endTimeParts = controller.sampaiJam.value.text
                          .split(":")
                          .map(int.parse)
                          .toList();

                      var startTime = TimeOfDay(
                          hour: startTimeParts[0], minute: startTimeParts[1]);
                      var endTime = TimeOfDay(
                          hour: endTimeParts[0], minute: endTimeParts[1]);

                      final currentDate = controller.initialDate.value;
                      final nextDate = currentDate.add(const Duration(days: 1));

                      if (endTime.hour < startTime.hour ||
                          (endTime.hour == startTime.hour &&
                              endTime.minute < startTime.minute)) {
                        controller.statusJam.value =
                            "Lembur dari tanggal ${Constanst.convertDate1(currentDate.toString())} jam ${controller.dariJam.value.text} s/d tanggal ${Constanst.convertDate1(nextDate.toString())} jam ${controller.sampaiJam.value.text}";
                      } else {
                        controller.statusJam.value = "";
                      }
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Iconsax.clock,
                            size: 26,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dari jam*",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgPrimary),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.dariJam.value.text,
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
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  showTimePicker(
                    context: Get.context!,
                    initialTime: TimeOfDay.now(),
                    // initialEntryMode: TimePickerEntryMode.input,
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.light(
                              primary: Constanst.onPrimary,
                            ),
                            // useMaterial3: settings.useMaterial3,
                            dialogTheme: const DialogTheme(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)))),
                            primaryColor: Constanst.fgPrimary,
                            textTheme: TextTheme(
                              titleMedium: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                              ),
                            ),
                            dialogBackgroundColor: Constanst.colorWhite,
                            canvasColor: Colors.white,
                            hintColor: Constanst.onPrimary,
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Constanst.onPrimary,
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                    },
                  ).then((value) {
                    if (value == null) {
                      UtilsAlert.showToast('gagal pilih jam');
                    } else {
                      var convertJam =
                          value.hour <= 9 ? "0${value.hour}" : "${value.hour}";
                      var convertMenit = value.minute <= 9
                          ? "0${value.minute}"
                          : "${value.minute}";
                      controller.sampaiJam.value.text =
                          "$convertJam:$convertMenit";
                      this.controller.sampaiJam.refresh();

                      var startTimeParts = controller.dariJam.value.text
                          .split(":")
                          .map(int.parse)
                          .toList();
                      var endTimeParts = controller.sampaiJam.value.text
                          .split(":")
                          .map(int.parse)
                          .toList();

                      var startTime = TimeOfDay(
                          hour: startTimeParts[0], minute: startTimeParts[1]);
                      var endTime = TimeOfDay(
                          hour: endTimeParts[0], minute: endTimeParts[1]);

                      final currentDate = controller.initialDate.value;
                      final nextDate = currentDate.add(const Duration(days: 1));

                      if (endTime.hour < startTime.hour ||
                          (endTime.hour == startTime.hour &&
                              endTime.minute < startTime.minute)) {
                        controller.statusJam.value =
                            "Lembur dari tanggal ${Constanst.convertDate1(currentDate.toString())} jam ${controller.dariJam.value.text} s/d tanggal ${Constanst.convertDate1(nextDate.toString())} jam ${controller.sampaiJam.value.text}";
                      } else {
                        controller.statusJam.value = "";
                      }
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sampai jam*",
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Constanst.fgPrimary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.sampaiJam.value.text,
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Constanst.fgPrimary),
                          ),
                        ],
                      ),
                      Icon(Iconsax.arrow_down_1,
                          size: 20, color: Constanst.fgPrimary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // controller.statusJam.value == ""
        //     ? Container()
        //     : Padding(
        //         padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
        //         child: Row(
        //           children: [
        //             Icon(
        //               Iconsax.info_circle,
        //               size: 16,
        //               color: Constanst.fgSecondary,
        //             ),
        //             const SizedBox(width: 8.0),
        //             Text(
        //               controller.statusJam.value,
        //               style: GoogleFonts.inter(
        //                   fontSize: 12,
        //                   fontWeight: FontWeight.w400,
        //                   color: Constanst.fgSecondary),
        //             ),
        //           ],
        //         ),
        //       ),
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

  Widget formDelegasiKepada() {
    return InkWell(
      onTap: () {
        // controller.loadAllEmployeeDelegasi();
        // controller.cariAtas.value.clear;
              bottomSheetPengajuanAbsen();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.profile_add,
                    size: 26,
                    color: Constanst.fgPrimary,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Perintah kerja lembur*",
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Constanst.fgPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.selectedDropdownDelegasi.value,
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Constanst.fgPrimary),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Iconsax.arrow_down_1, size: 20, color: Constanst.fgPrimary),
            ],
          ),
        ),
      ),
    );
  }

  Widget formTugasKepada() {
    return InkWell(
      onTap: (){
        // controller.cariBerhubungan.value.clear;
        bottomSheetEmploy();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Divider(
              height: 0,
              thickness: 1,
              color: Constanst.border,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Iconsax.profile_add,
                          size: 26,
                          color: Constanst.fgPrimary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Peminta Lembur*",
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Constanst.fgPrimary),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.selectedDropdownEmploy.join(", "),
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
          ),
        ],
      ),
    );
  }

  void bottomSheetPengajuanAbsen() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.statusFormPencarianAtas.value
                      ?SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextFormField(
                        // controller: controller.searchController,
                        controller: controller.cariAtas.value,
                        onChanged: (value){
                          controller.stringCariAtas.value = value;
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
                                  controller.stringCariAtas.value = '';
                                  controller.showInputCariAtasPerintah();
                                },
                              ),
                            )),
                      ),
                    )
                      :Text(
                        "Peminta kerja lembur",
                        style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      controller.statusFormPencarianAtas.value
                      ?Container()
                      :InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          onTap: () {
                            controller.stringCariAtas.value = '';
                            controller.showInputCariAtasPerintah();
                          },
                          child: Icon(
                            Icons.search,
                            opticalSize: 24,
                            color: Constanst.fgSecondary,
                          ))
                    ],
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                thickness: 1,
                height: 0,
                color: Constanst.border,
              ),
            ),
            Expanded(
              child: Obx(() {
                var filterDelegasi = controller.allEmployeeDelegasi.value.where((delegasi){
                  return delegasi.toLowerCase().contains(
                    controller.stringCariAtas.value.toLowerCase());
                }).toList();
                  return SingleChildScrollView(
                    child: ListView.builder(
                        itemCount: filterDelegasi.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var data = filterDelegasi[index];
                          return Obx(() {
                            var isSelected =
                                controller.selectedDropdownDelegasi.contains(data);
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.selectedDropdownDelegasi.value =
                                        data;
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(data,
                                            style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Constanst.fgPrimary)),
                                        isSelected
                                            ? InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color:
                                                              Constanst.onPrimary),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Constanst.onPrimary,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10)),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  controller
                                                      .selectedDropdownDelegasi
                                                      .value = data;
                                                  Get.back();
                                                },
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color:
                                                              Constanst.onPrimary),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
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
                                ),
                              ],
                            );
                          });
                        }));
                }
              ),
              ),
    
          ],
        );
      },
    );
  }

  void bottomSheetEmploy() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.statusFormPencarianBerhubungan.value
                      ?SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 40,
                      child: TextFormField(
                        // controller: controller.searchController,
                        controller: controller.cariBerhubungan.value,
                        onChanged: (value){
                          controller.stringCari.value = value;
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
                                  controller.stringCari.value = '';
                                  // controller.cariBerhubungan.value.clear();
                                  controller.showInputCariBerhubungan();
                                },
                              ),
                            )),
                      ),
                    )
                      :Text(
                        "Peminta lembur",
                        style: GoogleFonts.inter(
                            color: Constanst.fgPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      controller.statusFormPencarianBerhubungan.value
                      ?Container()
                      :InkWell(
                          customBorder: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          onTap: () {
                            controller.stringCari.value = '';
                            controller.showInputCariBerhubungan();
                          },
                          child: Icon(
                            Icons.search,
                            opticalSize: 24,
                            color: Constanst.fgSecondary,
                          ))
                    ],
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(
                thickness: 1,
                height: 0,
                color: Constanst.border,
              ),
            ),
            Expanded(child: Obx(() {
              var filteredEmployees =
                  controller.infoEmployeeAll.where((employee) {
                var fullName = employee['full_name'] ?? '';
                return fullName.toLowerCase().contains(
                    controller.stringCari.value.toLowerCase()) || controller.selectedDropdownEmploy.contains(fullName);
              }).toList();

              return SingleChildScrollView(
                child:  ListView.builder(
                    itemCount: filteredEmployees.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      var data = filteredEmployees[index]['full_name'];
                      return Obx(() {
                        var isSelected =
                            controller.selectedDropdownEmploy.contains(data);
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                if (isSelected) {
                                  if (controller
                                          .selectedDropdownEmploy.length ==
                                      1) {
                                    UtilsAlert.showToast('Pastikan anda mengisi minimal 1 tugas');
                                  } else {
                                    controller.selectedDropdownEmploy
                                        .remove(data);
                                    print(
                                        "ini hapus data ${controller.selectedDropdownEmploy.value}");
                                  }
                                } else {
                                  controller.selectedDropdownEmploy.add(data);
                                  print(
                                      "ini tambah data ${controller.selectedDropdownEmploy.value}");
                                }
                                controller.selectedDropdownEmploy.refresh();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data,
                                        style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Constanst.fgPrimary)),
                                    isSelected
                                        ? Container(
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
                                          )
                                        : Container(
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
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                    }),
              );
            })),
          ],
        );
      },
    );
  }

  Widget formCatatan() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(
            height: 0,
            thickness: 1,
            color: Constanst.fgBorder,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Iconsax.textalign_justifyleft, size: 24),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextLabell(
                      text: "Catatan *",
                      color: Constanst.fgPrimary,
                      size: 14,
                      weight: FontWeight.w400,
                    ),
                    TextFormField(
                      controller: controller.catatan.value,
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
          ),
        ],
      ),
    );
  }

  Widget formTugas() {
    return Obx(
      () => Column(
          children: List.generate(controller.listTask.length, (index) {
        var data = controller.listTask[index];
        print('ini data listTask $data');
        return Dismissible(
          key: Key(data.hashCode.toString()),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (direction) async {
            if (controller.listTask.length == 1) {
              UtilsAlert.showToast("Pastikan anda mengisi minimal 1 tugas");
              return false;
            } else {
              return true;
            }
          },
          onDismissed: (direction) {
            controller.listTask.removeAt(index);
          },
          child: Padding(
            padding: EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Constanst.fgBorder, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}.'),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLabell(
                                  text: "Tugas *",
                                  color: Constanst.fgPrimary,
                                  size: 14,
                                  weight: FontWeight.w400,
                                ),
                                TextFormField(
                                  minLines: 1,
                                  maxLines: 10,
                                  controller:
                                      TextEditingController(text: data['task']),
                                  decoration: const InputDecoration(
                                    hintText: 'Tulis tugas anda disini',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    data['task'] = value;
                                  },
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (controller.listTask.length == 1) {
                                UtilsAlert.showToast(
                                    "Gak bisa dihapus semuanya kawan");
                              } else {
                                controller.listTask.removeAt(index);
                              }
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      })),
    );
  }

  void addNewTask() {
    controller.listTask.add({"task": ""});
  }
}
