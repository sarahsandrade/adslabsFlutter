import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:first_app/consts.dart';

class Task {
  int id;
  final String titulo;
  final String descricao;
  final int responsavel;
  final bool pendente;
  final DateTime dataLimite;

  Task({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.responsavel,
    required this.pendente,
    required this.dataLimite,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        titulo: json['titulo'],
        descricao: json['descricao'],
        responsavel: json['responsaveiId'],
        pendente: json['pendente'],
        dataLimite: DateTime.parse(json['data_limite']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'responsaveiId': responsavel,
        'pendente': pendente,
        'data_limite': dataLimite.toIso8601String(),
      };
  Map<String, dynamic> toJsonForAdd() => {
        'titulo': titulo,
        'descricao': descricao,
        'responsavel': responsavel,
        'status': pendente,
        'data_limite': dataLimite.toIso8601String(),
      };
}

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];
  Future<void> fetchTasks() async {
    const url = 'http://127.0.0.1:3000/tarefas/';
    print("aaa");
    final response = await http.get(Uri.parse(url));
    print("aaa");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> taskData = data['tarefas'];
      tasks = taskData.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks');
    }
    print("aaa");
  }

  Future<void> addTask(Task task) async {
    const url = 'http://192.168.175.100:3000/tarefas';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJsonForAdd()),
    );
    if (response.statusCode != 200) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to add task');
    } else {
      tasks.add(task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = 'http://192.168.175.100:3000/tarefas/$taskId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    } else {
      tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    }
  }

  Future<void> editTask(int taskId, Task updatedTask) async {
    final url = 'http://192.168.175.100:3000/tarefas/$taskId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedTask.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    } else {
      final index = tasks.indexWhere((task) => task.id == taskId);
      tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}