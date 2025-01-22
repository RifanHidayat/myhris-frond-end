
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_operasional/controller/surat_peringatan_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class TeguranLisan extends StatefulWidget {
  @override
  _TeguranLisanState createState() => _TeguranLisanState();
}

class _TeguranLisanState extends State<TeguranLisan> {
  final SuratPeringatanController controller =
      Get.put(SuratPeringatanController());
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    controller.getTeguran();
    controller.getJumlahNotifikasi();
  }

  void _onRefresh() async {
    controller.getTeguran();
    controller.getJumlahNotifikasi();
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    print('ini surat peringatan lenght : ${controller.peringatanlist.value.length}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Surat Teguran Lisan'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                "${controller.teguranList.value.length} surat teguran",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => SmartRefresher(
                  controller: refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                    itemCount: controller.teguranList.length,
                    itemBuilder: (context, index) {
                      var list = controller.teguranList[index];
                      return ListTile(
                        tileColor: list.isView == 0 ? Constanst.colorButton2 : Colors.transparent,
                        leading: Icon(
                          Iconsax.sms_notification,
                          color: Colors.red,
                        ),
                        title: Text(list.sp),
                        trailing: Icon(Icons.arrow_forward_ios),
                        // subtitle: Text(formatDate(list.approve_date)),
                        onTap: () {
                          if (list.isView == 0) {
                            controller.updateDataNotif(list.id);
                            controller.getPeringatan();
                          }
                          controller.getDetailTeguran(list.id);
                          // UtilsAlert.showToast(list.id);
                          // Get.to(() => SuratTeguranDetail(
                          //       warningTitle: list.title.toString(),
                          //       nomor: list.nomor.toString(),
                          //       sp: list.sp.toString(),
                          //       alasan: list.alasan.toString(),
                          //       posisi: list.posisi.toString(),
                          //       nama: list.nama.toString(),
                          //       approve_date: list.approve_date.toString(),
                          //       approve_by: list.approve_by ?? '',
                          //       eff_date: list.eff_date.toString(),
                          //       file_esign: list.file_esign.toString(),
                          //       bab: list.bab.toString(),
                          //       pasal: list.pasal.toString(),
                          //       nomorPasal: list.nomorPasal.toString(),
                          //     ));
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }
}

class SuratTeguranDetail extends StatelessWidget {
  final String warningTitle;
  final String nomor;
  final String sp;
  final String alasan;
  final String posisi;
  final String nama;
  final String file_esign;
  final String approve_date;
  final String eff_date;
  final String approve_by;
  var pasal, bab, nomorPasal;

  SuratTeguranDetail(
      {required this.warningTitle,
      required this.nomor,
      required this.sp,
      required this.alasan,
      required this.posisi,
      required this.nama,
      required this.file_esign,
      required this.approve_date,
      required this.approve_by,
      required this.eff_date,
      this.bab,
      this.pasal,
      this.nomorPasal});
  final SuratPeringatanController controller =
      Get.put(SuratPeringatanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Detail Surat Peringatan'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(children: [
          HtmlWidget(
            """
                <p style='font-size: 16px; text-align: center;'>
                  ${nama}
                  </p>
                  """,
          ),
        ]),
      ),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }
}
