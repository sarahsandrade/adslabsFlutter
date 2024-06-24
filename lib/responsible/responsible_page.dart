//import 'package:first_app/responsible/responsible_add_ui.dart';
import 'package:first_app/Responsible/Responsible_add_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:first_app/responsible/responsible_api.dart';
//import 'package:first_app/responsible/responsible_edit_ui.dart';
import 'package:intl/intl.dart';

class ResponsiblePage extends StatefulWidget {
  const ResponsiblePage({super.key});

  @override
  State<ResponsiblePage> createState() => _ResponsiblePageState();
}

class _ResponsiblePageState extends State<ResponsiblePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ResponsibleProvider>(context, listen: false).fetchResponsibles();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Responsaveis'),
          ),
          body: Consumer<ResponsibleProvider>(builder: (context,ResponsibleProvider,child)=>
          ResponsibleProvider.responsibles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: ResponsibleProvider.responsibles.length,
                  itemBuilder: (context, index) {
                    final responsible = ResponsibleProvider.responsibles[index];
                    return ListTile(
                      title: Text(
                        responsible.nome,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text('${Responsible.status} - ${Responsible.priority}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.fingerprint),
                              const SizedBox(width: 5),
                              Text('Id: ${responsible.id}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(width: 5),
                              Text(
                                  'Data de Nascimento: ${DateFormat('yyyy-MM-dd').format(responsible.dataNascimento)}'),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.list_alt),
                            onPressed: () => { 
                              Navigator.pushNamed(context, '/responsibletasks',arguments: responsible)},
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => { 
                              Navigator.pushNamed(context, '/responsibleedit',arguments: responsible)},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => ResponsibleProvider.deleteResponsible(responsible.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),), 
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => navigateToAddResponsible(context),
          ),
        );
  }

  void navigateToAddResponsible(BuildContext context) {
     Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => const AddResponsiblePage()),
     );
  }

  navigateToEditResponsible(BuildContext context, int id) {
    Navigator.pushNamed(context, '/responsibleedit',arguments: id);
  }
}


  