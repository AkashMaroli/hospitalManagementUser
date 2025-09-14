// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DocumentUploadWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? documentName;
  final bool isUploaded;

  const DocumentUploadWidget({
    super.key,
    required this.onTap,
    this.documentName,
    this.isUploaded = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              isUploaded ? Icons.check_circle : Icons.file_present,
              color: isUploaded ? Colors.green : Colors.teal,
              size: 32,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                documentName ?? 'Tap to upload a document',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
