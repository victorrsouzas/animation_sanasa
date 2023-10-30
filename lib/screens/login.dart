import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animation_sanasa/screens/selected_code.dart';
import 'package:animation_sanasa/themes/theme_colors.dart';
import 'package:animation_sanasa/utils/env.dart';
import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late Uri _keycloakUri;
  late String _clientId;
  late String _clientSecret;
  late List<String> _scopes;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool tokenValid = true;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _initializeValues() async {
    await Env.storeKeycloakUri();
    await Env.storeClientId();
    await Env.storeClientSecret();
    await Env.storeScopes();

    String? keycloakUriStr = await Env.getKeycloakUri();

    if (keycloakUriStr != null) {
      _keycloakUri = Uri.parse(keycloakUriStr);
    }
    String? clientIdStr = await Env.getClientId();

    if (clientIdStr != null) {
      _clientId = clientIdStr;
    }

    String? clientSecretStr = await Env.getClientSecret();

    if (clientSecretStr != null) {
      _clientSecret = clientSecretStr;
    }
    List<String>? scopesList = await Env.getScopes();

    if (scopesList != null) {
      _scopes = scopesList;
    }
    setState(() {}); // Atualiza o estado após obter os valores

    _checkToken();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = result;
    });

    // Verifique a conectividade novamente após um pequeno atraso
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted) {
          setState(
            () {
              _connectionStatus = result;
            },
          );
        }
      },
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          elevation: 5,
          backgroundColor: ThemeColors.primary,
          content: Text('Sem conexão com a Internet'),
        ),
      );
    }
  }

  Future<bool> isTokenValidWithKeycloak(String token) async {
    final response = await http.post(
      Uri.parse(
          'https://sso.sanasa.com.br/realms/dev/protocol/openid-connect/token/introspect'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': token,
        'client_id': _clientId,
        'grant_type': 'authorization_code',
        'client_secret': _clientSecret
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['active'] ?? false;
    }

    return false;
  }

  Future<void> _checkToken() async {
    final token = await Env.getToken();
    final tokenExpiresString = await Env.getTokenExp();

    if (token != null &&
        token.isNotEmpty &&
        tokenExpiresString != null &&
        tokenExpiresString.isNotEmpty) {
      final tokenExpires = DateTime.parse(tokenExpiresString);
      final now = DateTime.now();
      final isValid = await isTokenValidWithKeycloak(token);

      if (tokenExpires.isAfter(now) && isValid) {
        // O token ainda não expirou
        await Env.storeToken(token);
        Map<String, dynamic> decodedPayload = decodeJWT(token.toString());
        await Env.storeDecodedToken(decodedPayload);
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => const SelectedCode(),
              ),
            );
          },
        );
        setState(() {});
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          tokenValid = false;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              elevation: 5,
              backgroundColor: ThemeColors.primary,
              content: Text(
                  'Token Expirado, Aguarde o redirecionamento para tela de Login'),
            ),
          );
          Timer(const Duration(seconds: 3), () {
            logout(context);
          });
          tokenValid = true;

          /* authenticate(
              _keycloakUri, _clientId, _clientSecret, _scopes, context); */
        });
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/image/background.png'), // Caminho para a imagem de fundo
          fit: BoxFit.cover, // Ajuste a imagem para cobrir todo o espaço
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.7,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/sanasa_logo.png',
                  width: screenWidth * 0.45,
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: SizedBox(
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Olá, Seja bem-vindo!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(ThemeColors.secondValue),
                            fontSize: 22,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                            height: 20), // Espaçamento entre os textos
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Para acessar os serviços da SANASA, clique no botão abaixo para fazer o login.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(ThemeColors.textColorCard),
                              fontSize: 12,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Spacer(), // Espaçamento antes do botão
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.06,
                            child: ElevatedButton(
                              onPressed: () async {
                                _updateConnectionStatus(_connectionStatus);
                                // Continua com a autenticação se houver conexão
                                setState(() {
                                  if (tokenValid) {
                                    authenticate(_keycloakUri, _clientId,
                                        _clientSecret, _scopes, context);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Entrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Versão 1.0.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(ThemeColors.textColorCard),
                            fontSize: 12,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<TokenResponse> authenticate(Uri uri, String clientId,
    String clientSecret, List<String> scopes, BuildContext context) async {
  await Env.deleteCredentials();
  await Env.deleteToken();
  await Env.deleteDecodedToken();
  await Env.deleteTokenExp();
  try {
    var issuer = await Issuer.discover(uri);
    var client = Client(issuer, clientId, clientSecret: clientSecret);

    urlLauncher(String url) async {
      Uri uri = Uri.parse(url);
      if (!await canLaunchUrl(uri) || await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
              headers: <String, String>{'my_header_key': 'my_header_value'}),
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    var authenticator = Authenticator(
      client,
      scopes: scopes,
      urlLancher: urlLauncher,
      // Adicione um redirectUri específico se necessário
      //redirectUri: Uri.parse('http://localhost:3000/'),
    );

    var c = await authenticator.authorize();
    // Chame closeInAppWebView() logo após a autorização para garantir que
    // o WebView seja fechado no momento apropriado
    closeInAppWebView();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => const SelectedCode(),
        ),
      );
    });

    String credentialJson = jsonEncode(c.toJson());
    await Env.storeCredentials(credentialJson);

    var res = await c.getTokenResponse();
    authToken(res.accessToken.toString(), res.expiresAt.toString());

    logoutUrl = c.generateLogoutUrl();

    return res;
  } finally {
    // Certifique-se de que o WebView seja fechado no final, independentemente do resultado
    closeInAppWebView();
  }
}

Map<String, dynamic> decodeJWT(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Token inválido');
  }
  final payload = parts[1];
  final String decoded =
      utf8.decode(base64Url.decode(base64Url.normalize(payload)));
  final Map<String, dynamic> payloadMap = jsonDecode(decoded);
  return payloadMap;
}

Future<void> logout(BuildContext context) async {
  String? credentialJson = await Env.getCredentials();

  Uri? logoutUrl2;

  if (credentialJson != null) {
    Credential credential = Credential.fromJson(jsonDecode(credentialJson));
    logoutUrl2 = credential.generateLogoutUrl();
  }

  if (logoutUrl2 != null) {
    if (!await canLaunchUrl(logoutUrl2) || await canLaunchUrl(logoutUrl2)) {
      await launchUrl(logoutUrl2,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            headers: <String, String>{'my_header_key': 'my_header_value'},
          ));
      await Env.deleteCredentials();
      await Env.deleteToken();
      await Env.deleteDecodedToken();
      await Env.deleteTokenExp();
      Timer(const Duration(seconds: 2), () {
        closeInAppWebView();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (ctx) => const Login(),
            ),
          );
        });
      });
    } else {
      throw 'Could not launch $logoutUrl';
    }
  }
}

void authToken(String token, String expiresToken) async {
  /* final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  await prefs.setString('tokenExp', expiresToken); */
  await Env.storeToken(token);
  await Env.storeTokenExp(expiresToken);
  Map<String, dynamic> decodedPayload = decodeJWT(token.toString());
  await Env.storeDecodedToken(decodedPayload);
}

Uri? logoutUrl;
