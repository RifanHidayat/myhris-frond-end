import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:siscom_operasional/controller/absen_controller.dart';
import 'package:siscom_operasional/controller/daily_task_controller.dart';
import 'package:siscom_operasional/model/absen_model.dart';
import 'package:siscom_operasional/model/daily_task_model.dart';
import 'package:siscom_operasional/screen/absen/loading_absen.dart';
import 'package:siscom_operasional/screen/daily_task/detail_daily_task.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class DailyTask extends StatefulWidget {
  const DailyTask({super.key});

  @override
  State<DailyTask> createState() => _DailyTaskState();
}

class _DailyTaskState extends State<DailyTask> {
  final DailyTaskController controller = Get.put(DailyTaskController());
  final AbsenController controllerAbsensi = Get.put(AbsenController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your daily')),
        body: Obx(() {
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Constanst.colorWhite,
                          backgroundColor: Constanst.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12)),
                      child: Text(
                        'Tambah Task',
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

  Widget listAbsen() {
    // return Obx(() {

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day,
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
    if (totalMinutes1 < totalMinutes2) {
      startTime = DateTime.parse(
          '${index.atten_date} ${AppData.informasiUser![0].startTime}:00');
      endTime = DateTime.parse(
          '${index.atten_date} ${AppData.informasiUser![0].endTime}:00');

      //alur beda hari
    } else if (totalMinutes1 > totalMinutes2) {
      var waktu3 =
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
      int totalMinutes3 = waktu3.hour * 60 + waktu3.minute;

      if (totalMinutes2 > totalMinutes3) {
        print("masuk sini view las user");
        var today;
        if (index.atten_date!.isNotEmpty) {
          today = DateTime.parse(index.atten_date!);
        }
        var yesterday = today.add(const Duration(days: 1));
        startDate = DateFormat('yyyy-MM-dd').format(yesterday);
        endDate = DateFormat('yyyy-MM-dd').format(today);
        startTime = DateTime.parse(
            '$startDate ${AppData.informasiUser![0].startTime}:00');
        endTime =
            DateTime.parse('$endDate ${AppData.informasiUser![0].endTime}:00');
        print('ini  bener gakl lu${startTime.isAfter(today)}');
      } else {
        var today;
        print('masa lu kosong sih ${index.atten_date}');
        // if (index.atten_date!.isNotEmpty) {
        //   today = DateTime.parse(index.atten_date!);
        // } else {
        //   today = DateTime.now();
        // }
        today = DateTime.now();
        var yesterday = today.add(const Duration(days: 1));

        startDate = DateFormat('yyyy-MM-dd').format(today);
        endDate = DateFormat('yyyy-MM-dd').format(yesterday);

        startTime = DateTime.parse(
            '$startDate ${AppData.informasiUser![0].startTime}:00'); // Waktu kemarin
        endTime =
            DateTime.parse('$endDate ${AppData.informasiUser![0].endTime}:00');
        print(
            'ini  bener gakl lu${startTime.isBefore(today)}'); // Waktu hari ini
        print('ini  bener gakl lu${startTime}'); // Waktu hari ini
        print('ini  bener gakl lu${endTime}'); // Waktu hari ini
      }
    } else {
      startTime = AppData.informasiUser![0].startTime;
      endTime = AppData.informasiUser![0].endTime;

      startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      print(
          "Waktu 1 sama dengan waktu 2 new ${totalMinutes1}  ${totalMinutes2}");
    }
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
        onTap: () {
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
                      child: index.namaHariLibur == null ||
                              index.namaHariLibur == ""
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
                              size: 14.0,
                              weight: FontWeight.w500,
                            ))
                        : index.namaTugasLuar != null
                            ? const Padding(
                                padding: EdgeInsets.only(left: 18),
                                child: TextLabell(
                                  text: "Tugas Luar",
                                  size: 14.0,
                                  weight: FontWeight.w500,
                                ))
                            : index.namaDinasLuar != null
                                ? const Padding(
                                    padding: EdgeInsets.only(left: 18),
                                    child: TextLabell(
                                      text: "Dinas Luar",
                                      size: 14.0,
                                      weight: FontWeight.w500,
                                    ))
                                : index.namaCuti != null
                                    ? const Padding(
                                        padding: EdgeInsets.only(left: 18),
                                        child: TextLabell(
                                          text: "Cuti",
                                          size: 14.0,
                                          weight: FontWeight.w500,
                                        ))
                                    : index.namaSakit != null
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(left: 18),
                                            child: TextLabell(
                                              text:
                                                  "Sakit : ${index.namaSakit}",
                                              size: 14.0,
                                              weight: FontWeight.w500,
                                            ))
                                        : index.namaIzin != null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18),
                                                child: TextLabell(
                                                  text:
                                                      "Izin : ${index.namaIzin}",
                                                  size: 14.0,
                                                  weight: FontWeight.w500,
                                                ))
                                            : index.offDay.toString() == '0'
                                                ? const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18),
                                                    child: TextLabell(
                                                      text: "Hari Libur Kerja",
                                                      size: 14.0,
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
                                                                  const TextLabell(
                                                                    text:
                                                                        "Hari Libur Kerja",
                                                                    weight:
                                                                        FontWeight
                                                                            .w400,
                                                                    size: 11.0,
                                                                  ),
                                                                ],
                                                              ))
                                                          : SizedBox()
                              : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 1),
                            child: InkWell(
                              onTap: () {
                                // controller.historySelected(index.id, 'history');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 38,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Lihat task",
                                                      style: GoogleFonts.inter(
                                                          color: Constanst
                                                              .fgPrimary,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(height: 4),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Expanded(
                                        flex: 9,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color:
                                              Constanst.colorNeutralFgTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // index.turunan!.isNotEmpty
                          // ? Container(
                          //     padding: const EdgeInsets.only(top: 4),
                          //     child: Column(
                          //       children: [
                          //         index.statusView == false
                          //             ? const SizedBox()
                          //             : Column(
                          //                 children: List.generate(
                          //                     index.turunan!.length, (i) {
                          //                   var datum = index.turunan![i];
                          //                   var jamMasuk =
                          //                       datum.signin_time ?? '';
                          //                   var jamKeluar =
                          //                       datum.signout_time ?? '';
                          //                   var placeIn =
                          //                       datum.place_in ?? '';
                          //                   var placeOut =
                          //                       datum.place_out ?? '';
                          //                   var note =
                          //                       datum.signin_note ?? '';
                          //                   var signInLongLat =
                          //                       datum.signin_longlat ?? '';
                          //                   var signOutLongLat =
                          //                       datum.signout_longlat ?? '';
                          //                   var regType =
                          //                       datum.reqType ?? 0;
                          //                   var statusView;
                          //                   if (placeIn != "") {
                          //                     statusView =
                          //                         placeIn == "pengajuan" &&
                          //                                 placeOut ==
                          //                                     "pengajuan"
                          //                             ? true
                          //                             : false;
                          //                   }
                          //                   var listJamMasuk =
                          //                       (jamMasuk!.split(':'));
                          //                   var listJamKeluar =
                          //                       (jamKeluar!.split(':'));
                          //                   return Column(
                          //                     children: [
                          //                       const Divider(),
                          //                       Padding(
                          //                         padding:
                          //                             const EdgeInsets.only(
                          //                                 top: 6),
                          //                         child: InkWell(
                          //                           onTap: () {
                          //                             // controller
                          //                             //     .historySelected(
                          //                             //         datum.id,
                          //                             //         'history');
                          //                           },
                          //                           child: Row(
                          //                             children: [
                          //                               Expanded(
                          //                                 flex: 38,
                          //                                 child: Padding(
                          //                                   padding:
                          //                                       const EdgeInsets
                          //                                           .only(
                          //                                           left:
                          //                                               8.0),
                          //                                   child: Row(
                          //                                     mainAxisAlignment:
                          //                                         MainAxisAlignment
                          //                                             .start,
                          //                                     children: [
                          //                                       Icon(
                          //                                         Iconsax
                          //                                             .login_1,
                          //                                         color: Constanst
                          //                                             .color5,
                          //                                         size: 16,
                          //                                       ),
                          //                                       Padding(
                          //                                         padding: const EdgeInsets
                          //                                             .only(
                          //                                             left:
                          //                                                 4),
                          //                                         child:
                          //                                             Column(
                          //                                           crossAxisAlignment:
                          //                                               CrossAxisAlignment.start,
                          //                                           children: [
                          //                                             Text(
                          //                                               "$jamMasuk",
                          //                                               style: GoogleFonts.inter(
                          //                                                   color: Constanst.fgPrimary,
                          //                                                   fontWeight: FontWeight.w500,
                          //                                                   fontSize: 16),
                          //                                             ),
                          //                                             const SizedBox(
                          //                                                 height: 4),
                          //                                             Text(
                          //                                               regType == 0
                          //                                                   ? "Face Recognition"
                          //                                                   : "Photo",
                          //                                               style: GoogleFonts.inter(
                          //                                                   color: Constanst.fgSecondary,
                          //                                                   fontWeight: FontWeight.w400,
                          //                                                   fontSize: 10),
                          //                                             ),
                          //                                           ],
                          //                                         ),
                          //                                       )
                          //                                     ],
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                               Expanded(
                          //                                 flex: 38,
                          //                                 child: Padding(
                          //                                   padding:
                          //                                       const EdgeInsets
                          //                                           .only(
                          //                                           left:
                          //                                               4),
                          //                                   child: Row(
                          //                                     mainAxisAlignment:
                          //                                         MainAxisAlignment
                          //                                             .start,
                          //                                     children: [
                          //                                       Icon(
                          //                                         Iconsax
                          //                                             .logout_14,
                          //                                         color: Constanst
                          //                                             .color4,
                          //                                         size: 16,
                          //                                       ),
                          //                                       Padding(
                          //                                         padding: const EdgeInsets
                          //                                             .only(
                          //                                             left:
                          //                                                 4),
                          //                                         child:
                          //                                             Column(
                          //                                           crossAxisAlignment:
                          //                                               CrossAxisAlignment.start,
                          //                                           children: [
                          //                                             Text(
                          //                                               "$jamKeluar",
                          //                                               style: GoogleFonts.inter(
                          //                                                   color: Constanst.fgPrimary,
                          //                                                   fontWeight: FontWeight.w500,
                          //                                                   fontSize: 16),
                          //                                             ),
                          //                                             const SizedBox(
                          //                                                 height: 4),
                          //                                             Text(
                          //                                               regType == 0
                          //                                                   ? "Face Recognition"
                          //                                                   : "Photo",
                          //                                               style: GoogleFonts.inter(
                          //                                                   color: Constanst.fgSecondary,
                          //                                                   fontWeight: FontWeight.w400,
                          //                                                   fontSize: 10),
                          //                                             ),
                          //                                           ],
                          //                                         ),
                          //                                       )
                          //                                     ],
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                               Expanded(
                          //                                 flex: 9,
                          //                                 child: Icon(
                          //                                   Icons
                          //                                       .arrow_forward_ios_rounded,
                          //                                   size: 16,
                          //                                   color: Constanst
                          //                                       .colorNeutralFgTertiary,
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   );
                          //                 }),
                          //               ),
                          //         const Divider(),
                          //         InkWell(
                          //           onTap: () {
                          //             // print(index.statusView);
                          //             // //  index.statusView=!index.statusView;
                          //             // controller.historyAbsen
                          //             //     .forEach((element) {
                          //             //   if (element.id.toString() ==
                          //             //       index.id.toString()) {
                          //             //     element.statusView =
                          //             //         !index.statusView;
                          //             //   } else {}
                          //             // });
                          //             // controller.historyAbsen.refresh();
                          //           },
                          //           child: Container(
                          //             padding:
                          //                 const EdgeInsets.only(bottom: 12),
                          //             width:
                          //                 MediaQuery.of(context).size.width,
                          //             child: index.statusView == true
                          //                 ? Center(
                          //                     child: Container(
                          //                         child: const TextLabell(
                          //                     text: "Tutup",
                          //                     size: 14,
                          //                   )))
                          //                 : Center(
                          //                     child: Container(
                          //                         child: const TextLabell(
                          //                             text: "lainnya",
                          //                             size: 14))),
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   )
                          // : const SizedBox(
                          //     height: 8,
                          //   )
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
