import 'package:flutter/material.dart';
import 'package:listafacil/models/item_compra.dart';
import 'package:listafacil/theme/app_theme.dart';
import 'package:listafacil/utils/formato.dart';
import 'package:listafacil/widgets/botao_acao.dart';

class ItemCompraTile extends StatelessWidget {
  const ItemCompraTile({
    super.key,
    required this.item,
    required this.onAlternarSelecao,
    required this.onEditar,
    required this.onRemover,
  });

  final ItemCompra item;
  final VoidCallback onAlternarSelecao;
  final VoidCallback onEditar;
  final VoidCallback onRemover;

  @override
  Widget build(BuildContext context) {
    final marcado = item.selecionado;
    final double subtotal = item.quantidade * item.precoUnitario;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsetsGeometry.fromLTRB(8, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: marcado
              ? AppTheme.primaria.withValues(alpha: 0.35)
              : AppTheme.borda,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: marcado,
            onChanged: (_) => onAlternarSelecao(),
            semanticLabel: 'Marcar ${item.nome} como comprado',
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: marcado ? AppTheme.textoSecundario : AppTheme.texto,
                    decoration: marcado ? TextDecoration.lineThrough : null,
                    decorationColor: AppTheme.textoSecundario,
                  ),
                ),
                const SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.textoSecundario,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${item.quantidade} × ${formatarMoeda(item.precoUnitario)}  •  ',
                      ),
                      TextSpan(
                        text: formatarMoeda(subtotal),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: marcado
                              ? AppTheme.textoSecundario
                              : AppTheme.primaria,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          BotaoAcao(
            icone: Icons.edit_outlined,
            tooltip: 'Editar ${item.nome}',
            aoTocar: onEditar,
            cor: AppTheme.textoSecundario,
          ),
          const SizedBox(width: 6),
          BotaoAcao(
            icone: Icons.delete_outline_rounded,
            tooltip: 'Remover ${item.nome}',
            aoTocar: onRemover,
            cor: AppTheme.vermelho,
          ),
        ],
      ),
    );
  }
}
