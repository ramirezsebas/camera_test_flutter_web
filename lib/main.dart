import 'package:camera_web/camera_web.dart';
import 'package:flutter/material.dart';
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// TODO(a14n): remove this import once Flutter 3.1 or later reaches stable (including flutter/flutter#106316)
// ignore: unnecessary_import

import 'package:camera_web/src/camera_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Web Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera Web Test'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final cameraService = CameraService();

                print(cameraService.toString());

                final cameraPlugin = CameraPlugin(cameraService: cameraService);

                print(cameraPlugin.toString());
                try {
                  final cameras = await cameraPlugin.availableCameras();
                  print(cameras.toString());

                  final camera = cameras.first;

                  print(camera.toString());

                //   await cameraPlugin.initializeCamera(camera.name);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                  print(e.toString());
                }
              },
              child: const Text("Get cameras"),
            )
          ],
        ),
      ),
    );
  }
}
