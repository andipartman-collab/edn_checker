import 'package:flutter/material.dart';

class ScannerInput extends StatefulWidget {
  final Function(String) onScanned;

  const ScannerInput({
    super.key,
    required this.onScanned,
  });

  @override
  State<ScannerInput> createState() => _ScannerInputState();
}

class _ScannerInputState extends State<ScannerInput> {
  final TextEditingController controller =
      TextEditingController();

  final FocusNode focusNode =
      FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void submit() {
    final barcode = controller.text.trim();

    if (barcode.isEmpty) return;

    widget.onScanned(barcode);

    controller.clear();

    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        focusNode.requestFocus();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 3,

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "SCAN BARCODE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 15),

            TextField(

              controller: controller,

              focusNode: focusNode,

              textInputAction:
                  TextInputAction.done,

              onSubmitted: (_) => submit(),

              decoration: InputDecoration(

                hintText:
                    "Scan atau ketik barcode...",

                prefixIcon:
                    const Icon(Icons.qr_code),

                suffixIcon: IconButton(

                  icon: const Icon(Icons.clear),

                  onPressed: () {
                    controller.clear();

                    focusNode.requestFocus();
                  },
                ),

                border:
                    const OutlineInputBorder(),

              ),
            ),
          ],
        ),
      ),
    );
  }
}