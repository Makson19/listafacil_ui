class ItemCompra {
  final String id;
  final String nome;
  final int quantidade;
  final double precoUnitario;
  final bool selecionado;

  const ItemCompra({
    required this.id,
    required this.nome,
    required this.quantidade,
    required this.precoUnitario,
    this.selecionado = false
  });
}
