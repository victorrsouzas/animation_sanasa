class Conta {
  final String contaId;
  final String codigoConsumidor;
  final String nomeConsumidor;
  final String logradouro;
  final String numero;
  final String tipoLogradouro;
  final String bairro;

  Conta({
    required this.contaId,
    required this.codigoConsumidor,
    required this.nomeConsumidor,
    required this.logradouro,
    required this.numero,
    required this.tipoLogradouro,
    required this.bairro,
  });

  factory Conta.fromJson(Map<String, dynamic> json) {
    return Conta(
      contaId: json['contaId'] ?? '',
      codigoConsumidor: json['codigoConsumidor'] ?? '',
      nomeConsumidor: json['nomeConsumidor'] ?? '',
      logradouro: json['logradouro'] ?? '',
      numero: json['numero'] ?? '',
      tipoLogradouro: json['tipoLogradouro'] ?? '',
      bairro: json['bairro'] ?? '',
    );
  }
}
