
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:siscom_operasional/controller/surat_peringatan_controller.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/constans.dart';
import 'package:siscom_operasional/utils/widget/text_labe.dart';

class SuratPeringatan extends StatefulWidget {
  @override
  _SuratPeringatanState createState() => _SuratPeringatanState();
}

class _SuratPeringatanState extends State<SuratPeringatan> {
  final SuratPeringatanController controller =
      Get.put(SuratPeringatanController());
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    controller.getPeringatan();
    controller.getJumlahNotifikasi();
  }

  void _onRefresh() async {
    controller.getPeringatan();
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
        title: Text('Surat Peringatan Pegawai'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                "${controller.peringatanlist.value.length} surat peringatan",
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
                    itemCount: controller.peringatanlist.length,
                    itemBuilder: (context, index) {
                      var list = controller.peringatanlist[index];
                      return ListTile(
                        tileColor: list.isView == 0 ? Constanst.colorButton2 : Colors.transparent,
                        leading: Icon(
                          Iconsax.sms_notification,
                          color: Colors.red,
                        ),
                        title: Text(list.sp),
                        trailing: Icon(Icons.arrow_forward_ios),
                        subtitle: Text(formatDate(list.approve_date)),
                        onTap: () {
                          if (list.isView == 0) {
                            controller.updateDataNotif(list.id);
                            controller.getPeringatan();
                          }
                          controller.getDetail(list.id);
                          // UtilsAlert.showToast(list.id);
                          Get.to(() => SuratPeringatanDetail(
                                warningTitle: list.title.toString(),
                                nomor: list.nomor.toString(),
                                sp: list.sp.toString(),
                                alasan: list.alasan.toString(),
                                posisi: list.posisi.toString(),
                                nama: list.nama.toString(),
                                approve_date: list.approve_date.toString(),
                                approve_by: list.approve_by ?? '',
                                eff_date: list.eff_date.toString(),
                                file_esign: list.file_esign.toString(),
                                bab: list.bab.toString(),
                                pasal: list.pasal.toString(),
                                nomorPasal: list.nomorPasal.toString(),
                              ));
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

class SuratPeringatanDetail extends StatelessWidget {
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

  SuratPeringatanDetail(
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
    print("${Api.fileDoc}$file_esign");
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
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return controller.isLoading.value == true
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Nomor: $nomor',
                      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
                      Center(
                        child: Text(
                          'SURAT PERINGATAN DAN PEMBERIAN\n     TINDAKAN ATAS PELANGGARAN',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Text(
                      //   '$sp ditujukan kepada:',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      Text(
                        'Karyawan PT. Sinar Arta Mulia yang namanya\ntertera di bawah ini :',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Nama : $nama'),
                      Text('Posisi : $posisi'),
                      SizedBox(height: 20),
                      Text(
                        'Ditemukan telah melakukan hal - hal di bawah\nini:',
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: List.generate(controller.listAlasan.length,
                            (index) {
                          var data = controller.listAlasan[index];
                          return Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  (index + 1).toString(),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              Expanded(
                                flex: 99,
                                child: Text(
                                  '${data['name']}',
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // Text(
                      //   'Dengan hormat,\n\nBerdasarkan peraturan yang berlaku di perusahaan, pelanggaran tersebut merupakan pelanggaran kategori $alasan dan dikenakan tindakan peringatan tertulis.\n\nDengan surat ini, kami memberikan $sp kepada saudara/i $nama, agar tidak mengulangi pelanggaran tersebut. Jika pelanggaran serupa terulang kembali, maka tindakan yang lebih tegas akan diambil sesuai dengan ketentuan yang berlaku.\n\nDemikian surat peringatan ini dibuat untuk dapat dipergunakan sebagaimana mestinya.\n\nHormat kami,\nNama Perusahaan - ${AppData.selectedPerusahan}\nNama Atasan/HRD - $approve_by',
                      //   textAlign: TextAlign.justify,
                      // ),
                      Text(
                        'Yang bertentangan dengan Buku Peraturan\nperusahaan Bab ${bab} pasal ${pasal} nomor ${nomorPasal} mengenai tindakan-tindakan\nyang Dianggap Sebagai Pelanggaran\n$sp',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Pelanggaran di anggap telah memenuhi kriteria\nsehingga atas pelanggaran yang telah\ndilakukan, Perusahaan memberikan tindakan\nberupa:',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        '1. Pemberian ${sp}',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      alasan.toString().isEmpty || alasan.toString() == 'null'
                          ? sp.contains("Surat Peringatan 3")
                              ? Text(
                                  '2. Pemberhentiaan Secara Tidak Hormat dan Pemutusan Hubungan Kerja',
                                  textAlign: TextAlign.start,
                                )
                              : SizedBox()
                          : Text(
                              '2.${alasan}',
                              textAlign: TextAlign.start,
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      sp.contains("Surat Peringatan 3")
                          ? Text(
                              '3. Pemberhentiaan Secara Tidak Hormat dan Pemutusan Hubungan Kerja',
                              textAlign: TextAlign.start,
                            )
                          : SizedBox(),

                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Demiian surat ini dibuat untuk disetujui berdasarkan peraturan perusahaan yang berlaku yang telah di sepakati.',
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Jakarta, ${DateFormat('dd MMMM yyyy').format(DateTime.parse(eff_date.toString()))}',
                        textAlign: TextAlign.start,
                      ),
                      Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column( crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(
                                "Validasi tanpa tanda tangan",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red,
                                    fontSize: 11),
                              ),
                              SizedBox(
                                height: 35,
                              ),
                              TextLabell(
                                text: "PT SINAR ARTA MULIA",
                                weight: FontWeight.bold,
                                size: 14,
                              ),
                              TextLabell(
                                text:
                                    "Tanggal Validasi : ${DateFormat('dd MMMM yyyy').format(DateTime.parse(eff_date.toString()))}",
                                size: 9.0,
                              ),
                            ],
                          ),
                          Column(
                        children: [
                          Image.network(
                            "${Api.fileDoc}$file_esign",
                            width: 80,
                            height: 80,
                            fit: BoxFit.fill,
                          ),
                          Text(
                            'Yang Bersangkutan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0
                              ),
                            
                          ),
                          SizedBox(height: 4),
                          Text('$nama'),
                        ],
                      ),
                        ],
                      ),
                      
                    ],
                  );
          })),
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }
}
