import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
}

void museoAdd(){

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
          unselectedLabelColor: Colors.grey,
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Se implementa el boton para dar acción a agregar museo
    return IconButton(
      icon: Icon(Icons.add_circle_outline_outlined),
      onPressed: (){
        //Acción que va a ejecutar al presionar el boton
        print('Boton presionado');
      },
    );
  }
}