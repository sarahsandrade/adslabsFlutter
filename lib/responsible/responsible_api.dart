import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Responsible {
  int id;
  final String nome;
  final DateTime dataNascimento;


  Responsible ({
  required this.id,
  required this.nome,
  required this.dataNascimento,
});

  factory Responsible.fromJson(Map<String, dynamic> json) => Responsible(
        id: json['id'],
        nome: json['nome'],
        dataNascimento: DateTime.parse(json['data_nascimento']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'data_nascimento': dataNascimento.toIso8601String(),
      };
  Map<String, dynamic> toJsonForAdd() => {
        'id': id,
        'nome': nome,
        'data_nascimento': dataNascimento.toIso8601String(),
      };
}
class ResponsibleProvider extends ChangeNotifier {
  List<Responsible> responsibles = [];
  Future<void> fetchResponsibles() async {
    const url = 'http://127.0.0.1:3000/responsavel/list';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> responsiblesData = data['responsaveis'];
      responsibles = responsiblesData.map((item) => Responsible.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load responsibles');
    }
  }

  Future<void> addResponsible(Responsible responsible) async {
    print(responsible.dataNascimento);
    const url = 'http://127.0.0.1:3000/responsavel';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(responsible.toJsonForAdd()),
    );
    if (response.statusCode != 201) {
      print ('Response status code: ${response.statusCode}');
      print ('Response body: ${response.body}');
      throw Exception('Failed to add responsible');
    } else {
      responsibles.add(responsible);
      notifyListeners();
    }
  }

  Future<void> deleteResponsible(int responsibleId) async {
    final url = 'http://127.0.0.1:3000/responsavel/$responsibleId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete responsible');
    } else {
      responsibles.removeWhere((responsible) => responsible.id == responsibleId);
      notifyListeners();
    }
  }

  Future<void> editResponsible(int responsibleId, Responsible updatedResponsible) async {
    final url = 'http://127.0.0.1:3000/responsavel/$responsibleId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedResponsible.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit responsible');
    } else {
      final index = responsibles.indexWhere((responsible) => responsible.id == responsibleId);
      responsibles[index] = updatedResponsible;
      notifyListeners();
    }
  }
}


