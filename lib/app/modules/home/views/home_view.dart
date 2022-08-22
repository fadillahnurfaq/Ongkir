import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/views/widgets/berat.dart';
import './widgets/city.dart';
import './widgets/province.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongkos Kirim indonesia'),
        centerTitle: true,
        backgroundColor: Colors.red[900],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            dropProvinsi(type: "asal"),
            Obx(
              () => dropKota(
                provId: controller.provAsalId.value,
                type: "asal",
              ),
            ),
            dropProvinsi(type: "tujuan"),
            Obx(
              () => dropKota(
                  provId: controller.provTujuanId.value, type: "tujuan"),
            ),
            BeratBarang(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: DropdownSearch<Map<String, dynamic>>(
                mode: Mode.MENU,
                showClearButton: true,
                items: [
                  {
                    "code": "jne",
                    "name": "Jalur Nugraha Ekakurir(JNE)",
                  },
                  {
                    "code": "tiki",
                    "name": "Titipan Kilat (TIKI)",
                  },
                  {
                    "code": "pos",
                    "name": "Perusahaan Opsional Surat (POS)",
                  }
                ],
                label: "Pilih Kurir",
                onChanged: (kurir) {
                  if (kurir != null) {
                    controller.kurir.value = kurir["code"];
                    controller.showButton();
                  } else {
                    controller.hiddenButton.value = true;
                    controller.kurir.value = "";
                  }
                },
                itemAsString: (item) => "${item['name']}",
                popupItemBuilder: (context, item, isSelected) => Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "${item['name']}",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () => controller.ongkosKirim(),
                child: Text("CEK ONGKOS KIRIM"),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    primary: Colors.red[900]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
