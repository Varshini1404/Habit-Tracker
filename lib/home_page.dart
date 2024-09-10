import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Calendar package
import 'habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Sample data for habits
  List todayHabitList = [
    ['Exercise', true],
    ['Meditation', false],
    ['Reading', true],
  ];

  // Calendar focus
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Method to handle checkbox toggle
  void checkBoxtapped(bool? value, int index) {
    setState(() {
      todayHabitList[index][1] = value;
    });
  }

  // Method to open habit settings
  void openHabitSettings(int index) {
    // Add habit settings logic here
  }

  // Method to delete a habit
  void deleteHabit(int index) {
    setState(() {
      todayHabitList.removeAt(index);
    });
  }

  // Method to add a new habit
  void addNewHabit() {
    // Show a dialog or bottom sheet to add a new habit
    showDialog(
      context: context,
      builder: (context) {
        // Text controller to get the habit name
        TextEditingController habitController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Habit'),
          content: TextField(
            controller: habitController,
            decoration: const InputDecoration(hintText: 'Enter habit name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Add the new habit to the list with default completion status as false
                  todayHabitList.add([habitController.text, false]);
                });
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
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
        title: const Text('My Habits'),
        centerTitle: true,
      ),
      backgroundColor: Colors.purple[50],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          // Call the method to add a new habit
          addNewHabit();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todayHabitList.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: todayHabitList[index][0],
                  habitCompleted: todayHabitList[index][1],
                  onChanged: (value) {
                    checkBoxtapped(value, index);
                  },
                  settingsTapped: (context) {
                    openHabitSettings(index);
                  },
                  deleteTapped: (context) {
                    deleteHabit(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
