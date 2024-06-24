import 'package:first_app/Responsible/Responsible_edit_ui.dart';
import 'package:first_app/responsible/responsible_api.dart';
import 'package:first_app/responsible/responsible_page.dart';
import 'package:first_app/responsible/responsible_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:first_app/task/tasks_api.dart';
import 'package:first_app/task/task_edit_ui.dart';
import 'task/task_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
       ChangeNotifierProvider(create: (context) => ResponsibleProvider()),
      ],child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 81, 6, 209)),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/':(context) => HomePage(),
            '/task':(context) => TaskPage(),
            '/taskedit':(context) => EditTaskPage(),
            '/responsible':(context) => ResponsiblePage(),
            '/responsibleedit':(context) => EditResponsiblePage(),
            '/responsibletasks':(context) => ResponsibleTasks(),
          },
        )
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  final String title = 'Home Page';
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(onPressed: (){
                            Navigator.pushNamed(context, '/task');
                          },
                           child: Center(child: Text('Task Page'),
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){Navigator.pushNamed(context, '/responsible');}, 
                            child: Center(child: Text('Responsible Page'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

  
