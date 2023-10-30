class Debito {
  final String debitoId;
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
      debitoId: json['debitoId'] ?? '',
      mes: json['mes'] ?? '',
      ano: json['ano'] ?? '',
      valor: json['valor'] ?? '',
      dataVencimento: DateTime.parse(json['dataVencimento'] ?? ''),
      cpfCnpj: json['cpfCnpj'] ?? '',
      codigoConsumidor: json['codigoConsumidor'] ?? '',
    );
  }
}
