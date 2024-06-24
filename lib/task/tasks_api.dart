import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Task {
  int id;
  final String titulo;
  final String descricao;
  final int responsaveiId;
  final bool pendente;
  final DateTime dataLimite;

  Task({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.responsaveiId,
    required this.pendente,
    required this.dataLimite,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        titulo: json['titulo'],
        descricao: json['descricao'],
        responsaveiId: json['responsaveiId'],
        pendente: json['pendente'],
        dataLimite: DateTime.parse(json['data_limite']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descricao': descricao,
        'responsaveiId': responsaveiId,
        'pendente': pendente,
        'data_limite': dataLimite.toIso8601String(),
      };
  Map<String, dynamic> toJsonForAdd() => {
        'titulo': titulo,
        'descricao': descricao,
        'responsaveiId': responsaveiId,
        'status': pendente,
        'data_limite': dataLimite.toIso8601String(),
      };
}

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];
  Future<void> fetchTasks(int? responsaveiId) async {
    String url;
    if(responsaveiId == null){
      url = 'http://127.0.0.1:3000/tarefas/';
    }
    else{
      url = 'http://127.0.0.1:3000/tarefas/?responsaveiId=$responsaveiId';
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = json.decode(response.body);
      final List<dynamic> taskData = data['tarefas'];
      tasks = taskData.map((item) => Task.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(Task task) async {
    print(task.dataLimite);
    const url = 'http://127.0.0.1:3000/tarefas';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJsonForAdd()),
    );
    if (response.statusCode != 201) {
      print ('Response status code: ${response.statusCode}');
      print ('Response body: ${response.body}');
      throw Exception('Failed to add task');
    } else {
      tasks.add(task);
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = 'http://127.0.0.1:3000/tarefas/$taskId';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    } else {
      tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    }
  }

  Future<void> editTask(int taskId, Task updatedTask) async {
    print(taskId);
    print(updatedTask);
    final url = 'http://127.0.0.1:3000/tarefas/$taskId';
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