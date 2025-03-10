import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:siscom_operasional/utils/api.dart';
import 'package:siscom_operasional/utils/app_data.dart';
import 'package:siscom_operasional/utils/appbar_widget.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siscom_operasional/utils/constans.dart';

class FaceRecognitionPhotoPage extends StatelessWidget {
  const FaceRecognitionPhotoPage({super.key});

  final double mirror = math.pi;

  @override
  Widget build(BuildContext context) {
    _deleteImageFromCache();
    return Scaffold(
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
            leadingWidth: 50,
            titleSpacing: 0,
            centerTitle: false,
            title: Text(
              "Foto Data Wajah",
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
              onPressed: Get.back,
              // onPressed: () {
              //   controller.cari.value.text = "";
              //   Get.back();
              // },
            ),
          ),
        ),
      ),
      body: InkWell(
        onTap: () {
          print(AppData.selectedDatabase);
          print(
              "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}");
        },
        child: Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror),
            child: CachedNetworkImage(
              imageUrl:
                  "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.white,
                child: SvgPicture.asset(
                  'assets/avatar_default.svg',
                  width: 40,
                  height: 40,
                ),
              ),
              fit: BoxFit.cover,
            ),
          ),
          // child: Image.network(
          //   "${Api.urlFileRecog}${GetStorage().read('file_face')}",
          //   loadingBuilder: (BuildContext context, Widget child,
          //       ImageChunkEvent? loadingProgress) {
          //     print("load data");
          //     if (loadingProgress == null) return child;
          //     return Center(
          //       child: CircularProgressIndicator(
          //         value: loadingProgress.expectedTotalBytes != null
          //             ? loadingProgress.cumulativeBytesLoaded /
          //                 loadingProgress.expectedTotalBytes!
          //             : null,
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }

  Future _deleteImageFromCache() async {
    String url =
        "${Api.urlImage}/${AppData.selectedDatabase}/face_recog/${GetStorage().read('file_face')}";
    await CachedNetworkImage.evictFromCache(url);
  }
}
