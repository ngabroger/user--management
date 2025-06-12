import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserDetailView extends StatelessWidget {
  final Map user;
  const UserDetailView({required this.user, super.key});

  String? getFormattedDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return null;
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMMM yyyy, HH:mm').format(date);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = user['avatar'];
    final createdAt = getFormattedDate(user['created_at']);

    return Scaffold(
      appBar: AppBar(title: Text('Detail User')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: (imageUrl != null && imageUrl.toString().isNotEmpty)
                  ? CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(
                        imageUrl.toString().startsWith('http')
                            ? imageUrl
                            : 'http://10.0.2.2:8000/storage/$imageUrl',
                      ),
                    )
                  : CircleAvatar(
                      radius: 48,
                      child: Text(
                        user['name'] != null && user['name'].isNotEmpty
                            ? user['name'][0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 24),
            Text(
              user['name'] ?? '-',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(user['email'] ?? '-', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            if (createdAt != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Dibuat: $createdAt',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
