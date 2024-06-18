import 'package:centaur_flutter/api/auth/auth_api.dart';
import 'package:centaur_flutter/pages/index_page.dart';
import 'package:centaur_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart'; // Make sure you have this package in your pubspec.yaml
import 'package:centaur_flutter/pages/themenot.dart';
class Configuracion extends StatefulWidget{
  @override
  State<Configuracion> createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  @override
    bool _isDarkTheme = false;
  
  void _logout() async {
    // Implement your logout logic here
    await logout(); // Assuming you have a logout function in your auth API
    Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IndexPage()),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return Column(
            children: [
              Center(child: Text('Configuración', style: tituloStyle(context),)),
              Expanded(
                child: Container(
                  color: themeNotifier.isDarkTheme ? Colors.black : Colors.white,
                  child: SettingsList(
                    sections: [
                      SettingsSection(
                        title: Text('Common'),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: Icon(Icons.language),
                            title: Text('Idioma'),
                            value: Text('Español'),
                          ),
                          SettingsTile.switchTile(
                            onToggle: (value) {
                              themeNotifier.toggleTheme();
                            },
                            initialValue: themeNotifier.isDarkTheme,
                            leading: Icon(themeNotifier.isDarkTheme ? Icons.nights_stay : Icons.wb_sunny),
                            title: Text('Cambiar tema'),
                          ),
                          SettingsTile.navigation(
                            leading: Icon(Icons.logout),
                            title: Text('Cerrar Sesión'),
                            onPressed: (context) {
                              _logout();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}