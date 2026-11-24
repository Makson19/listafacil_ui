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

  ItemCompra copyWith({
    String? nome,
    int? quantidade,
    double? precoUnitario,
    bool? selecionado,
  }) {
    return ItemCompra(
      id: id,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      precoUnitario: precoUnitario ?? this.precoUnitario,
      selecionado: selecionado ?? this.selecionado,
    );
  }
}
