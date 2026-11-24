import 'package:flutter/material.dart';
import 'package:listafacil/utils/functions.dart';

import '../theme/app_theme.dart';

class BarraTotal extends StatelessWidget {
  const BarraTotal({super.key, 
    required this.total,
    required this.podeCalcular,
    required this.onCalcular,
  });

  final double total;
  final bool podeCalcular;
  final VoidCallback onCalcular;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppTheme.borda)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total geral',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppTheme.textoSecundario,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formatarMoeda(total),
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: podeCalcular ? onCalcular : null,
              icon: const Icon(Icons.receipt_long_rounded, size: 20),
              label: const Text('Calcular total'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 50),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
