import 'package:flutter/material.dart';
import 'package:listafacil/models/item_compra.dart';
import 'package:listafacil/screens/cadastro_item_screen.dart';
import 'package:listafacil/screens/login_screen.dart';
import 'package:listafacil/theme/app_theme.dart';
import 'package:listafacil/utils/functions.dart';
import 'package:listafacil/widgets/barra_total.dart';
import 'package:listafacil/widgets/item_compra_tile.dart';
import 'package:listafacil/widgets/no_empty_items.dart';

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() => _ListaCompraScreenState();
}

class _ListaCompraScreenState extends State<ListaComprasScreen> {
  final List<ItemCompra> itens = [];

  void mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> sair() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da conta?'),
        content: const Text(
          'Você voltará para a tela de login e a lista desta sessão será descartada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 22),
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> abrirCadastro({ItemCompra? item}) async {
    final resultado = await Navigator.of(context).push<ItemCompra>(
      MaterialPageRoute<ItemCompra>(
        builder: (_) => CadastroItemScreen(item: item),
      ),
    );

    if (resultado == null || !mounted) return;

    if (item == null) {
      setState(() {
        itens.add(resultado);
      });
      mostrarMensagem('"${resultado.nome}" foi adicionado à lista.');
    } else {
      setState(() {
        final index = itens.indexWhere((i) => i.id == resultado.id);
        if (index == -1) return;
        itens[index] = resultado;
      });
      mostrarMensagem('Item atualizado com sucesso.');
    }
  }

  void removerItem(ItemCompra item) {
    setState(() {
      itens.removeWhere((i) => i.id == item.id);
    });
  }

  void alternarSelecao(ItemCompra item) {
    setState(() {
      final index = itens.indexWhere((i) => i.id == item.id);
      if (index == -1) return;
      itens[index] = itens[index].copyWith(
        selecionado: !itens[index].selecionado,
      );
    });
  }

  void marcarTodos(bool selecionado) {
    setState(() {
      for (var i = 0; i < itens.length; i++) {
        itens[i] = itens[i].copyWith(selecionado: selecionado);
      }
    });
  }

  Future<void> mostrarResumoTotal() async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => ResumoTotalSheet(itens: itens),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas compras'),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            tooltip: 'Mais opções',
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (valor) {
              marcarTodos(valor == 'marcar');
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'marcar',
                child: Row(
                  children: [
                    Icon(Icons.done_all_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('Marcar todos'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'desmarcar',
                child: Row(
                  children: [
                    Icon(Icons.remove_done_rounded, size: 20),
                    SizedBox(width: 10),
                    Text('Desmarcar todos'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: sair,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: itens.isEmpty
                      ? NoEmptyItems(onAdd: () => abrirCadastro())
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: itens.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, indice) {
                            final item = itens[indice];
                            return Dismissible(
                              key: ValueKey(item.id),
                              direction: DismissDirection.endToStart,
                              background: const FundoDeslizar(),
                              onDismissed: (_) => removerItem(item),
                              child: ItemCompraTile(
                                item: item,
                                onAlternarSelecao: () => alternarSelecao(item),
                                onEditar: () => abrirCadastro(item: item),
                                onRemover: () => removerItem(item),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: itens.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => abrirCadastro(),
              backgroundColor: AppTheme.primaria,
              foregroundColor: Colors.white,
              elevation: 2,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Novo item',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
      bottomNavigationBar: BarraTotal(
        total: getTotal(itens),
        podeCalcular: !itens.isEmpty,
        onCalcular: () => mostrarResumoTotal(),
      ),
    );
  }
}

class FundoDeslizar extends StatelessWidget {
  const FundoDeslizar();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.vermelho,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

class ResumoTotalSheet extends StatelessWidget {
  const ResumoTotalSheet({required this.itens});

  final List<ItemCompra> itens;

  @override
  Widget build(BuildContext context) {
    final marcados = itens.where((i) => i.selecionado).length;
    final totalItens = itens.length;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.primaria.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppTheme.primaria,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Resumo da compra',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                gradient: AppTheme.gradientePrimario,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total gasto na compra',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatarMoeda(getTotal(itens)),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalItens ${totalItens == 1 ? 'item' : 'itens'} • '
                    '$marcados ${marcados == 1 ? 'marcado' : 'marcados'}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            LinhaResumo(
              rotulo: 'Itens marcados',
              valor: '$marcados de $totalItens',
            ),
            const SizedBox(height: 14),
            LinhaResumo(
              rotulo: 'Valor já marcado',
              valor: formatarMoeda(getTotalMarcado(itens)),
            ),
            const SizedBox(height: 14),
            LinhaResumo(
              rotulo: 'Valor ainda a comprar',
              valor: formatarMoeda(getTotalNaoMarcado(itens)),
            ),
            const SizedBox(height: 22),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              marcados == 0
                  ? 'Marque os itens no checklist para acompanhar o valor '
                        'que já está no carrinho.'
                  : 'O subtotal de cada item é quantidade × preço unitário.',
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.45,
                color: AppTheme.textoSecundario,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}

class LinhaResumo extends StatelessWidget {
  const LinhaResumo({required this.rotulo, required this.valor});

  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            rotulo,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textoSecundario,
            ),
          ),
        ),
        Text(
          valor,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
