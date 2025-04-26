import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../models/product.model.dart';
import 'package:http/http.dart' as http;

class PDFGenerator {
  static Future<File> generateProductPDF(Product product) async {
    final pdf = pw.Document();
    
    // Try to load product image
    pw.MemoryImage? productImage;
    try {
      final response = await http.get(Uri.parse(product.mainImage));
      if (response.statusCode == 200) {
        productImage = pw.MemoryImage(response.bodyBytes);
      }
    } catch (e) {
      debugPrint('Error loading image: $e');
    }

    // Create the PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(product, productImage),
            pw.SizedBox(height: 20),
            _buildProductInfo(product),
            pw.SizedBox(height: 20),
            _buildDescription(product),
            pw.SizedBox(height: 20),
            if (product.variants != null && product.variants!.isNotEmpty)
              _buildVariantsTable(product),
          ];
        },
      ),
    );
    
    return _savePDF(pdf, 'product_${product.id}.pdf');
  }
  
  static pw.Widget _buildHeader(Product product, pw.MemoryImage? image) {
    return pw.Header(
      level: 0,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(product.name, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text(product.type, style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
              pw.SizedBox(height: 8),
              pw.Text('\$${product.price.toStringAsFixed(2)}', 
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue700)),
            ],
          ),
          if (image != null)
            pw.Container(
              width: 120,
              height: 120,
              child: pw.Image(image, fit: pw.BoxFit.contain),
            )
        ],
      ),
    );
  }
  
  static pw.Widget _buildProductInfo(Product product) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Product Information', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        pw.SizedBox(height: 10),
        _buildInfoRow('Product ID', product.id),
        _buildInfoRow('Rating', '${product.rating}/5'),
        if (product.isNew) _buildInfoRow('Status', 'NEW PRODUCT'),
      ],
    );
  }
  
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 150,
            child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }
  
  static pw.Widget _buildDescription(Product product) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Product Description', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(product.fullDescription ?? product.description),
      ],
    );
  }
  
  static pw.Widget _buildVariantsTable(Product product) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Available Variants', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            // Table header
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Variant', isHeader: true),
                _buildTableCell('Color', isHeader: true),
                _buildTableCell('Price', isHeader: true),
              ],
            ),
            // Table data
            for (var variant in product.variants!)
              pw.TableRow(
                children: [
                  _buildTableCell(variant.name),
                  _buildTableCell(variant.color),
                  _buildTableCell('\$${variant.price.toStringAsFixed(2)}'),
                ],
              ),
          ],
        ),
      ],
    );
  }
  
  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : null,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
  
  static Future<File> _savePDF(pw.Document pdf, String fileName) async {
    try {
      // Check and request permissions on Android
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }
      
      // Get the app's documents directory
      final output = await getApplicationDocumentsDirectory();
      final filePath = '${output.path}/$fileName';
      final file = File(filePath);
      
      // Save the PDF
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      debugPrint('Error saving PDF: $e');
      rethrow;
    }
  }
  
  static Future<void> sharePDF(File pdfFile) async {
    try {
      await Share.shareXFiles([XFile(pdfFile.path)], text: 'Product Details PDF');
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
    }
  }
} 