class Debito {
  final int debitoId; // Change the type to int
  final int mes;
  final int ano;
  final double valor;
  final DateTime dataVencimento;
  final String cpfCnpj;
  final String codigoConsumidor;

  Debito({
    required this.debitoId,
    required this.mes,
    required this.ano,
    required this.valor,
    required this.dataVencimento,
    required this.cpfCnpj,
    required this.codigoConsumidor,
  });

  factory Debito.fromJson(Map<String, dynamic> json) {
    return Debito(
      debitoId: json['debitoId'] as int, // Cast to int
      mes: json['mes'] as int, // Cast to int for safety
      ano: json['ano'] as int, // Cast to int for safety
      valor: json['valor'].toDouble(), // Convert to double for safety
      dataVencimento: DateTime.parse(json['dataVencimento']),
      cpfCnpj: json['cpfCnpj'] as String,
      codigoConsumidor: json['codigoConsumidor'] as String,
    );
  }
}
