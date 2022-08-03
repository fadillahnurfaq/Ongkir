import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../city_model.dart';
import 'package:http/http.dart' as http;

class dropKota extends GetView<HomeController> {
  const dropKota({
    Key? key,
    required this.provId,
    required this.type,
  }) : super(key: key);

  final int provId;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        label: type == "asal"
            ? "Kota / Kabupaten Asal"
            : "Kota / Kabupaten Tujuan",
        showSearchBox: true,
        showClearButton: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: 'Cari Kota / Kabupaten..',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onFind: (String filter) async {
          Uri url = Uri.parse(
              "https://api.rajaongkir.com/starter/city?province=$provId");

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

            var listAllCity = data["rajaongkir"]["results"] as List<dynamic>;

            var models = City.fromJsonList(listAllCity);
            return models;
          } catch (err) {
            print(err);
            return List<City>.empty();
          }
        },
        onChanged: (cityValue) {
          if (cityValue != null) {
            if (type == "asal") {
              controller.kotaAsalId.value = int.parse(cityValue.cityId!);
            } else {
              controller.kotaTujuanId.value = int.parse(cityValue.cityId!);
            }
          } else {
            if (type == "asal") {
              print("Tidak memilih Kota / Kabupaten asal apapun");
              controller.kotaAsalId.value = 0;
            } else {
              print("Tidak memilih Kota / Kabupaten tujuan apapun");
              controller.kotaTujuanId.value = 0;
            }
          }
          controller.showButton();
        },
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.type} ${item.cityName}",
              style: TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => "${item.type} ${item.cityName}",
      ),
    );
  }
}
