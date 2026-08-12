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

      // ============================
      // Simpan ke Provider
      // ============================

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
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              "Belum ada EDN",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            const SizedBox(height: 15),
            Text(
              edn!.fileName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                infoBox(
                  "Case",
                  edn!.totalCase.toString(),
                ),
                infoBox(
                  "Part No",
                  edn!.totalPartNumber.toString(),
                ),
                infoBox(
                  "Qty",
                  edn!.totalTarget.toString(),
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
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }

  Widget caseViewer() {
    if (edn == null) {
      return const SizedBox();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: edn!.cases.length,
        itemBuilder: (context, index) {
          final caseModel = edn!.cases[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              leading: const Icon(
                Icons.inventory_2,
                color: Colors.red,
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
                    Icons.settings,
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Upload EDN"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: pilihFile,
                icon: const Icon(Icons.folder_open),
                label: const Text("PILIH FILE EXCEL"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
            summaryCard(),
            const SizedBox(height: 10),
            caseViewer(),
          ],
        ),
      ),
    );
  }
}