import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:cross_file/cross_file.dart';  // Correct import for XFile

class BillPreviewScreen extends StatefulWidget {
  final Uint8List pdfData;

  BillPreviewScreen({required this.pdfData});

  @override
  _BillPreviewScreenState createState() => _BillPreviewScreenState();
}

class _BillPreviewScreenState extends State<BillPreviewScreen> {
  String? filePath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/bill_preview.pdf");
    await file.writeAsBytes(widget.pdfData);
    setState(() {
      filePath = file.path;
    });
  }

  void _sharePdf() async {
    if (filePath != null) {
      final file = XFile(filePath!);
      await Share.shareXFiles([file], text: 'Check out this bill!');
    }
  }

  void _printPdf() async {
    if (widget.pdfData.isNotEmpty) {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => widget.pdfData,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printPdf,
            tooltip: 'Print',
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _sharePdf,
            tooltip: 'Share',
          ),
        ],
      ),
      body: filePath != null
          ? Column(
              children: [
                Expanded(
                  child: PDFView(
                    filePath: filePath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onRender: (pages) => print('PDF rendered with $pages pages'),
                    onError: (error) => print(error.toString()),
                    onPageError: (page, error) => print('Error on page $page: $error'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ElevatedButton.icon(
                          onPressed: _sharePdf,
                          icon: Icon(Icons.share),
                          label: Text('Share'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.blue,
                            elevation: 4,
                          ).copyWith(
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: Colors.blueAccent,
                                width: 2,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.blueAccent;
                                }
                                return Colors.blue;
                              },
                            ),
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ElevatedButton.icon(
                          onPressed: _printPdf,
                          icon: Icon(Icons.print),
                          label: Text('Print'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green,
                            elevation: 4,
                          ).copyWith(
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: Colors.greenAccent,
                                width: 2,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.greenAccent;
                                }
                                return Colors.green;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
