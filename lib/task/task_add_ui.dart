import 'package:first_app/task/tasks_api.dart';
import 'package:first_app/validacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _responsibleController = TextEditingController();
  DateTime deadline = DateTime.now();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator:(value) {
                    if(!validarString(_titleController.text)){
                          return 'Titulo invalido';
                        }
                        return null;
                  },
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _responsibleController,
                  decoration: const InputDecoration(labelText: 'Responsible'),
                ),
                Row(
                  children: [
                    const Text('Deadline: '),
                    TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(Duration(days: 365)),
                          onConfirm: (date) {
                            setState(() {
                              deadline = date;
                            });
                          },
                        );
                      },
                      child: Text(deadline?.toString() ?? 'Select Deadline'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if(isValid){
                      final task = Task(
                      id: 0,
                      titulo: _titleController.text,
                      descricao: _descriptionController.text,
                      responsaveiId: int.parse(_responsibleController.text),
                      pendente: true,
                      dataLimite: deadline,
                    );
                    taskProvider.addTask(task).then((_) {
                      Navigator.pop(context);
                      taskProvider.fetchTasks(null);
                    }).catchError((error) {
                      //TODO: deal with errors my dear friend
                    });
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}