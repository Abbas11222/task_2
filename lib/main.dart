import 'package:flutter/material.dart';
import 'package:task2/qouespage.dart';
import 'DBhelper.dart';
import 'model.dart';

void main() {
  runApp(const MaterialApp(
    title: "Task 2",
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Define the pages
  final List<Widget> _pages = [
    Page2(), // The quote display page
    Page3(), // The flashcards management page
  ];

  // Method to handle navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Task 2 App"),
      //   backgroundColor: Colors.teal,
      // ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Quote',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped, // Handle tap on items
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<User> quotes = [];
  final Dbhelper db = Dbhelper();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final List<dynamic> list = await db.getAlltasks();
    setState(() {
      quotes = list.map((e) => User.fromMap(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(onPressed:()=>_addqoute(), icon: const Icon(Icons.add))
        ],
      ),
      body: quotes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, int position) {
          return Card(
            child: ListTile(
              tileColor: Colors.black12.withOpacity(0.1),
              title: Text(quotes[position].qoute,maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),),
              subtitle: Text(quotes[position].author,style: const TextStyle(fontWeight: FontWeight.bold),),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Call the edit function with the selected quote
                      _edit(quotes[position]);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _edit(User quote) {
    TextEditingController quoteController = TextEditingController(text: quote.qoute);
    TextEditingController authorController = TextEditingController(text: quote.author);
    int? currentId = quote.id;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Quote"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: quoteController,
                  decoration: const InputDecoration(labelText: "Quote"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: "Author"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Create the updated User object with the current id, updated quote, and author
                User updatedUser = User(
                  quoteController.text,  // Updated quote text
                  authorController.text, // Updated author text
                );
                // Update the quote in the database
                db.updatetask(updatedUser);
                // Close the dialog and refresh the data
                _fetchData(); // Reload the list of quotes
                Navigator.pop(context);

              },
              child: const Text("Save"),
            ),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
  void _addqoute() {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Quotes"),
          content: SingleChildScrollView( // Use SingleChildScrollView for better scrolling
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: "Input Qoute"),
                ),
                const SizedBox(height: 10), // Add spacing
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(labelText: "Author"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                User newUser = User(questionController.text, answerController.text);
                db.savetask(newUser); // Save the new flashcard to the database
                Navigator.pop(context);
                _fetchData(); // Reload flashcards
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}