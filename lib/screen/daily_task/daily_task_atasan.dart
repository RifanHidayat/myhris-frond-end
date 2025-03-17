import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/daily_task_controller.dart';
import 'package:siscom_operasional/model/daily_task_model.dart';
import 'package:siscom_operasional/screen/daily_task/detail_daily_task.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/month_year_picker.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class DailyTaskAtasan extends StatefulWidget {
  @override
  State<DailyTaskAtasan> createState() => _DailyTaskAtasanState();
}


class _DailyTaskAtasanState extends State<DailyTaskAtasan> {
  @override
  void initState() {
    super.initState();
    controller.getTimeNow();
    
  }
  final DailyTaskController controller = Get.put(DailyTaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text("Daily Task")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  filterData(),
                  Expanded(child: status())
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: controller.allTask.isEmpty
                      ? Center(
                          child: Text('Sedang memuat data, sabar ya'),
                        )
                      : listAbsen(),
                );
              }
                    ),
            ),
          ],
        ),
    );
  }

  Widget listAbsen() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.allTask.length,
      itemBuilder: (context, index) {
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, index + 1);

        DailyTaskModel taskForDate = controller.allTask.firstWhere(
          (task) => task.date == date.toString().substring(0, 10),
          orElse: () => DailyTaskModel(),
        );

        // return Obx(() {
          return tampilan2(taskForDate, date);
        // });
      },
    );
    // });
  }

  Widget tampilan2(DailyTaskModel index, date) {
    print('ini index date ${index.atten_date}');
    print('ini id index ${index.id}');
    var startTime;
    var endTime;
    var startDate;
    var endDate;
    var now = DateTime.now();

    TimeOfDay waktu1 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[0]),
        minute: int.parse(
            AppData.informasiUser![0].startTime.toString().split(':')[1]));

    TimeOfDay waktu2 = TimeOfDay(
        hour: int.parse(
            AppData.informasiUser![0].endTime.toString().split(':')[0]),
        minute: int.parse(AppData.informasiUser![0].endTime
            .toString()
            .split(':')[1])); // Waktu kedua
    print('ini waktu 1${AppData.informasiUser![0].startTime}');
    int totalMinutes1 = waktu1.hour * 60 + waktu1.minute;
    int totalMinutes2 = waktu2.hour * 60 + waktu2.minute;

    //alur normal
    // if (totalMinutes1 < totalMinutes2) {
    //   startTime = DateTime.parse(
    //       '${index.atten_date} ${AppData.informasiUser![0].startTime}:00');
    //   endTime = DateTime.parse(
    //       '${index.atten_date} ${AppData.informasiUser![0].endTime}:00');

    //   //alur beda hari
    // } else if (totalMinutes1 > totalMinutes2) {
    //   var waktu3 =
    //       TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    //   int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

    //   if (totalMinutes2 > totalMinutes3) {
    //     print("masuk sini view las user");
    //     var today;
    //     if (index.atten_date!.isNotEmpty) {
    //       today = DateTime.parse(index.atten_date!);
    //     }
    //     var yesterday = today.add(const Duration(days: 1));
    //     startDate = DateFormat('yyyy-MM-dd').format(yesterday);
    //     endDate = DateFormat('yyyy-MM-dd').format(today);
    //     startTime = DateTime.parse(
    //         '$startDate ${AppData.informasiUser![0].startTime}:00');
    //     endTime =
    //         DateTime.parse('$endDate ${AppData.informasiUser![0].endTime}:00');
    //     print('ini  bener gakl lu${startTime.isAfter(today)}');
    //   } else {
    //     var today;
    //     print('masa lu kosong sih ${index.atten_date}');
    //     // if (index.atten_date!.isNotEmpty) {
    //     //   today = DateTime.parse(index.atten_date!);
    //     // } else {
    //     //   today = DateTime.now();
    //     // }
    //     today = DateTime.now();
    //     var yesterday = today.add(const Duration(days: 1));

    //     startDate = DateFormat('yyyy-MM-dd').format(today);
    //     endDate = DateFormat('yyyy-MM-dd').format(yesterday);

    //     startTime = DateTime.parse(
    //         '$startDate ${AppData.informasiUser![0].startTime}:00'); // Waktu kemarin
    //     endTime =
    //         DateTime.parse('$endDate ${AppData.informasiUser![0].endTime}:00');
    //     print(
    //         'ini  bener gakl lu${startTime.isBefore(today)}'); // Waktu hari ini
    //     print('ini  bener gakl lu${startTime}'); // Waktu hari ini
    //     print('ini  bener gakl lu${endTime}'); // Waktu hari ini
    //   }
    // } else {
    //   startTime = AppData.informasiUser![0].startTime;
    //   endTime = AppData.informasiUser![0].endTime;

    //   startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //   endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    //   print(
    //       "Waktu 1 sama dengan waktu 2 new ${totalMinutes1}  ${totalMinutes2}");
    // }
    var tipeAbsen = AppData.informasiUser![0].tipeAbsen;
    var tipeAlpha = AppData.informasiUser![0].tipeAlpha;
    var list = tipeAlpha.toString().split(',').map(int.parse).toList();
    print('ini tampilan 2 $tipeAbsen $tipeAlpha $list');
    var masuk = list[0];
    var keluar = list[1];
    var istirahatMasuk = list[2];
    var istirahatKeluar = list[3];
    var jamMasuk = index.signin_time ?? '';
    var jamKeluar = index.signout_time ?? '';
    print(jamKeluar.isEmpty);
    print(keluar);
    var jamIstirahatMasuk = index.breakinTime ?? '';
    var jamIstirahatKeluar = index.breakoutTime ?? '';
    if (tipeAbsen == '2') {
      if ((keluar == 1 && jamKeluar == '00:00:00') ||
          (masuk == 1 && jamMasuk == '00:00:00')) {
        controller.tipeAlphaAbsen.value = 1;
        if (jamMasuk == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Masuk';
        } else {
          controller.catatanAlpha.value = '/ Gak Absen Keluar';
        }
      } else {
        controller.tipeAlphaAbsen.value = 0;
      }
    } else if (tipeAbsen == '3') {
      print('gak mungkin gak kemari');
      if ((keluar == 1 && jamKeluar == '00:00:00') ||
          (masuk == 1 && jamMasuk == '00:00:00') ||
          (jamIstirahatKeluar == '00:00:00' && istirahatKeluar == 1) ||
          (jamIstirahatMasuk == '00:00:00' && istirahatMasuk == 1)) {
        print('masa gak kesini');
        controller.tipeAlphaAbsen.value = 1;
        if (jamMasuk == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Masuk';
        } else if (jamKeluar == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Keluar';
        } else if (jamIstirahatKeluar == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Istirahat Keluar';
        } else if (jamIstirahatMasuk == '00:00:00') {
          controller.catatanAlpha.value = '/ Gak Absen Istirahat Masuk';
        }
      } else {
        controller.tipeAlphaAbsen.value = 0;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        onTap: () async {
          UtilsAlert.showLoadingIndicator(context);
          await controller.loadTask(index.id);
          Get.to(DetailDailyTask(index.id));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Constanst.fgBorder)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Constanst.colorNeutralBgSecondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: index.namaHariLibur != null || index.offDay.toString() != '0'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    DateFormat('d').format(
                                        DateFormat('yyyy-MM-dd').parse(
                                            index.date ?? date.toString())),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Constanst.fgPrimary,
                                    )),
                                Text(
                                    DateFormat('EEEE', 'id').format(
                                        DateFormat('yyyy-MM-dd').parse(
                                            index.date ?? date.toString())),
                                    style: GoogleFonts.inter(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                      color: Constanst.fgPrimary,
                                    )),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                    DateFormat('d').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.date)),
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    )),
                                Text(
                                    DateFormat('EEEE', 'id').format(
                                        DateFormat('yyyy-MM-dd')
                                            .parse(index.date)),
                                    style: GoogleFonts.inter(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 85,
                child: index.atten_date == "" || index.atten_date == null
                    ?
                    //tidak ada absen
                    index.namaHariLibur != null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 18),
                            child: TextLabell(
                              text: index.namaHariLibur,
                              weight: FontWeight.w500,
                            ))
                        : index.namaTugasLuar != null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: TextLabell(
                                  text: "Tugas Luar",
                                  weight: FontWeight.w500,
                                ))
                            : index.namaDinasLuar != null
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 18),
                                    child: TextLabell(
                                      text: "Dinas Luar",
                                      weight: FontWeight.w500,
                                    ))
                                : index.namaCuti != null
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 18),
                                        child: TextLabell(
                                          text: "Cuti",
                                          weight: FontWeight.w500,
                                        ))
                                    : index.namaSakit != null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 18),
                                            child: TextLabell(
                                              text:
                                                  "Sakit : ${index.namaSakit}",
                                              weight: FontWeight.w500,
                                            ))
                                        : index.namaIzin != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18),
                                                child: TextLabell(
                                                  text:
                                                      "Izin : ${index.namaIzin}",
                                                  weight: FontWeight.w500,
                                                ))
                                            : index.offDay.toString() == '0'
                                                ? const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18),
                                                    child: TextLabell(
                                                      text: "Hari Libur Kerja",
                                                      weight: FontWeight.w500,
                                                    ))
                                                : const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18),
                                                    child: TextLabell(
                                                      text:
                                                          "Belum ada task",
                                                      weight: FontWeight.w500,
                                                    ))
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          index.atten_date != "" || index.atten_date != null
                              ? controller.tipeAlphaAbsen.value == 1 &&
                                      (endTime.isBefore(now))
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Iconsax.info_circle,
                                            size: 15,
                                            color: Constanst.infoLight,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          TextLabell(
                                            text:
                                                "ALPHA ${controller.catatanAlpha.value}",
                                            weight: FontWeight.w400,
                                            size: 11.0,
                                          ),
                                        ],
                                      ))
                                  : index.namaHariLibur != null
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Iconsax.info_circle,
                                                size: 15,
                                                color: Constanst.infoLight,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextLabell(
                                                text: index.namaHariLibur,
                                                weight: FontWeight.w400,
                                                size: 11.0,
                                              ),
                                            ],
                                          ))
                                      : index.namaTugasLuar != null
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Iconsax.info_circle,
                                                    size: 15,
                                                    color: Constanst.infoLight,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextLabell(
                                                    text: index.namaTugasLuar,
                                                    weight: FontWeight.w400,
                                                    size: 11.0,
                                                  ),
                                                ],
                                              ))
                                          : index.namaDinasLuar != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Iconsax.info_circle,
                                                        size: 15,
                                                        color:
                                                            Constanst.infoLight,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      TextLabell(
                                                        text:
                                                            index.namaDinasLuar,
                                                        weight: FontWeight.w400,
                                                        size: 11.0,
                                                      ),
                                                    ],
                                                  ))
                                              : index.namaCuti != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 12),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Iconsax.info_circle,
                                                            size: 15,
                                                            color: Constanst
                                                                .infoLight,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          TextLabell(
                                                            text:
                                                                index.namaCuti,
                                                            weight:
                                                                FontWeight.w400,
                                                            size: 11.0,
                                                          ),
                                                        ],
                                                      ))
                                                  : index.namaSakit != null
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 12),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Iconsax
                                                                    .info_circle,
                                                                size: 15,
                                                                color: Constanst
                                                                    .infoLight,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              TextLabell(
                                                                text: index
                                                                    .namaSakit,
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                size: 11.0,
                                                              ),
                                                            ],
                                                          ))
                                                      : index.offDay
                                                                  .toString() ==
                                                              '0'
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 18),
                                                              child: const TextLabell(
                                                                text:
                                                                    "Hari Libur Kerja",
                                                                weight:
                                                                    FontWeight
                                                                        .w400,
                                                                size: 11.0,
                                                              ))
                                                          : SizedBox()
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 18),
                            child: Text(
                              "Lihat task",
                              style: GoogleFonts.inter(
                                  color: Constanst
                                      .fgPrimary,
                                  fontWeight:
                                      FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Finish: ${index.breakoutNote.toString()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Ongoing: ${index.breakoutTime.toString()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Jumlah: ${index.breakoutPict.toString()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        ],
                      ),
              )
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
      isScrollControlled: true, // Ini memastikan modal bisa di-scroll
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Ukuran awal modal sheet
          minChildSize: 0.4, // Ukuran minimum modal sheet
          maxChildSize: 0.9, // Ukuran maksimal modal sheet
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Karyawan",
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
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              size: 26,
                              color: Constanst.fgSecondary,
                            ),
                          ),
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
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController, // Controller untuk scroll
                        // physics: const BouncingScrollPhysics(),
                        child: Obx(() {
                          return Column(
                            children: List.generate(
                                controller.monitoringList.length, (index) {
                                  var monitoring =  controller.monitoringList[0];
                              var full_name =
                                  monitoring[index]['full_name'];
                              var em_id = monitoring[index]['em_id'];
                              var isSelected =
                                  controller.tempNamaStatus1.value == full_name;

                              return InkWell(
                                onTap: () {
                                  controller.tempNamaStatus1.value = full_name;
                                  controller.emId.value = em_id;
                                  controller.loadAllTask(controller.emId.value);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 16, 16, 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          Text(
                                            full_name.toString(),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Constanst.fgPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: isSelected ? 2 : 1,
                                            color: isSelected
                                                ? Constanst.onPrimary
                                                : Constanst.onPrimary
                                                    .withOpacity(0.5),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: isSelected
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Constanst.onPrimary,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      // print('Bottom sheet closed');
    });
  }

  Widget status() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        border: Border.all(color: Constanst.fgBorder),
      ),
      child: InkWell(
        customBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        onTap: () {
          if (controller.allTask.isEmpty) {
            // Get.snackbar("Error", "Data tidak tersedia.");
          } else {
            showBottomStatus(Get.context!);
            // Get.snackbar("${controller.monitoringList.length}", "ddd");
            const CircularProgressIndicator();
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.tempNamaStatus1.value,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Constanst.fgSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Icon(
                  Iconsax.arrow_down_1,
                  size: 18,
                  color: Constanst.fgSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterData() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                onTap: () {
                  DatePicker.showPicker(
                    Get.context!,
                    pickerModel: CustomMonthPicker(
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2100, 1, 1),
                      currentTime: DateTime(
                          int.parse(
                              controller.tahunSelectedSearchHistory.value),
                          int.parse(
                              controller.bulanSelectedSearchHistory.value),
                          1),
                    ),
                    onConfirm: (time) {
                      if (time != null) {
                        print("$time");
                        var filter = DateFormat('yyyy-MM').format(time);
                        var array = filter.split('-');
                        var bulan = array[1];
                        var tahun = array[0];
                        controller.bulanSelectedSearchHistory.value = bulan;
                        controller.tahunSelectedSearchHistory.value = tahun;
                        controller.bulanDanTahunNow.value = "$bulan-$tahun";
                        this.controller.bulanSelectedSearchHistory.refresh();
                        this.controller.tahunSelectedSearchHistory.refresh();
                        this.controller.bulanDanTahunNow.refresh();

                        controller.date.value = time;
                        controller.loadAllTask(controller.emId.value);
                      }
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Constanst.border)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
                    child: Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Constanst.convertDateBulanDanTahun(
                                  controller.bulanDanTahunNow.value),
                              style: GoogleFonts.inter(
                                  color: Constanst.fgSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Iconsax.arrow_down_1,
                                color: Constanst.fgSecondary,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}