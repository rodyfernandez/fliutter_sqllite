import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqflite/model/client_model.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';

class ClientDatabaseProvider {
  ClientDatabaseProvider._();

  static final ClientDatabaseProvider db = ClientDatabaseProvider._();
  Database _database;

  //para evitar que abra varias conexiones una y otra vez podemos usar algo como esto...
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "client.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id integer primary key,"
          "name TEXT,"
          "phone TEXT"
          ")");
    });
  }

//Query
//muestra todos los clientes de la base de datos
  Future<List<Client>> getAllClients() async {
    final db = await database;
    var response = await db.query("Client");
    List<Client> list = response.map((c) => Client.fromMap(c)).toList();
    return list;
  }

  //Query
//muestra un solo cliente de la base de datos
  Future<Client> getClientWithId(int id) async {
    final db = await database;
    var response = await db.query("Client", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Client.fromMap(response.first) : null;
  }

  //Insert
  addClientToDatabase(Client client) async {
    try {
      final db = await database;
      var table = await db.rawQuery("SELECT MAX(1)+1 as id From Client");
      int id = table.first["id"];
      client.id = id;
      var raw = await db.insert(
        "Client",
        client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return raw;
    } catch (e) {
      print(e);
    }
  }

  //Delete
  //Delete client with id

  deleteClientWithId(int id) async {
    final db = await database;
    return db.delete("Client", where: "id=?", whereArgs: [id]);
  }

  //Delete All clients

  deleteAllClient() async {
    final db = await database;
    return db.delete("Client");
  }

  //Update
  updateClient(Client client) async {
    final db = await database;
    var response = await db.update("Client", client.toMap(),
        where: "id = ?", whereArgs: [client.id]);
    return response;
  }
}
