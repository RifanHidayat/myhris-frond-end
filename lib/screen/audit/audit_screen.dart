import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siscom_operasional/controller/audit_controller.dart';
import 'package:siscom_operasional/utils/constans.dart';

class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key});

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  final controller = Get.put(AuditController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constanst.colorWhite,
        elevation: 0,
        leadingWidth: 50,
        titleSpacing: 0,
        centerTitle: true,
        title: const Text("Adit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return listAjuanAudit();
        }),
      ),
    );
  }

  Widget listAjuanAudit() {
    return ListView.builder(
        physics: controller.auditList.length <= 8
            ? const AlwaysScrollableScrollPhysics()
            : const BouncingScrollPhysics(),
        itemCount: controller.auditList[0].length,
        itemBuilder: (context, index) {
          var audit = controller.auditList[0][index];
          var full_name = audit['full_name'];
          var nomor_ajuan = audit['nomor'];
          var branch = audit['branch_id'];
          var jabatan = audit['jabatan'];
          var formStatus = audit['form_status'];
          var tipeForm = audit['tipe_form'];
          var status = audit['status'];
          var tipePengajuan = audit['tipe_pengajuan'];
          return Column(
            children: [
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Constanst.colorNonAktif)),
                child: InkWell(
                  customBorder: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$full_name - $jabatan",
                            style: GoogleFonts.inter(
                                color: Constanst.fgPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text("$tipeForm",
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Text('$nomor_ajuan',
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 12),
                        Divider(
                            height: 0, thickness: 1, color: Constanst.border),
                        const SizedBox(height: 8),
                        Text('$status',
                            style: GoogleFonts.inter(
                                color: Constanst.fgSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
