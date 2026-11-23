import 'package:flutter/material.dart';
import 'package:listafacil/theme/app_theme.dart';

class NoEmptyItems extends StatelessWidget {
  const NoEmptyItems({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppTheme.primaria.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket_outlined,
                size: 42,
                color: AppTheme.primaria
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Sua lista está vazia',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: AppTheme.textoSecundario,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Adicione o primeiro item e comece a organizar suas compras.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: AppTheme.textoSecundario,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Adicionar item')
            ),
          ],
        ),
      ),
    );
  }
}