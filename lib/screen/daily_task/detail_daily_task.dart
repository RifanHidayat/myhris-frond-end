import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/controller/daily_task_controller.dart';
import 'package:siscom_operasional/screen/daily_task/form_daily_task.dart';
import 'package:siscom_operasional/utils/constans.dart';

class DetailDailyTask extends StatefulWidget {
  final int? id;

  const DetailDailyTask(this.id, {super.key});

  @override
  State<DetailDailyTask> createState() => _DetailDailyTaskState();
}

class _DetailDailyTaskState extends State<DetailDailyTask> {
  final controller = Get.find<DailyTaskController>();
  @override
  void initState() {
    super.initState();
    controller.loadTask(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Your Task')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(FormDailyTask());
        },
        child: Icon(Icons.add),
      ),
      body: widget.id == null || widget.id == 0
          ? Center(child: Text('hari ini gak ada task, yuk kita bikin'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: descMasuk(),
            ),
    );
  }

  Widget descMasuk() {
    return Obx(() {
      return controller.task.isEmpty
          ? const Center(child: Text('Tunggu Sebentar ya'))
          : ListView.builder(
              itemCount: controller.task[0].length,
              itemBuilder: (context, index) {
                final data = controller.task[0][index];
                print('ini status ${data['status']}');
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Constanst.border)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data['judul'],
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                data['status'] == '1' ? 'Finished' : 'Ongoing',
                                style: GoogleFonts.inter(
                                    color: Constanst.fgPrimary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                          Text(
                            data['rincian'],
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
    });
  }
}
