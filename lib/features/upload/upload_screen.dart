import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:provider/provider.dart';

import '../../core/services/excel_service.dart';
import '../../core/parser/edn_reader.dart';
import '../../models/edn_model.dart';
import '../../providers/scanner_provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final ExcelService excelService = ExcelService();
  final EdnReader reader = EdnReader();

  String fileName = "Belum ada file dipilih";
  EdnModel? edn;

  Future pilihFile() async {
    try {
      final result = await excelService.pickAndReadExcel();

      if (result == null) return;

      final Excel excel = result["excel"];

      final parsedEdn = reader.read(
        excel,
        result["fileName"],
      );

      final provider = Provider.of<ScannerProvider>(
        context,
        listen: false,
      );

      provider.setEdn(parsedEdn);

      setState(() {
        edn = parsedEdn;
        fileName = parsedEdn.fileName;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ EDN berhasil dimuat"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Provider.of<ScannerProvider>(
        context,
        listen: false,
      ).clearEdn();

      setState(() {
        edn = null;
        fileName = "ERROR";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget summaryCard() {
    if (edn == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Column(
            children: [
              Icon(
                Icons.description_outlined,
                size: 42,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 10),
              Text(
                "Belum ada EDN",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                "File EDN yang dipilih akan tampil di sini.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              edn!.fileName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: infoBox(
                    "Case",
                    edn!.totalCase.toString(),
                  ),
                ),
                Expanded(
                  child: infoBox(
                    "Part No",
                    edn!.totalPartNumber.toString(),
                  ),
                ),
                Expanded(
                  child: infoBox(
                    "Qty",
                    edn!.totalTarget.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget infoBox(
    String title,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF44336),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget caseViewer() {
    if (edn == null) {
      return const SizedBox();
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 2),
        itemCount: edn!.cases.length,
        itemBuilder: (context, index) {
          final caseModel = edn!.cases[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              shape: const RoundedRectangleBorder(),
              collapsedShape: const RoundedRectangleBorder(),
              leading: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFFF44336),
              ),
              title: Text(
                caseModel.caseNo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${caseModel.totalPart} Part",
              ),
              children: caseModel.parts.map((part) {
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.settings_outlined,
                    size: 18,
                  ),
                  title: Text(part.partNo),
                  subtitle: Text(part.partName),
                  trailing: Text(
                    "${part.targetQty} pcs",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload EDN"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pilihFile,
                icon: const Icon(Icons.folder_open_outlined),
                label: const Text("PILIH FILE EXCEL"),
              ),
            ),
            const SizedBox(height: 16),
            summaryCard(),
            const SizedBox(height: 12),
            caseViewer(),
          ],
        ),
      ),
    );
  }
}