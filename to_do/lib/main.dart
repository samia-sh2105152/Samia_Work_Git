import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/core/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ToDoApp()));

  // final databaseInitializationProvider = FutureProvider<void>((ref) async {
  //   final database = await ref.watch(databaseProvider.future);
  //   await DatabaseSeeder.seedDatabase(database);
  // });
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'YourDay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8CB9D1)),
        textTheme: GoogleFonts.inriaSansTextTheme(),
      ),

      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
