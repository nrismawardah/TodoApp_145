import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class Tugas {
  String tugas;
  DateTime deadline;
  bool status;

  Tugas({required this.tugas, required this.deadline, this.status = false});
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController tugasController = TextEditingController();
  final key = GlobalKey<FormState>();
  List<Tugas> daftarTugas = [];
  DateTime? selectedDate;

  void addData() {
    if (key.currentState!.validate()) {
      if (selectedDate == null) {
        setState(() {});
        return;
      }
      setState(() {
        daftarTugas.add(Tugas(tugas: tugasController.text, deadline: selectedDate!));
        tugasController.clear();
        selectedDate = null;
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 15,
            children: [
              Row(
                spacing: 15,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/images/1.jpeg'),
                  ),
                  Text(
                    'Loopy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text('Form Page', style: TextStyle(fontSize: 20)),
              ),
              Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Task Date:', style: TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'Select a Date'
                                : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}-${selectedDate!.hour}-${selectedDate!.minute}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => selectDate(context),
                        ),
                      ],
                    ),
                    if (selectedDate == null)
                          const Text(
                            'Please select a date',
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                          
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: tugasController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              label: Text('Task'),
                              hintText: 'Enter your task',
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              addData();
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text('Task List', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Expanded(
                child:
                    (daftarTugas.isEmpty)
                        ? Center(child: Text('Task list is empty'))
                        : ListView.builder(
                          itemCount: daftarTugas.length,
                          itemBuilder: (context, index) {
                            final tugas = daftarTugas[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  tugas.tugas,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Deadline: ${tugas.deadline.day}-${tugas.deadline.month}-${tugas.deadline.year} ${tugas.deadline.hour}:${tugas.deadline.minute}',
                                    ),
                                    Text(
                                      tugas.status ? 'Done' : 'Not Done',
                                      style: TextStyle(
                                        color:
                                            tugas.status
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
