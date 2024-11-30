import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
            .copyWith(secondary: Colors.redAccent),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blueGrey,
          elevation: 8, // Slight elevation for a modern look
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white, // White icon color
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _adicionarTarefa() {
    String titulo = _titleController.text.trim();
    String descricao = _descriptionController.text.trim();
    if (titulo.isNotEmpty) {
      setState(() {
        tasks.add(Task(titulo: titulo, descricao: descricao));
      });
      _titleController.clear();
      _descriptionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "$titulo" added successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Close the dialog after adding the task
    }
  }

  void _deletarTarefa(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Do you want to exclude this task?'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                tasks.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task excluded successfully'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  void _editarTarefa(int index){

    _titleController.text = tasks[index].titulo;
    _descriptionController.text = tasks[index].descricao;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit task'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Task title',
                  hintStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between fields
              TextField(
                controller: _descriptionController,
                autofocus: true,
                onSubmitted: (_) => _editTaskInfo(index),
                decoration: InputDecoration(
                  hintText: 'Task description',
                  hintStyle: TextStyle(color: Colors.teal),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel', style: TextStyle(color: Colors.teal)),
          ),
          TextButton(
            onPressed: () => _editTaskInfo(index),
            child: Text('Edit task', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }

  void _editTaskInfo(int index){

    setState(() {
      tasks[index].titulo = _titleController.text;
      tasks[index].descricao = _descriptionController.text;
    });

    _titleController.clear();
    _descriptionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task edited successfully'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _alterarStatusTarefa(int index) {
    setState(() {
      tasks[index].completa = !tasks[index].completa;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tasks[index].completa
            ? 'Task done'
            : 'Pending task'),
        duration: Duration(seconds: 2),
        backgroundColor: tasks[index].completa ? Colors.green : Colors.yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        centerTitle: true,
        elevation: 8,
        toolbarHeight: 80, // Larger height for the app bar
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text('No tasks yet!',
                  style: TextStyle(color: Colors.teal, fontSize: 18)),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    tileColor:
                        tasks[index].completa ? Colors.green[50] : Colors.white,
                    title: Text(
                      tasks[index].titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tasks[index].completa
                            ? Colors.green
                            : Colors.black87,
                        decoration: tasks[index].completa
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(tasks[index].descricao),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // To make buttons fit in trailing space
                      children: [ 
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletarTarefa(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => _editarTarefa(index),
                        ),
                      ]
                    ),
                    onTap: () => _alterarStatusTarefa(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add new task'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Task title',
                        hintStyle: TextStyle(color: Colors.teal),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Space between fields
                    TextField(
                      controller: _descriptionController,
                      autofocus: true,
                      onSubmitted: (_) => _adicionarTarefa(),
                      decoration: InputDecoration(
                        hintText: 'Task description',
                        hintStyle: TextStyle(color: Colors.teal),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.teal)),
                ),
                TextButton(
                  onPressed: _adicionarTarefa,
                  child: Text('Add task', style: TextStyle(color: Colors.teal)),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Task {
  String titulo;
  String descricao;
  bool completa;

  Task({required this.titulo, required this.descricao, this.completa = false});
}
