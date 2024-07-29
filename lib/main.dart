import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//librerias para ranking y importar imagenes de dispositivos
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Mi Museo',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF54787d)), //despues de la FF
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Museo> favoriteMuseo = [];

  void museoAdd(Museo museo){
    favoriteMuseo.add(museo);
    notifyListeners();
  }
}

class Museo {
  //Se crear el tipo Museo para usar en "class MyAppState" y su contenido
  final String nombre;
  final String review;
  final double calificacion;
  final String imagePath;
  //Se reserva los contenidos
  Museo(this.nombre, this.review, this.calificacion, this.imagePath);
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Se crea una barra de opciones
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Mi museo"),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Ubicación")),
            FavoritesPage(), //Pagina de favoritos
            Center(child: Text("perfil")),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.location_on_outlined)),
            Tab(icon: Icon(Icons.bookmark_border_outlined)),
            Tab(icon: Icon(Icons.person_outline_outlined)),
          ],
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Color(0xFF615145), //Color de los iconos
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(
              context: context,
              builder: (context) => AddMuseoDialog(),
            );
          },
          child: Icon(Icons.add_circle_outline_rounded),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, state, child){
        return ListView.builder(
          itemCount: state.favoriteMuseo.length,
          itemBuilder: (context, index) {
            final museo = state.favoriteMuseo[index];
            return ListTile(
              leading: museo.imagePath != null
                ? Image.file(File(museo.imagePath))
                : null,
              title: Text(museo.nombre),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(museo.review),
                  RatingBarIndicator(
                    rating: museo.calificacion,
                    itemBuilder: (context, index) => Icon(
                      Icons.star_border_rounded,
                      color: Color(0xFFc6cca5),
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class AddMuseoDialog extends StatefulWidget {
  @override
  _AddMuseoDialogState createState() => _AddMuseoDialogState();
}

class _AddMuseoDialogState extends State<AddMuseoDialog>{
  final _formkey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _reviewController = TextEditingController();
  double _calificacion = 3.0;
  String? _imagePath;

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text("Agregar Museo"),
      content: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: "Nombre del museo"),
                validator: (value){
                  if (value!.isEmpty) {
                    return "Por favor ingrese un nombre";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reviewController,
                decoration: InputDecoration(labelText: "Reseña"),
                validator: (value){
                  if (value!.isEmpty){
                    return "Por favor ingrese una reseña";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text("calificación:"),
              RatingBar(
                initialRating: _calificacion,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star_rounded, color: Color(0xFFc6cca5)),
                  half: Icon(Icons.star_half_rounded, color: Color(0xFFc6cca5)),
                  empty: Icon(Icons.star_outline_rounded, color: Color(0xFFc6cca5)),
                ),
                onRatingUpdate: (calificacion){
                  setState(() {
                    _calificacion = calificacion;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async{
                  final picker = ImagePicker();
                  final PickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                  if (PickedFile != null) {
                    setState(() {
                      _imagePath = PickedFile.path;
                    });
                  }
                },
                child: Text("Agregar foto"),
              ),
              if(_imagePath != null) Image.file(File(_imagePath!), height: 100),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: (){
            if (_formkey.currentState!.validate()) {
              final newMuseo = Museo(
                _nombreController.text,
                _reviewController.text,
                _calificacion,
                _imagePath ?? '',
              );
              context.read<MyAppState>().museoAdd(newMuseo);
              Navigator.of(context).pop();
            }
          },
          child: Text("Guardar"),
        ),
      ],
    );
  }
}