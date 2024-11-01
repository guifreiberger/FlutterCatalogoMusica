import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Musica {
  String id;
  String titulo;
  String genero;
  String descricao;

  Musica({
    required this.id,
    required this.titulo,
    required this.genero,
    required this.descricao,
  });
}

class MusicaCatalogoApp extends StatelessWidget {
  const MusicaCatalogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Músicas',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1DB954),
        hintColor: const Color(0xFF1DB954),
      ),
      home: const MusicaCatalogoScreen(),
    );
  }
}

class MusicaCatalogoScreen extends StatefulWidget {
  const MusicaCatalogoScreen({super.key});

  @override
  _MusicaCatalogoScreenState createState() => _MusicaCatalogoScreenState();
}

class _MusicaCatalogoScreenState extends State<MusicaCatalogoScreen> {
  final List<Musica> musicas = [];
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarMusicas();
  }

  void _carregarMusicas() async {
    final snapshot = await FirebaseFirestore.instance.collection('musicas').get();
    
    setState(() {
      musicas.clear();
      for (var doc in snapshot.docs) {
        var data = doc.data();
        musicas.add(
          Musica(
            id: doc.id,
            titulo: data['titulo'] ?? '',
            genero: data['genero'] ?? '',
            descricao: data['descricao'] ?? '',
          ),
        );
      }
    });
  }

  void adicionarMusica() async {
    final novaMusica = Musica(
      id: '',
      titulo: tituloController.text,
      genero: generoController.text,
      descricao: descricaoController.text,
    );

    final docRef = await FirebaseFirestore.instance.collection('musicas').add({
      'titulo': novaMusica.titulo,
      'genero': novaMusica.genero,
      'descricao': novaMusica.descricao,
    });

    setState(() {
      novaMusica.id = docRef.id;
      musicas.add(novaMusica);
      _limparCampos();
    });

    Navigator.of(context).pop();
  }

  void _limparCampos() {
    tituloController.clear();
    generoController.clear();
    descricaoController.clear();
  }

  void _abrirPopupAdicionarMusica() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Adicionar Nova Música',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _camposFormulario(),
            ),
          ),
          actions: _botoesPopup(adicionarMusica),
        );
      },
    );
  }

  void _abrirPopupEditarMusica(int index) {
  final musica = musicas[index];

  tituloController.text = musica.titulo;
  generoController.text = musica.genero;
  descricaoController.text = musica.descricao;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Editar Música', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _camposFormulario(),
          ),
        ),
        actions: _botoesPopup(() {
          _editarMusica(musica.id); 
        }),
      );
    },
  );
}

  void _editarMusica(String id) async {
  await FirebaseFirestore.instance.collection('musicas').doc(id).update({
    'titulo': tituloController.text,
    'genero': generoController.text,
    'descricao': descricaoController.text,
  });

  setState(() {
    final index = musicas.indexWhere((musica) => musica.id == id);
    if (index != -1) {
      musicas[index] = Musica(
        id: id,
        titulo: tituloController.text,
        genero: generoController.text,
        descricao: descricaoController.text,
      );
    }
  });

  Navigator.of(context).pop();
  _limparCampos();
}

  List<Widget> _camposFormulario() {
    return [
      TextField(
        controller: tituloController,
        decoration: const InputDecoration(
          labelText: 'Nome da Música',
          labelStyle: TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
      ),
      TextField(
        controller: generoController,
        decoration: const InputDecoration(
          labelText: 'Gênero Musical',
          labelStyle: TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
      ),
      TextField(
        controller: descricaoController,
        decoration: const InputDecoration(
          labelText: 'Por que é importante?',
          labelStyle: TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    ];
  }

  List<Widget> _botoesPopup(VoidCallback onConfirm) {
    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DB954),
        ),
        onPressed: onConfirm,
        child: const Text('Salvar'),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
      ),
    ];
  }

  void excluirMusica(String id) async {
    await FirebaseFirestore.instance.collection('musicas').doc(id).delete();
    setState(() {
      musicas.removeWhere((musica) => musica.id == id);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Músicas Favoritas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _abrirPopupAdicionarMusica,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: musicas.length,
                itemBuilder: (context, index) {
                  final musica = musicas[index];
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text(
                        musica.titulo,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Gênero: ${musica.genero}\n'
                        'Descrição: ${musica.descricao}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _abrirPopupEditarMusica(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                excluirMusica(musica.id),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1DB954),
        onPressed: _abrirPopupAdicionarMusica,
        child: const Icon(Icons.add),
      ),
    );
  }
}
