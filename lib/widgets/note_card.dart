import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_notes/style/app_style.dart';
import 'package:flutter/material.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppStyle.cardsColor[doc['color_id']],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            doc['note_title'],
            style: AppStyle.mainTitle,
          ),
          const SizedBox(height: 4),
          Text(
            doc['creation_date'],
            style: AppStyle.mainDateTitle,
          ),
          const SizedBox(height: 4),
          Text(
            doc['note_content'],
            style: AppStyle.mainContent,
          ),
        ],
      ),
    ),
  );
}
