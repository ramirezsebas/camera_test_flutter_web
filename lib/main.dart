import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: BeforeCamera(controller: controller),
    );
  }
}

class BeforeCamera extends StatefulWidget {
  final CameraController controller;

  const BeforeCamera({Key? key, required this.controller}) : super(key: key);

  @override
  State<BeforeCamera> createState() => _BeforeCameraState();
}

class _BeforeCameraState extends State<BeforeCamera> {
  XFile? image;
  bool loading = false;
  double zoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                loading = true;
              });
              widget.controller.takePicture().then((XFile value) {
                setState(() {
                  image = value;
                  loading = false;
                });
              }).catchError(
                (Object e) {
                  setState(() {
                    loading = false;
                  });
                  if (e is CameraException) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${e.code}/n${e.description}"),
                      ),
                    );
                    switch (e.code) {
                      case 'CameraAccessDenied':
                        print('User denied camera access.');
                        break;
                      default:
                        print('Handle other errors.');
                        break;
                    }
                  }
                },
              );
            },
            child: const Icon(Icons.camera),
          ),
          FloatingActionButton(
            heroTag: "zoomin",
            onPressed: () {
              if (zoomLevel < 3) {
                setState(() {
                  loading = true;
                  zoomLevel = zoomLevel + 0.5;
                });
              } else {
                setState(() {
                  loading = true;
                  zoomLevel = 1.0;
                });
              }
              widget.controller.setZoomLevel(zoomLevel).then((_) {
                setState(() {
                  loading = false;
                });
              }).catchError(
                (Object e) {
                  setState(() {
                    loading = false;
                  });
                  if (e is CameraException) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${e.code}/n${e.description}"),
                      ),
                    );
                    switch (e.code) {
                      case 'CameraAccessDenied':
                        print('User denied camera access.');
                        break;
                      default:
                        print('Handle other errors.');
                        break;
                    }
                  }
                },
              );
            },
            child: const Icon(Icons.zoom_in),
          ),
          FloatingActionButton(
            heroTag: "zoomout",
            onPressed: () {
              if (zoomLevel > 1.0) {
                setState(() {
                  loading = true;
                  zoomLevel = zoomLevel - 0.5;
                });
              } else {
                setState(() {
                  loading = true;
                  zoomLevel = 1.0;
                });
              }
              widget.controller.setZoomLevel(zoomLevel).then((_) {
                setState(() {
                  loading = false;
                });
              }).catchError(
                (Object e) {
                  setState(() {
                    loading = false;
                  });
                  if (e is CameraException) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${e.code}/n${e.description}"),
                      ),
                    );
                    switch (e.code) {
                      case 'CameraAccessDenied':
                        print('User denied camera access.');
                        break;
                      default:
                        print('Handle other errors.');
                        break;
                    }
                  }
                },
              );
            },
            child: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      color: Colors.black,
                      child: CameraPreview(widget.controller),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: image == null
                        ? const Center(
                            child: Text(
                              'Camera Preview',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : Center(
                            child: Image.network(
                              image!.path,
                            ),
                          ),
                  ),
                )
              ],
            ),
            loading
                ? // Make loading indicator with dark background
                Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
