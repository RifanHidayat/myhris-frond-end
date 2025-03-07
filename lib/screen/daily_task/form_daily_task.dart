import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/daily_task_controller.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';
import 'package:siscom_operasional/utils/widget_utils.dart';

class FormDailyTask extends StatefulWidget {
  const FormDailyTask({super.key});

  @override
  State<FormDailyTask> createState() => _FormDailyTaskState();
}

class _FormDailyTaskState extends State<FormDailyTask> {
  final controller = Get.put(DailyTaskController());
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
            "Form Daily Task",
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
                              formHariDanTanggal(),
                              // formCatatan()
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
                controller.kirimDailyTask();
                print('ini data per index ${controller.listTask}');
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
          controller.tanggalTask.value.text =
              Constanst.convertDate("$dateSelect");
          this.controller.tanggalTask.refresh();

          // DateTime now = DateTime.now();
          // if (now.month == dateSelect.month) {
          //   controller.initialDate.value = dateSelect;
          //   controller.tanggalTask.value.text =
          //       Constanst.convertDate("$dateSelect");
          //   this.controller.tanggalTask.refresh();
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
                          controller.tanggalTask.value.text,
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
          // Padding(
          //   padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          //   child: Divider(
          //     height: 0,
          //     thickness: 1,
          //     color: Constanst.fgBorder,
          //   ),
          // ),
        ],
      ),
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
                      text: "Judul Task *",
                      color: Constanst.fgPrimary,
                      size: 14,
                      weight: FontWeight.w400,
                    ),
                    TextFormField(
                      controller: controller.catatan.value,
                      decoration: const InputDecoration(
                        hintText: 'Tulis disini',
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
                                      TextEditingController(text: data['judul']),
                                  decoration: const InputDecoration(
                                    hintText: 'Judul di sini',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    data['judul'] = value;
                                  },
                                  style: GoogleFonts.inter(
                                      color: Constanst.fgPrimary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Constanst.fgBorder,
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
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Constanst.fgBorder,
                                ),
                                DropdownButtonFormField<String>(
                                  value: data['dropdown']== '' ? null : data['dropdown'],
                                  items: ['Finished', 'Ongoing']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    data['dropdown'] = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'pilih status',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) => value == null ? 'pilih status' : null,
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (controller.listTask.length == 1) {
                                UtilsAlert.showToast(
                                    "Pastikan anda mengisi minimal 1 tugas");
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
    controller.listTask.add({"task": "", "judul": "", "dropdown": ""});
  }
}
