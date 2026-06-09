import 'package:flutter/material.dart';

class VerseMessageWidget extends StatelessWidget {
  final Map<String, dynamic> verseData;

  final VoidCallback onBookmark;

  const VerseMessageWidget({
    super.key,
    required this.verseData,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final verse = verseData["verse"];
    final tafsir = verseData["tafsir"];
    final whyRecommended = verseData["why_recommended"];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${verse["surah_name"]} ${verse["surah_number"]}:${verse["verse_number"]}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border, color: Colors.amber[800]),
                  onPressed: onBookmark,
                ),
              ],
            ),

            Divider(height: 20),

            Text(
              verse["arabic_text"] ?? "",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 2.0,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),

            SizedBox(height: 12),

            Text(
              verse["translation"] ?? "",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[800],
              ),
            ),

            SizedBox(height: 16),

            Text(
              "Explanation:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 8),

            Text(
              tafsir["content"] ?? "",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            SizedBox(height: 12),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: Colors.amber[800],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      whyRecommended ?? "",
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
