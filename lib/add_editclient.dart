import 'package:flutter/material.dart';
import 'package:flutter_sqflite/model/client_model.dart';
import 'package:flutter_sqflite/db/database.dart';

class AddEditClient extends StatefulWidget {
  final bool edit;
  final Client client;

  AddEditClient(this.edit, {this.client})
      : assert(edit == true || client == null);

  @override
  _AddEditCLientState createState() => _AddEditCLientState();
}

class _AddEditCLientState extends State<AddEditClient> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      nameEditingController.text = widget.client.name;
      phoneEditingController.text = widget.client.phone;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.edit ? "Editar cliente" : "Agregar cliente"),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(
                  size: 300,
                ),
                textFormField(nameEditingController, "Nombre","Ingresar Nombre", 
                Icons.person, widget.edit ? widget.client.name : "name"),
                textFormField(phoneEditingController, "Telefono","Ingresar Telefono", 
                Icons.phone, widget.edit ? widget.client.name : "phone"),
                RaisedButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Guardar',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.white
                  ),
                  
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState.validate()){
                      Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Procesando Datos'))
                      );
                    } else if (widget.edit == true) {
                      ClientDatabaseProvider.db.updateClient(new Client(
                        name: nameEditingController.text,
                        phone: phoneEditingController.text,
                        id: widget.client.id));
                        Navigator.pop(context);
                    }else{
                      await ClientDatabaseProvider.db.addClientToDatabase(new Client(
                        name: nameEditingController.text,
                        phone: phoneEditingController.text,
                        
                      ));
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  textFormField(TextEditingController t, String label, String hint, IconData iconData, String initialValue){
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
  child: TextFormField(
  validator: (value){
    if(value.isEmpty){
      return 'Por favor ingrese el texto';
    }
  },
  controller: t,
  textCapitalization: TextCapitalization.words,
  decoration: InputDecoration(
    prefixIcon: Icon(iconData),
    hintText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
  ),
)
    );
  }

}
