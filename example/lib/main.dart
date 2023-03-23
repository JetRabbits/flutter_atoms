import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atoms/flutter_atoms.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return JetApp(
      useAtomsIntl: false,
      onGenerateTitle: (BuildContext context) => "Example",
      nextRoute: () => "/main/home",
      onAppStart: () => SynchronousFuture(true),
      navigationModel: NavigationModel(
          routes: {
            // For each route create screen widgets
            "/main/home": (context) {
              return Scaffold(
                body: Column(
                  children: const [Text("Welcome to Home!")],
                ),
              );
            },
            "/main/favorites": (context) {
              return Scaffold(
                body: Column(
                  children: const [Text("Favorites screen")],
                ),
              );
            },
            "/main/profile": (context) {
              return Scaffold(
                body: Column(
                  children: const [Text("Profile screen")],
                ),
              );
            },
          },
          navBarButtons: {
            //Navigation buttons definition
            "/main/home": (context) =>
                const BottomNavigationBarItem(icon: Icon(Icons.home)),
            "/main/favorites": (context) => const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border)),
            "/main/profile": (context) =>
                const BottomNavigationBarItem(icon: Icon(Icons.person)),
          },
          floatButtons: {
            "/main": FloatActionButtonConfig(
                (context) => FloatingActionButton(
                    child: const Icon(Icons.home),
                    onPressed: () {
                      "/main/home".go();
                    }),
                FloatingActionButtonLocation.miniStartFloat)
          },
          //Route Validation. Useful to organize authorization process
          routesValidator: RoutesValidator(onValidate: (route) {
            // return route;
            return route;
          })),
    );
  }
}
