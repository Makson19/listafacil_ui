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
          'Você voltará para a tela de login e a lista desta sessão será descartada.'
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
        ]
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
      itens.add(resultado);
      mostrarMensagem('"${resultado.nome}" foi adicionado à lista.');
    } else {
      itens.add(resultado);
      mostrarMensagem('Item atualizado com sucesso.');
    }
  }

  void removerItem(ItemCompra item) {
    itens.removeWhere((i) => i.id == item.id);
  }

  void marcarTodos() {

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas compras'),
        backgroundColor: Colors.white,
        actions: [
          // PopupMenuButton(
          //   tooltip: 'Mais opções',
          //   icon: const Icon(Icons.more_vert_rounded),
          //   onSelected: (_) => {},
          //   itemBuilder: (_) => const [
          //     PopupMenuItem(
          //       value: 'marcar',
          //       child: Row(
          //         children: [
          //           Icon(Icons.done_all_rounded, size: 20),
          //           SizedBox(width: 10),
          //           Text('Marcar todos'),
          //         ]
          //       ),
          //     ),
          //     PopupMenuItem(
          //       value: 'desmarcar',
          //       child: Row(
          //         children: [
          //           Icon(Icons.remove_done_rounded, size: 20),
          //           SizedBox(width: 10),
          //           Text('Desmarcar todos'),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          IconButton(
            tooltip: 'Sair',
            onPressed: sair,
            icon: const Icon(Icons.logout_rounded)
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
                Expanded(
                  child: itens.isEmpty
                  ? NoEmptyItems(onAdd: () => abrirCadastro())
                  : ListView.separated(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: itens.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, indice) {
                      final item = itens[indice];
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => {},
                        child: ItemCompraTile(
                          item: item,
                          onAlternarSelecao: () => {},
                          onEditar: () => abrirCadastro(),
                          onRemover: () => {}
                        ),
                      );
                    }
                  )
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: itens.isEmpty
        ? null
        : FloatingActionButton.extended(
          onPressed: () => {},
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
        podeCalcular: itens.isEmpty,
        onCalcular: () => {},
      ),
    );
  }
}
