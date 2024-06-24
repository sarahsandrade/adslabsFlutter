import 'package:first_app/responsible/responsible_api.dart';
import 'package:first_app/validacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';

class EditResponsiblePage extends StatefulWidget {
  const EditResponsiblePage({super.key});

  @override
  State<EditResponsiblePage> createState() => _EditResponsiblePageState();
  
}

class _EditResponsiblePageState extends State<EditResponsiblePage> {
  late TextEditingController _nameController;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final responsible = ModalRoute.of(context)!.settings.arguments as Responsible;
    _nameController  = TextEditingController(text:responsible.nome);
    final responsibleProvider = Provider.of<ResponsibleProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Responsible'),
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
                  decoration: InputDecoration(
                    labelText: 'Name',
                    ),
                    validator:(value) {
                      if(!validarString(_nameController.text)){
                        return 'Nome invalido';
                      }
                      return null;
                    },
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if(isValid){
                      final responsibleup = Responsible(
                      id: responsible.id,
                      nome: _nameController.text,
                      dataNascimento: responsible.dataNascimento,
                    );
                     responsibleProvider.editResponsible(responsible.id,responsibleup).then((_) {
                       Navigator.pop(context);
                       responsibleProvider.fetchResponsibles();
                     }).catchError((error) {
                      print(error);
                       //TODO: deal with errors my dear friend
                     });
                    }
                    
                  },
                  child: const Text('Edit Responsible'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}