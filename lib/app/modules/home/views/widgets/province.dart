import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../provinsi_model.dart';
import 'package:http/http.dart' as http;

class dropProvinsi extends GetView<HomeController> {
  const dropProvinsi({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Provinsi>(
        label: type == "asal" ? "Provinsi Asal" : "Provinsi Tujuan",
        showSearchBox: true,
        showClearButton: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: 'Cari provinsi..',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onFind: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");

          try {
            final response = await http.get(
              url,
              headers: {
                "key": "4d874f7b03be9890b7d5018fc1408970",
              },
            );

            var data = json.decode(response.body) as Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];

            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }

            var listAllProvinsi =
                data["rajaongkir"]["results"] as List<dynamic>;

            var models = Provinsi.fromJsonList(listAllProvinsi);
            return models;
          } catch (err) {
            print(err);
            return List<Provinsi>.empty();
          }
        },
        onChanged: (prov) {
          if (prov != null) {
            if (type == "asal") {
              controller.hiddenKotaAsal.value = false;
              controller.provAsalId.value = int.parse(prov.provinceId!);
            } else {
              controller.hiddenKotaTujuan.value = false;
              controller.provTujuanId.value = int.parse(prov.provinceId!);
            }
          } else {
            if (type == "asal") {
              controller.hiddenKotaAsal.value = true;
              controller.provAsalId.value = 0;
            } else {
              controller.hiddenKotaTujuan.value = true;
              controller.provTujuanId.value = 0;
            }
          }
          controller.showButton();
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.province}",
              style: TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => item.province!,
      ),
    );
  }
}
