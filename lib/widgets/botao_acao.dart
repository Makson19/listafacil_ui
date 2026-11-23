import 'package:flutter/material.dart';

class BotaoAcao extends StatelessWidget {
  const BotaoAcao({
    super.key,
    required this.icone,
    required this.tooltip,
    required this.aoTocar,
    required this.cor,
  });

  final IconData icone;
  final String tooltip;
  final VoidCallback aoTocar;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: aoTocar,
      tooltip: tooltip,
      icon: Icon(icone, size: 20),
      style: IconButton.styleFrom(
        foregroundColor: cor,
        backgroundColor: cor.withValues(alpha: 0.09),
        minimumSize: const Size(38, 38),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),
      ),
    );
  }
}
