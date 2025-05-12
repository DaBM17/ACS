import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';

class SchedulePage extends StatefulWidget {
  UserGroup userGroup;

  SchedulePage({super.key, required this.userGroup});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime? fromDate;
  DateTime? toDate;
  TimeOfDay? fromTime;
  TimeOfDay? toTime;
  late UserGroup userGroup;
  List<bool> selectedWeekdays = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    userGroup = widget.userGroup;
    _loadData(); // Recuperar los datos guardados al iniciar la pantalla
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Recuperar fechas
      final fromDateString = prefs.getString('fromDate');
      if (fromDateString != null) {
        fromDate = DateTime.parse(fromDateString);
      }

      final toDateString = prefs.getString('toDate');
      if (toDateString != null) {
        toDate = DateTime.parse(toDateString);
      }

      // Recuperar horas
      final fromTimeString = prefs.getString('fromTime');
      if (fromTimeString != null) {
        final parts = fromTimeString.split(':');
        fromTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }

      final toTimeString = prefs.getString('toTime');
      if (toTimeString != null) {
        final parts = toTimeString.split(':');
        toTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }

      // Recuperar días seleccionados
      final weekdaysString = prefs.getString('selectedWeekdays');
      if (weekdaysString != null) {
        selectedWeekdays = weekdaysString.split(',').map((e) => e == 'true').toList();
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Guardar fechas
    if (fromDate != null) prefs.setString('fromDate', fromDate!.toIso8601String());
    if (toDate != null) prefs.setString('toDate', toDate!.toIso8601String());

    // Guardar horas
    if (fromTime != null) prefs.setString('fromTime', '${fromTime!.hour}:${fromTime!.minute}');
    if (toTime != null) prefs.setString('toTime', '${toTime!.hour}:${toTime!.minute}');

    // Guardar días seleccionados
    prefs.setString('selectedWeekdays', selectedWeekdays.map((e) => e.toString()).join(','));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule ${widget.userGroup.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // From Date
            const Text('From'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: fromDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          fromDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        fromDate != null
                            ? "${fromDate!.month}/${fromDate!.day}/${fromDate!.year}"
                            : "Select Date",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(Icons.calendar_today, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 16.0),

            // To Date
            const Text('To'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: toDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        // Verificar si la toDate es anterior a la fromDate
                        if (fromDate != null && picked.isBefore(fromDate!)) {
                          // Mostrar el AlertDialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Range Dates'),
                                content: const SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('The From date is after the To date'),
                                      Text('Please, select a new range'),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Accept'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Si la fecha es válida, actualizar el estado
                          setState(() {
                            toDate = picked;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        toDate != null
                            ? "${toDate!.month}/${toDate!.day}/${toDate!.year}"
                            : "Select Date",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(Icons.calendar_today, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 16.0),

            // Weekdays
            const Text('Weekdays'),
            const SizedBox(height: 8.0),
            WeekdaySelector(
              selectedFillColor: Colors.blue,
              onChanged: (int dayIndex) {
                setState(() {
                  final index = (dayIndex) % 7;
                  selectedWeekdays[index] = !selectedWeekdays[index];
                });
              },
              values: selectedWeekdays,
            ),
            const SizedBox(height: 32.0),

            const Text('From'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: fromTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          fromTime = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        fromTime != null
                            ? fromTime!.format(context)
                            : "Select Time",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(Icons.access_time, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 16.0),

            // To Time
            const Text('To'),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: toTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          toTime = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        toTime != null
                            ? toTime!.format(context)
                            : "Select Time",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(Icons.access_time, color: Colors.blue),
              ],
            ),
            const SizedBox(height: 32.0),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved')),
                  );
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
