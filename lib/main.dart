import 'package:flutter/material.dart';
import 'package:flutter_sqflite/model/client_model.dart';
import 'package:flutter_sqflite/db/database.dart';
import 'package:flutter_sqflite/add_editclient.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Clientes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes Sqflite"),
        actions: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              ClientDatabaseProvider.db.deleteAllClient();
              setState(() {});
            },
            child: Text('Borrar Todo',
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              color: Colors.black
            ),
            ) ,
          )
        ],
      ),
      body: 
      FutureBuilder<List<Client>>(
        future: ClientDatabaseProvider.db.getAllClients(),
        builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot){
            if (snapshot.hasData){
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Client item = snapshot.data[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (diretion){
                      ClientDatabaseProvider.db.deleteClientWithId(item.id);
                    },
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.phone),
                      leading: CircleAvatar(child: Text(item.id.toString())),
                      onTap: (){
                       Navigator.of(context).push(MaterialPageRoute(
                         builder: (context) => AddEditClient(
                           true,
                           client: item,
                         )
                       )
                       );
                      },

                    ),
                  );
                }

              );
            }else {
              return Center(child: CircularProgressIndicator());
            }

        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditClient(false)));
        },
      ),
    );
  }
}
