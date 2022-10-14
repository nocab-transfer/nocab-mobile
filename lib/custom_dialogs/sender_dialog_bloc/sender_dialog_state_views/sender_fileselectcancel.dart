import 'package:flutter/material.dart';

class FileSelectCancelView extends StatelessWidget {
  const FileSelectCancelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            height: 208,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const RadialGradient(
                        center: Alignment.center,
                        radius: 0.5,
                        colors: [Colors.orange, Colors.red],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: const Icon(Icons.close_rounded, size: 50),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No File Selected",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onBackground),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("click to close",
                        style: Theme.of(context).textTheme.bodySmall))
              ],
            ),
          )),
    );
  }
}
