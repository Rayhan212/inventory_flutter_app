import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory_app/services/auth_services.dart';

import '../models/response_crud.dart';

class ItemServices {
  Future<List<Barang>> getListBarang() async {
    final uri = Uri.http(host, "server_inventory/index.php/api/getBarang");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      ResponseCrud responseBarang = ResponseCrud.fromJson(decode);
      List<Barang> listBarang = responseBarang.barang ?? [];
      return listBarang;
    } else {
      throw Exception("Failed to Load Barang");
    }
  }

  Future<ResponseCrud?> insertBarang(
      String name, String amount, String urlImage) async {
    final uri = Uri.http(host, "server_inventory/index.php/api/insertBarang");
    final response = await http
        .post(uri, body: {'nama': name, 'jumlah': amount, 'gambar': urlImage});

    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      ResponseCrud responseCrud = ResponseCrud.fromJson(decode);
      return responseCrud;
    } else {
      throw Exception("Failed to insert Barang");
    }
  }

  Future<ResponseCrud?> deleteBarang(String id) async {
    final uri = Uri.http(host, "server_inventory/index.php/api/deleteBarang");
    final response = await http
        .post(uri, body: {'id' : id});

    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      ResponseCrud responseCrud = ResponseCrud.fromJson(decode);
      return responseCrud;
    } else {
      throw Exception("Failed to delete Barang");
    }
  }
  Future<ResponseCrud?> updateBarang(String id, String name, String amount, String urlImage) async {
    final uri = Uri.http(host, "server_inventory/index.php/api/updateBarang");
    final response = await http
        .post(uri, body: {'id' : id, 'nama': name, 'jumlah': amount, 'gambar': urlImage});

    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      ResponseCrud responseCrud = ResponseCrud.fromJson(decode);
      return responseCrud;
    } else {
      throw Exception("Failed to update Barang");
    }
  }
}

