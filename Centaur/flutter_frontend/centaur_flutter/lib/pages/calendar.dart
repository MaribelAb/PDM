import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const Calendar());

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: DatePickerExample(),
    );
  }
}

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime dateStart = DateTime(2022, 10, 26);
  DateTime dateEnd = DateTime(2022, 10, 26);
  DateTime timeStart = DateTime(2022, 10, 26, 22, 35);
  DateTime timeEnd = DateTime(2022, 10, 26, 23, 35);
  TextEditingController titulo = TextEditingController();
  TextEditingController descripcion = TextEditingController();

  

  DateTime combineDateAndTime(DateTime date, DateTime time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
      time.millisecond,
      time.microsecond,
    );
  }

  Future<void> _insertEvent() async {
    DateTime eventStart = combineDateAndTime(dateStart, timeStart);
    DateTime eventEnd = combineDateAndTime(dateEnd, timeEnd);
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: '222434467989-s47v1e75pho0ec2ut0qc3uqhq1r2ttg5.apps.googleusercontent.com',
      scopes: [
        'email',
        'https://www.googleapis.com/auth/calendar.events',
      ],
    );


    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }
      final googleAuth = await googleUser.authentication;

      final authClient = auth.authenticatedClient(
        http.Client(),
        auth.AccessCredentials(
          auth.AccessToken(
            'Bearer',
            googleAuth.accessToken!,
            DateTime.now().add(Duration(hours: 1)),  // token expiration time
          ),
          null,  // No refresh token available
          [CalendarApi.calendarEventsScope],
        ),
      );

      final calendar = CalendarApi(authClient);

      Event event = Event()
        ..summary = titulo.text
        ..description = descripcion.text
        ..start = EventDateTime(
          dateTime: eventStart,
          timeZone: "GMT-7:00",
        )
        ..end = EventDateTime(
          dateTime: eventEnd,
          timeZone: "GMT-7:00",
        );
      if(!event.start!.dateTime!.isBefore(event.end!.dateTime!)){
        showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          alignment: Alignment.center,
                          height: 200,
                          width: 250,
                          decoration: const BoxDecoration(),
                          child: Text('¡Un evento no puede empezar después de que haya acabado!'),
                        ),
                      );
                    },
                  );
                  return;
      }
      String calendarId = "primary";
      await calendar.events.insert(event, calendarId);
      print("Event added to Google Calendar");
    } catch (e) {
      print("Error adding event to Google Calendar: $e");
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('CupertinoDatePicker Sample'),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoColors.label.resolveFrom(context),
          fontSize: 22.0,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Text('Nombre del evento:'),
                  Expanded(
                    child: CupertinoTextField(
                      controller: titulo,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Descripción del evento:'),
                  Expanded(
                    child: CupertinoTextField(
                      controller: descripcion,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      placeholder: 'Enter your text here',
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _DatePickerItem(
                children: <Widget>[
                  const Text('Fecha de inicio'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: dateStart,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        showDayOfWeek: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => dateStart = newDate);
                        },
                      ),
                    ),
                    child: Text(
                      '${dateStart.month}-${dateStart.day}-${dateStart.year}',
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
              _DatePickerItem(
                children: <Widget>[
                  const Text('Fecha de finalización'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: dateEnd,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        showDayOfWeek: true,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => dateEnd = newDate);
                        },
                      ),
                    ),
                    child: Text(
                      '${dateEnd.month}-${dateEnd.day}-${dateEnd.year}',
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
              _DatePickerItem(
                children: <Widget>[
                  const Text('Hora de inicio'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: timeStart,
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() => timeStart = newTime);
                        },
                      ),
                    ),
                    child: Text(
                      '${timeStart.hour}:${timeStart.minute}',
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
              _DatePickerItem(
                children: <Widget>[
                  const Text('Hora de finalización'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: timeEnd,
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() => timeEnd = newTime);
                        },
                      ),
                    ),
                    child: Text(
                      '${timeEnd.hour}:${timeEnd.minute}',
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              ElevatedButton(
                onPressed: () {
                  _insertEvent();
                },
                child: const Text('Programar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
