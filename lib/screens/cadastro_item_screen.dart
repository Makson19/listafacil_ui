import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listafacil/models/item_compra.dart';
import 'package:listafacil/utils/functions.dart';

import '../theme/app_theme.dart';

class CadastroItemScreen extends StatefulWidget {
  const CadastroItemScreen({super.key, this.item});

  final ItemCompra? item;

  @override
  State<CadastroItemScreen> createState() => _CadastroItemScreenState();
}

class _CadastroItemScreenState extends State<CadastroItemScreen> {
  final formKey = GlobalKey<FormState>();

  late final TextEditingController nomeController;
  late final TextEditingController quantidadeController;
  late final TextEditingController precoController;

  bool get editando => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    nomeController = TextEditingController(text: item?.nome ?? '');
    quantidadeController = TextEditingController(
      text: item?.quantidade.toString() ?? '1',
    );
    precoController = TextEditingController(
      text: item == null
          ? ''
          : item.precoUnitario.toStringAsFixed(2).replaceAll('.', ','),
    );

    nomeController.addListener(_atualizarPreview);
    quantidadeController.addListener(_atualizarPreview);
    precoController.addListener(_atualizarPreview);
  }

  @override
  void dispose() {
    nomeController.dispose();
    quantidadeController.dispose();
    precoController.dispose();
    super.dispose();
  }

  void _atualizarPreview() => setState(() {});

  int get quantidadeAtual => int.tryParse(quantidadeController.text) ?? 0;

  double get precoAtual => converterPreco(precoController.text) ?? 0;

  double get subtotal => quantidadeAtual * precoAtual;

  void alterarQuantidade(int diferenca) {
    final novo = (quantidadeAtual + diferenca).clamp(1, 999);
    quantidadeController
      ..text = novo.toString()
      ..selection = TextSelection.collapsed(offset: novo.toString().length);
  }

  void salvar() {
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;

    final item = ItemCompra(
      id: widget.item?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      nome: nomeController.text.trim(),
      quantidade: int.parse(quantidadeController.text.trim()),
      precoUnitario: converterPreco(precoController.text)!,
      selecionado: widget.item?.selecionado ?? false,
    );

    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar item' : 'Novo item'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  const CabecalhoFormulario(),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nomeController,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nome do item',
                      hintText: 'Ex.: Leite integral 1L',
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                    validator: (valor) {
                      final nome = valor?.trim() ?? '';
                      if (nome.isEmpty) return 'Informe o nome do item';
                      if (nome.length < 2) return 'Nome muito curto';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: quantidadeController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'Quantidade',
                      hintText: '1',
                      prefixIcon: const Icon(Icons.numbers_rounded),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Diminuir quantidade',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => alterarQuantidade(-1),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          IconButton(
                            tooltip: 'Aumentar quantidade',
                            visualDensity: VisualDensity.compact,
                            onPressed: () => alterarQuantidade(1),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          const SizedBox(width: 6),
                        ],
                      ),
                    ),
                    validator: (valor) {
                      final numero = int.tryParse(valor?.trim() ?? '');
                      if (numero == null) return 'Informe a quantidade';
                      if (numero <= 0)
                        return 'A quantidade deve ser maior que zero';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                   TextFormField(
                    controller: precoController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    onFieldSubmitted: (_) => salvar(),
                    decoration: const InputDecoration(
                      labelText: 'Preço unitário',
                      hintText: '0,00',
                      prefixText: 'R\$ ',
                      prefixIcon: Icon(Icons.sell_outlined),
                    ),
                    validator: (valor) {
                      final preco = converterPreco(valor ?? '');
                      if (preco == null) return 'Informe o preço unitário';
                      if (preco <= 0) return 'O preço deve ser maior que zero';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  PreviewSubtotal(subtotal: subtotal),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton.icon(
                onPressed: salvar,
                icon: const Icon(Icons.check_rounded, size: 22),
                label: Text(
                  editando ? 'Salvar alterações' : 'Adicionar à lista',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CabecalhoFormulario extends StatelessWidget {
  const CabecalhoFormulario();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppTheme.primaria.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.post_add_rounded,
            color: AppTheme.primaria,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Preencha os dados do produto. O subtotal é calculado '
            'automaticamente.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: AppTheme.textoSecundario,
            ),
          ),
        ),
      ],
    );
  }
}


class PreviewSubtotal extends StatelessWidget {
  const PreviewSubtotal({required this.subtotal});

  final double subtotal;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaria.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaria.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calculate_outlined,
              color: AppTheme.primaria,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subtotal deste item',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppTheme.textoSecundario,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatarMoeda(subtotal),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppTheme.texto,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

