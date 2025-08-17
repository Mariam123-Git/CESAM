import 'package:flutter/material.dart';
import 'package:cesam_app/core/app_router.dart';

void main() {
  runApp(const StudentHopApp());
}

class StudentHopApp extends StatelessWidget {
  const StudentHopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Hop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.startup,
    );
  }
}