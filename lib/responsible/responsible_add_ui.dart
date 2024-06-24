import 'package:first_app/responsible/responsible_api.dart';
import 'package:first_app/validacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';


class AddResponsiblePage extends StatefulWidget {
  const AddResponsiblePage({super.key});

  @override
  State<AddResponsiblePage> createState() => _AddResponsiblePageState();
}

class _AddResponsiblePageState extends State<AddResponsiblePage> {
  final TextEditingController _nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime dataNas = DateTime.parse('2014-12-31');

  @override
  Widget build(BuildContext context) {
    final responsibleProvider = Provider.of<ResponsibleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Responsible'),
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
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator:(value) {
                        if(!validarString(_nameController.text)){
                          return 'Nome invalido';
                        }
                        return null;
                      },
                ),
                Row(
                  children: [
                    const Text('Data de nascimento: '),
                    TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.parse('1950-01-01'),
                          maxTime: DateTime.parse('2014-12-31'),
                          onConfirm: (date) {
                            setState(() {
                              dataNas = date;
                            });
                          },
                        );
                      },
                      child: Text(dataNas?.toString() ?? 'Select Deadline'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if(isValid){
                      final responsible = Responsible(
                      id: 0,
                      nome: _nameController.text,
                      dataNascimento: dataNas,
                    );
                    responsibleProvider.addResponsible(responsible).then((_) {
                      Navigator.pop(context);
                      responsibleProvider.fetchResponsibles();
                    }).catchError((error) {
                      //TODO: deal with errors my dear friend
                    });
                    }
                  },
                  child: const Text('Add Responsible'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}