import 'dart:io';
import 'dart:typed_data';
import 'package:billing/view/bill_preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
class BillPdfService {
  Future<Uint8List> generateBillPDF({
  required String customerName,
  required String address,
  required String mobileNumber,
  required String gstNumber,
  // required DateTime date,
  PdfPageFormat format = PdfPageFormat.a4, required DateTime date,
  
}) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.Container(
          padding: const pw.EdgeInsets.only(top:8), // Padding to ensure content doesn't touch the border
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColors.black,
              width: 2,
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Heading section
              pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'RITESH POLYMERS',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.justify,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Sr.No.1/2, Ambadwet, Tal-Mulsi, Dist-Pune',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Phone No.: 9595065650,9960266534 Email: ratanlal95950@gmail.com',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '27AAZFR8775N1ZP',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
               
              ),
              pw.SizedBox(height: 20),
              // Heading section closed
              pw.Container(
                color: PdfColors.black, // Line color
                height: 2, // Line thickness
                width: double.infinity, // Full width
              ),
             
              // Data after heading section
              pw.Row(
                children: [
                  // First column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Padding(padding:const pw.EdgeInsets.only(left: 4),
                         child: pw.Text(customerName, style:const pw.TextStyle(fontSize: 8)), 
                         ),
                        pw.Padding(padding:const pw.EdgeInsets.only(left: 4),
                        child:pw.Text(address, style:const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(padding:const pw.EdgeInsets.only(left: 4),
                        child :pw.Text('Kothrud', style:const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(padding:const pw.EdgeInsets.only(left: 4),
                        child:pw.Text('Pune', style:const pw.TextStyle(fontSize: 8)),
                        ),
                        pw.Padding(padding:const pw.EdgeInsets.only(left: 4),
                        child:pw.Text(mobileNumber, style:const pw.TextStyle(fontSize: 8)),),
                        pw.Padding(padding:const pw.EdgeInsets.only(left: 4),
                        child:pw.Text(gstNumber, style:const pw.TextStyle(fontSize: 8)),
                        ),
                      ],
                    ),
                  ),
                   pw.SizedBox(width: 75),
                  // Vertical Line
                pw.Container(
                  width: 1, // Thickness of the vertical line
                  height: 50, // Adjust this height as needed
                  color: PdfColors.black,
                ),
                  // Spacer
                  pw.SizedBox(width: 100),
                  // Second Column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Invoice : 1', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Date : ${DateFormat('d/MM/yyyy').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Po No. :', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Po Date :', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Chalan No :', style: const pw.TextStyle(fontSize: 8)),
                        pw.Text('Transport :', style: const pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 0),
              // Table
              pw.Padding(
                padding:const pw.EdgeInsets.all(0),
                child: pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0:const pw.FlexColumnWidth(0.5), // Column 1
                    1:const pw.FlexColumnWidth(4), // Column 2
                    2:const pw.FlexColumnWidth(1), // Column 3
                    3:const pw.FlexColumnWidth(1), // Column 4
                    4:const pw.FlexColumnWidth(1), // Column 5
                    5:const pw.FlexColumnWidth(1), // Column 6
                    6:const pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300,
                        borderRadius: pw.BorderRadius.zero, // Background color for the header row
                      ),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('SN', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('Particulars', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('HSN code(GST)', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('Unit', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('Rate', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('GST%', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text('Final Amt', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    // Data Row
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Center(
                            child: pw.Text('1', style: const pw.TextStyle(fontSize: 6)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Center(
                            child: pw.Text('Black Powder', style: const pw.TextStyle(fontSize: 6)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Center(
                            child: pw.Text('3925', style: const pw.TextStyle(fontSize: 6)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Center(
                            child: pw.Text('5 KGS', style: const pw.TextStyle(fontSize: 6)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Center(
                            child: pw.Text('0', style: const pw.TextStyle(fontSize: 6)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Center(
                            child: pw.Text('18', style: const pw.TextStyle(fontSize: 6)),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Center(
                            child: pw.Text('0', style: const pw.TextStyle(fontSize: 6)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Table closed
              pw.Spacer(),
              // Divider line above the footer
              pw.Divider(
                color: PdfColors.black,
                thickness: 1.5,
              ),


              // Footer
              pw.Container(
                padding:const pw.EdgeInsets.only(right: 4,left: 4),
                child:pw.Row(
                children: [
                  // First column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Amount Chargable (In Words) ', style:const pw.TextStyle(fontSize:6)),
                        pw.Text('Zero Rupees Only', style: pw.TextStyle(fontSize: 4,fontWeight: pw.FontWeight.bold)),
                        pw.Text(''),
                        pw.Text(''),
                       
                      ],
                    ),
                    
                  ),
                 
                  pw.Container(
                    width: 1,height: 30, color: PdfColors.black,
                  ),
                  // Spacer
                 pw.SizedBox(width: 240),
                  
                         pw.Container(
                          width: 1,
                          height: 30,
                          color: PdfColors.black,

                        ),
                  // Second Column
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Sub Total', style: pw.TextStyle(fontSize: 4,fontWeight: pw.FontWeight.bold)),
                        pw.Text('CGST: 0.00', style: const pw.TextStyle(fontSize: 4)),
                        pw.Text('SGST: 0.00', style: const pw.TextStyle(fontSize: 4)),
                        pw.Text('Grand Total: 0.0', style:pw.TextStyle(fontSize: 4,fontWeight: pw.FontWeight.bold)),
                        
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 4),
                


                ],
              ),
             
              ),
             // pw.SizedBox(height: 4),
              pw.Container(
                padding:const pw.EdgeInsets.only(bottom :4,right: 4,left: 4),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child:pw.Column(
                        
                         crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                        pw.Text('TERMS AND CONDITIONS', style:const pw.TextStyle(fontSize: 6,)),
                        pw.SizedBox(height: 8),
                        pw.Text('1) Order once taken will not be cancelled', style: const pw.TextStyle(fontSize: 4)),
                        pw.Text('2) Payment 50% Advance and balance 50% before delivery', style: const pw.TextStyle(fontSize: 4)),
                        pw.Text('3) Guarantee only manufacturing defect guarantee', style:const pw.TextStyle(fontSize: 4,)),
                                              
                        
                     ],
                     ),
                     
                     ),
                    // pw.SizedBox(width: 30),
                        pw.Container(
                          width: 1,
                          height: 30,
                          color: PdfColors.black,

                        ),
                         pw.SizedBox(width: 240),
                         
                         pw.Container(
                          width: 1,
                          height: 30,
                          color: PdfColors.black,

                        ),
                   pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('', style: pw.TextStyle(fontSize: 4,fontWeight: pw.FontWeight.bold)),
                        pw.Text('', style: const pw.TextStyle(fontSize: 4)),
                        pw.Text('', style: const pw.TextStyle(fontSize: 4)),
                        pw.Text('', style:pw.TextStyle(fontSize: 4,fontWeight: pw.FontWeight.bold)),
                        
                      ],
                    ),
                  ),
                    
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  return pdf.save();
}

  //void savePdfFile(String s, Uint8List data) {}
  Future<void> savePdfFile(String filename, Uint8List data) async {
    // Save the PDF file to the device storage
  }



}
