import 'package:flutter/material.dart';
import 'package:ai_project/LoginPage.dart';
import 'package:ai_project/assistant_vocal.dart';
import 'package:ai_project/tflite_page.dart'; // Import TFLitePage

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Name/Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ExpansionTile(
            leading: Icon(Icons.image),
            title: Text('Image Classification'),
            children: <Widget>[
              ListTile(
                title: Text('CNN'), // Option for CNN
                onTap: () {
                  // Close the drawer and navigate to TFLitePage
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TFLitePage()),
                  );
                },
              ),
              ListTile(
                title: Text('ANN'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.trending_up),
            title: Text('Stock Price Produit'),
            children: <Widget>[
              ListTile(
                title: Text('LLM'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('RAG'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.mic),
            title: Text('Voice Assistant'),
            children: [],
            onExpansionChanged: (bool expanded) {
              if (expanded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssistantVocal()),
                );
              }
            },
          ),
          // Logout button at the bottom
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              // Navigate to the Login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Replace LoginPage() with your actual login page widget
              );
            },
          ),
        ],
      ),
    );
  }
}
