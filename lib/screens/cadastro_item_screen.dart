
import 'package:flutter/material.dart';
import 'package:listafacil/models/item_compra.dart';

class CadastroItemScreen extends StatefulWidget {
  const CadastroItemScreen({super.key, this.item});

  final ItemCompra? item;

  @override
  State<CadastroItemScreen> createState() => _CadastroItemScreenState();
}

class _CadastroItemScreenState extends State<CadastroItemScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TESTE')
      ),
    );
  }
}
