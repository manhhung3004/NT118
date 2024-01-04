// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EventViewPage extends StatefulWidget {
  final List<dynamic>? event;
  List<dynamic> deletedEvents = [];

  EventViewPage({
    super.key,
    required this.event,
  });

  @override
  EventViewPageState createState() => EventViewPageState();
}

class EventViewPageState extends State<EventViewPage> {
  late TextEditingController fromController;
  late TextEditingController toController;
  late TextEditingController nameController;
  late dynamic eventItem;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    eventItem = widget.event![selectedIndex];
    nameController =
        TextEditingController(text: eventItem.eventName.toString());
    fromController = TextEditingController(text: eventItem.from.toString());
    toController = TextEditingController(text: eventItem.to.toString());
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void deleteEvent() {
    setState(() {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("CalendarAppointmentCollection")
          .doc(eventItem.key);
      docRef.delete();
      widget.deletedEvents.add(eventItem);
      widget.event!.removeAt(selectedIndex);
    });
  }

  void saveChanges() {
    // Update the event object with the new values
    setState(() {
      eventItem.background = eventItem.background;
      eventItem.eventName = nameController.text;
      eventItem.from = DateTime.parse(fromController.text);
      eventItem.to = DateTime.parse(toController.text);
    });
    // Update the event data in Firestore
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("CalendarAppointmentCollection")
        .doc(eventItem.key);
    docRef.update({
      'Subject': eventItem.eventName,
      'StartTime': DateFormat('dd/MM/yyyy HH:mm:ss').format(eventItem.from),
      'EndTime': DateFormat('dd/MM/yyyy HH:mm:ss').format(eventItem.to),
      // Add other fields you want to update
    }).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Changes saved successfully.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save changes: $error'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                deleteEvent(); // Gọi hàm xóa sự kiện
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit your task"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(32),
              itemCount: widget.event!.length,
              itemBuilder: (BuildContext context, int index) {
                eventItem = widget.event![index];
                return Card(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Task',
                            hintText: eventItem.eventName.toString(),
                          ),
                        ),
                        TextField(
                          controller: fromController,
                          decoration: InputDecoration(
                            labelText: 'From',
                            hintText: eventItem.from.toString(),
                          ),
                        ),
                        TextField(
                          controller: toController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            hintText: eventItem.to.toString(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDeleteConfirmationDialog(context);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Màu nền của button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Đặt bo tròn cho button
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ), // Phong cách chữ của button
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Màu nền của button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Đặt bo tròn cho button
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
