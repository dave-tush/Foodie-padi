import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  final reviews = [
    {
      "name": "John Doe",
      "date": "29/03/2024",
      "comment": "Delicious ewa agoyin! Loved the soft ponmo and the source was perfectly cooked.",
    },
    {
      "name": "David",
      "date": "10/04/2024",
      "comment": "Absolutely delicious! The bread was so soft and sweet, with just the right amount of source.",
    },
    {
      "name": "Tom",
      "date": "05/04/2024",
      "comment": "One of the best ewa agoyin I've ever had! The beef was tender and the bread was soft.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reviews")),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (_, i) {
          final review = reviews[i];
          return ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text(review["name"]!),
            subtitle: Text("${review["date"]}\n${review["comment"]}"),
            isThreeLine: true,
            trailing: Icon(Icons.star, color: Colors.amber),
          );
        },
      ),
    );
  }
}
