import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:protectic/services/tts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/audio_voice_controls.dart';

class EntitiesScreen extends StatefulWidget {
  const EntitiesScreen({super.key});

  @override
  State<EntitiesScreen> createState() => _EntitiesScreenState();
}

class _EntitiesScreenState extends State<EntitiesScreen> {
  Map<String, dynamic> data = {};
  bool isLoading = true;
  String? selectedCountry;
  String? selectedCategory;
  String searchQuery = '';
  List<bool> expandedStates = [];
  String _audioText = '';
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final jsonString = await rootBundle.loadString('data/entities.json');
      setState(() {
        data = json.decode(jsonString);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  int _entityCount() {
    if (selectedCountry == null || selectedCategory == null) return 0;
    final list = data[selectedCountry]?[selectedCategory];
    return list?.length ?? 0;
  }

  List<dynamic> get _filteredEntities {
    if (selectedCountry == null || selectedCategory == null) return [];
    final list = data[selectedCountry]?[selectedCategory] ?? [];
    if (searchQuery.isEmpty) return list;
    return list
        .where(
          (e) => e['nombre'].toString().toLowerCase().contains(
            searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  String _describeEntity(dynamic e) {
    final buffer = StringBuffer()
      ..writeln(e['nombre'])
      ..writeln('Web: ${e['web']}');
    for (final c in e['contacto']) buffer.writeln(c);
    return buffer.toString();
  }

  String _normalize(String s) {
    const withDiacritics = 'áàäâãéèëêíìïîóòöôõúùüûñ';
    const without = 'aaaaaeeeeiiiiooooouuuun';
    for (int i = 0; i < withDiacritics.length; i++) {
      s = s.replaceAll(withDiacritics[i], without[i]);
    }
    return s.toLowerCase().trim();
  }

  void _handleVoiceCommand(String cmd) async {
    cmd = _normalize(cmd);

    if (cmd == 'instrucciones') {
      await _ttsService.speak(
        'Usa los siguientes comandos de voz: '
        'Di "país" seguido del nombre del país, por ejemplo, "país México". '
        'Di "categoría" seguido de bancos, telefonía o entidades, por ejemplo, "categoría bancos". '
        'Di "buscar" seguido del nombre a buscar, por ejemplo, "buscar Banco Azteca". '
        'Di "seleccionar" seguido del nombre de la entidad, por ejemplo, "seleccionar Banco Azteca". '
        'Di "leer" para escuchar la información de la entidad seleccionada.',
      );
      return;
    }

    if (cmd.startsWith('pais ') || cmd.startsWith('país ')) {
      final spoken = cmd.replaceFirst(RegExp(r'^pais\s'), '').trim();
      final match = data.keys.firstWhere(
        (c) => _normalize(c).contains(spoken),
        orElse: () => '',
      );

      if (match.isNotEmpty) {
        setState(() {
          selectedCountry = match;
          selectedCategory = null;
          searchQuery = '';
          expandedStates = List<bool>.filled(_entityCount(), false);
        });
        await _ttsService.speak('País cambiado a $match');
      } else {
        await _ttsService.speak('País no encontrado. Intenta de nuevo.');
      }
      return;
    }

    if (cmd.startsWith('categoria ') || cmd.startsWith('categoría ')) {
      final spoken = cmd.replaceFirst(RegExp(r'^categoria\s'), '').trim();
      const categorias = {
        'bancos': ['bancos', 'banco'],
        'telefonia': ['telefonia', 'teléfonía', 'telefono', 'teléfono'],
        'entidades': [
          'entidades',
          'entidades estatales',
          'estatal',
          'estatales',
        ],
      };

      String? match;
      for (var entry in categorias.entries) {
        if (entry.value.any((v) => _normalize(v).contains(spoken))) {
          match = entry.key;
          break;
        }
      }

      if (match != null && match.isNotEmpty) {
        setState(() {
          selectedCategory = match;
          searchQuery = '';
          expandedStates = List<bool>.filled(_entityCount(), false);
        });
        await _ttsService.speak('Categoría cambiada a $match');
      } else {
        await _ttsService.speak(
          'Categoría no encontrada. Intenta con bancos, telefonía o entidades.',
        );
      }
      return;
    }

    if (cmd.startsWith('buscar ')) {
      final term = cmd.replaceFirst('buscar ', '').trim();
      if (term.isEmpty) {
        await _ttsService.speak(
          'Por favor, especifica un término de búsqueda.',
        );
        return;
      }
      setState(() {
        searchQuery = term;
        expandedStates = List<bool>.filled(_entityCount(), false);
      });
      await _ttsService.speak('Buscando $term');
      return;
    }

    if (cmd == 'leer') {
      if (_audioText.isEmpty) {
        await _ttsService.speak(
          'No hay texto para leer. Selecciona una entidad primero.',
        );
      } else {
        await _ttsService.speak(_audioText);
      }
      return;
    }

    if (cmd.startsWith('seleccionar ')) {
      final nombre = cmd.replaceFirst('seleccionar ', '').trim();
      if (nombre.isEmpty) {
        await _ttsService.speak(
          'Por favor, especifica el nombre de la entidad.',
        );
        return;
      }

      final i = _filteredEntities.indexWhere(
        (e) => _normalize(e['nombre']).contains(nombre),
      );

      if (i != -1) {
        setState(() {
          expandedStates = List<bool>.filled(_entityCount(), false);
          expandedStates[i] = true;
          _audioText = _describeEntity(_filteredEntities[i]);
        });
        await _ttsService.speak(
          'Seleccionado ${_filteredEntities[i]['nombre']}',
        );
      } else {
        await _ttsService.speak(
          'Entidad no encontrada. Intenta con otro nombre.',
        );
      }
      return;
    }

    await _ttsService.speak(
      'Comando no reconocido. Intenta con país, categoría, buscar, leer, seleccionar o instrucciones.',
    );
  }

  Widget _buildEntityCard(dynamic entity, int index) {
    final isExpanded = expandedStates[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          setState(() {
            expandedStates[index] = !isExpanded;
            if (!isExpanded) {
              _audioText = _describeEntity(entity);
            }
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isExpanded && entity['logo'] != null)
                Row(
                  children: [
                    Image.asset(entity['logo'], width: 100, height: 100),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        entity['nombre'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              if (isExpanded) ...[
                if (entity['logo'] != null)
                  Center(
                    child: Image.asset(entity['logo'], width: 160, height: 160),
                  ),
                const SizedBox(height: 16),
                Text(
                  entity['nombre'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse(entity['web']),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(
                    entity['web'],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...List<Widget>.from(
                  (entity['contacto'] as List<dynamic>).map((c) {
                    final parts = c.toString().split(':');
                    final label = parts.length > 1
                        ? parts[0].trim()
                        : 'Contacto';
                    final value = parts.length > 1 ? parts[1].trim() : parts[0];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$label: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: value,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F4D3);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black, size: 32),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double maxWidth = kIsWeb && constraints.maxWidth > 800
                        ? 800
                        : constraints.maxWidth < 600
                        ? constraints.maxWidth
                        : 600;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedCountry,
                              menuMaxHeight: 300,
                              decoration: _decoration('Selecciona el país'),
                              style: _dropStyle(),
                              dropdownColor: Colors.white,
                              items: data.keys
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(p),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  selectedCountry = value;
                                  selectedCategory = null;
                                  searchQuery = '';
                                  expandedStates = List<bool>.filled(
                                    _entityCount(),
                                    false,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: selectedCategory,
                              menuMaxHeight: 300,
                              decoration: _decoration(
                                'Selecciona la categoría',
                              ),
                              style: _dropStyle(),
                              dropdownColor: Colors.white,
                              items: const [
                                DropdownMenuItem(
                                  value: 'bancos',
                                  child: Text('Bancos'),
                                ),
                                DropdownMenuItem(
                                  value: 'telefonia',
                                  child: Text('Telefonía'),
                                ),
                                DropdownMenuItem(
                                  value: 'entidades',
                                  child: Text('Entidades Estatales'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  selectedCategory = value;
                                  searchQuery = '';
                                  expandedStates = List<bool>.filled(
                                    _entityCount(),
                                    false,
                                  );
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Buscar por nombre',
                                labelStyle: const TextStyle(fontSize: 22),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.search, size: 28),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                              style: const TextStyle(fontSize: 20),
                              onChanged: (value) => setState(() {
                                searchQuery = value;
                                expandedStates = List<bool>.filled(
                                  _entityCount(),
                                  false,
                                );
                              }),
                            ),
                            const SizedBox(height: 24),
                            if (selectedCountry != null &&
                                selectedCategory != null)
                              _filteredEntities.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Text(
                                        'No se encontraron resultados',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _filteredEntities.length,
                                      itemBuilder: (context, i) =>
                                          _buildEntityCard(
                                            _filteredEntities[i],
                                            i,
                                          ),
                                    ),
                            const SizedBox(height: 40),
                            AudioVoiceControls(
                              audioText: _audioText,
                              onVoiceCommand: _handleVoiceCommand,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  InputDecoration _decoration(String label) => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    labelText: label,
    labelStyle: const TextStyle(fontSize: 22),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  TextStyle _dropStyle() =>
      const TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'Roboto');
}
