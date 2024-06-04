import 'package:centaur_flutter/models/carpeta_model.dart';
import 'package:flutter/material.dart';

class TicketFolderPage extends StatefulWidget{
  Carpeta folder;
  TicketFolderPage({Key? key, required this.folder })  : super(key: key);
  @override
   _TicketFolderState createState() => _TicketFolderState(folder);
}

class _TicketFolderState  extends State<TicketFolderPage>{
  late Carpeta folder;
  _TicketFolderState(folder);

  @override
  void initState() {
    super.initState();
    folder = widget.folder;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
