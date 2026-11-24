import 'package:listafacil/models/item_compra.dart';

/// Formata um valor em reais no padrão brasileiro: `R$ 1.234,50`.

String formatarMoeda(double valor) {
  final negativo = valor < 0;
  final partes = valor.abs().toStringAsFixed(2).split('.');
  final inteiro = partes[0];
  final centavos = partes[1];

  final comMilhar = StringBuffer();
  for (var i = 0; i < inteiro.length; i++) {
    comMilhar.write(inteiro[i]);
    final restantes = inteiro.length - i - 1;
    if (restantes > 0 && restantes % 3 == 0) {
      comMilhar.write('.');
    }
  }

  return '${negativo ? '-' : ''}R\$ $comMilhar,$centavos';
}

double? converterPreco(String texto) {
  var limpo = texto.trim().replaceAll('R\$', '').replaceAll(' ', '');
  if (limpo.isEmpty) return null;

  if (limpo.contains(',')) {
    limpo = limpo.replaceAll('.', '').replaceAll(',', '.');
  }

  return double.tryParse(limpo);
}

double getTotal(List<ItemCompra> items) {
  double total = items.fold<double>(0.0, (acc, item) => acc + (item.precoUnitario * item.quantidade));
  return total;
}

double getTotalMarcado(List<ItemCompra> items) {
  double total = items.fold<double>(0.0, (acc, item) => item.selecionado ? (acc + (item.precoUnitario * item.quantidade)) : acc + 0);
  return total;
}

double getTotalNaoMarcado(List<ItemCompra> items) {
  double total = items.fold<double>(0.0, (acc, item) => !item.selecionado ? (acc + (item.precoUnitario * item.quantidade)) : acc + 0);
  return total;
}
