import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

 

void main() {
  runApp(const GlicoCareApp());
}

class GlicoCareApp extends StatelessWidget {
  const GlicoCareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlicoCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> with TickerProviderStateMixin {
  String currentLanguage = 'pt';
  String currentScreen = 'welcome'; 

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  final TextEditingController _medReminderController = TextEditingController();
  final TextEditingController _stockDaysController = TextEditingController();

  final List<ChatMessage> _messages = [];
  bool _isDianaTyping = false;

  final Map<String, String> _registeredUsers = {
    'admin@eurofarma.com': '123456',
  };

  final String _groqApiKey = "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"; 

  @override
  void initState() {
    super.initState();
    _medReminderController.text = "Metformina às 20:00";
    _stockDaysController.text = "5";
    _resetChat();
  }

  Future<void> _launchEurofarmaUrl() async {
    final Uri url = Uri.parse('https://eurofarma.com.br/');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        _showSnackBar("Não foi possível abrir o site da Eurofarma.");
      }
    } catch (e) {
      _showSnackBar("Erro ao tentar abrir o link.");
    }
  }

  void _resetChat() {
    _messages.clear();
    _messages.add(ChatMessage(
      text: _getText('dianaGreeting'),
      isUser: false,
    ));
  }

  String _getText(String key) {
    final Map<String, Map<String, String>> localizedValues = {
      'pt': {
        'startBtn': 'INICIAR APLICATIVO',
        'welcomeMsg': 'Cuidado inteligente com a sua saúde.',
        'welcome': 'Bem-vindo de volta!',
        'subtitle': 'Faça login para acessar sua conta e falar com a Diana.',
        'sponsor': 'Patrocinado por Eurofarma',
        'signin': 'Entrar',
        'signup': 'Cadastrar',
        'userPlaceholder': 'Usuário ou e-mail',
        'namePlaceholder': 'Nome Completo',
        'passPlaceholder': 'Senha',
        'newHere': 'Novo por aqui?',
        'createAccount': 'Crie uma conta',
        'alreadyHaveAccount': 'Já tem uma conta?',
        'dianaTitle': 'Diana - Sua IA de Saúde',
        'dianaSub': 'Conectada aos dados confiáveis Eurofarma',
        'dianaChatPlaceholder': 'Pergunte algo sobre sua rotina ou diabetes...',
        'medReminder': 'Horário dos Remédios',
        'stockAlert': 'Alerta de Estoque',
        'stockSuffix': 'dias restantes. Hora de comprar!',
        'stockSafe': 'Estoque seguro para mais',
        'dianaGreeting': 'Olá! Sou a Diana, sua assistente GlicoCare da Eurofarma. Pode me perguntar qualquer coisa sobre diabetes, alimentação ou sua rotina!',
        'errorAuth': 'Usuário ou senha incorretos. Crie uma conta se for novo!',
        'errorEmpty': 'Por favor, preencha todos os campos.',
        'successRegister': 'Conta criada com sucesso! Faça o login.',
        'dianaThinking': 'Diana está digitando...',
        'notifTitle': 'Permitir Notificações?',
        'notifBody': 'O GlicoCare gostaria de enviar lembretes de medicamentos e alertas de estoque.',
        'allow': 'Permitir',
        'deny': 'Agora não',
      },
      'en': {
        'startBtn': 'START APPLICATION',
        'welcomeMsg': 'Intelligent care for your health.',
        'welcome': 'Welcome back!',
        'subtitle': 'Sign in to access your account and talk to Diana.',
        'sponsor': 'Sponsored by Eurofarma',
        'signin': 'Sign In',
        'signup': 'Sign Up',
        'userPlaceholder': 'Username or email',
        'namePlaceholder': 'Full Name',
        'passPlaceholder': 'Password',
        'newHere': 'New here?',
        'createAccount': 'Create an Account',
        'alreadyHaveAccount': 'Already have an account?',
        'dianaTitle': 'Diana - Your Health AI',
        'dianaSub': 'Connected to trusted Eurofarma data',
        'dianaChatPlaceholder': 'Ask something about your routine or diabetes...',
        'medReminder': 'Medication Schedule',
        'stockAlert': 'Stock Alert',
        'stockSuffix': 'days remaining. Time to buy!',
        'stockSafe': 'Stock safe for another',
        'dianaGreeting': 'Hello! I am Diana, your Eurofarma GlicoCare assistant. You can ask me anything about diabetes, diet, or your routine!',
        'errorAuth': 'Incorrect username or password. Create an account if you are new!',
        'errorEmpty': 'Please fill in all fields.',
        'successRegister': 'Account created successfully! Please log in.',
        'dianaThinking': 'Diana is typing...',
        'notifTitle': 'Allow Notifications?',
        'notifBody': 'GlicoCare would like to send you medication reminders and stock alerts.',
        'allow': 'Allow',
        'deny': 'Not now',
      },
      'es': {
        'startBtn': 'INICIAR APLICACIÓN',
        'welcomeMsg': 'Cuidado inteligente de tu salud.',
        'welcome': '¡Bienvenido de nuevo!',
        'subtitle': 'Inicie sesión para acceder a su cuenta y hablar con Diana.',
        'sponsor': 'Patrocinado por Eurofarma',
        'signin': 'Iniciar Sesión',
        'signup': 'Registrarse',
        'userPlaceholder': 'Usuario o correo electrónico',
        'namePlaceholder': 'Nombre Completo',
        'passPlaceholder': 'Contraseña',
        'newHere': '¿Nuevo por aquí?',
        'createAccount': 'Crea una cuenta',
        'alreadyHaveAccount': '¿Ya tienes una cuenta?',
        'dianaTitle': 'Diana - Tu IA de Salud',
        'dianaSub': 'Conectada a datos confiables de Eurofarma',
        'dianaChatPlaceholder': 'Pregunta algo sobre tu rutina o diabetes...',
        'medReminder': 'Horario de Medicamentos',
        'stockAlert': 'Alerta de Inventario',
        'stockSuffix': 'días restantes. ¡Hora de comprar!',
        'stockSafe': 'Inventario seguro por otros',
        'dianaGreeting': '¡Hola! Soy Diana, tu asistente GlicoCare de Eurofarma. ¡Puedes preguntarme cualquier cosa sobre diabetes, dieta o tu rutina!',
        'errorAuth': 'Usuario o contraseña incorrectos. ¡Crea una cuenta si eres nuevo!',
        'errorEmpty': 'Por favor, complete todos los campos.',
        'successRegister': '¡Cuenta creada con éxito! Por favor inicia sesión.',
        'dianaThinking': 'Diana está escribiendo...',
        'notifTitle': '¿Permitir Notificaciones?',
        'notifBody': 'A GlicoCare le gustaría enviarle recordatorios de medicamentos y alertas de stock.',
        'allow': 'Permitir',
        'deny': 'Ahora no',
      },
      'fr': {
        'startBtn': 'LANCER L\'APPLICATION',
        'welcomeMsg': 'Des soins intelligents pour votre santé.',
        'welcome': 'Bon retour !',
        'subtitle': 'Connectez-vous pour accéder à votre compte et parler à Diana.',
        'sponsor': 'Parrainé par Eurofarma',
        'signin': 'Se Connecter',
        'signup': 'S\'inscrire',
        'userPlaceholder': 'Identifiant ou e-mail',
        'namePlaceholder': 'Nom Complet',
        'passPlaceholder': 'Mot de passe',
        'newHere': 'Nouveau ici ?',
        'createAccount': 'Créer un compte',
        'alreadyHaveAccount': 'Vous avez déjà un compte ?',
        'dianaTitle': 'Diana - Votre IA Santé',
        'dianaSub': 'Connectée aux données fiables d\'Eurofarma',
        'dianaChatPlaceholder': 'Posez une question sur votre routine ou le diabète...',
        'medReminder': 'Rappel de Médicaments',
        'stockAlert': 'Alerte de Stock',
        'stockSuffix': 'jours restants. Il est temps d\'acheter !',
        'stockSafe': 'Stock sécurisé pour encore',
        'dianaGreeting': 'Bonjour ! Je suis Diana, votre assistante GlicoCare d\'Eurofarma. Vous pouvez me poser toutes vos questions sur le diabète, l\'alimentation ou votre routine !',
        'errorAuth': 'Identifiant ou mot de passe incorrect. Créez un compte si vous êtes nouveau !',
        'errorEmpty': 'Veuillez remplir tous les champs.',
        'successRegister': 'Compte créé avec succès ! Veuillez vous connecter.',
        'dianaThinking': 'Diana écrit...',
        'notifTitle': 'Autoriser les Notifications ?',
        'notifBody': 'GlicoCare souhaite vous envoyer des rappels de médicaments et des alertes de stock.',
        'allow': 'Autoriser',
        'deny': 'Pas maintenant',
      },
      'de': {
        'startBtn': 'ANWENDUNG STARTEN',
        'welcomeMsg': 'Intelligente Pflege für Ihre Gesundheit.',
        'welcome': 'Anwendung starten',
        'subtitle': 'Melden Sie sich an, um auf Ihr Konto zuzugreifen und mit Diana zu sprechen.',
        'sponsor': 'Gesponsert von Eurofarma',
        'signin': 'Einloggen',
        'signup': 'Registrieren',
        'userPlaceholder': 'Benutzername oder E-Mail',
        'namePlaceholder': 'Vollständiger Name',
        'passPlaceholder': 'Passwort',
        'newHere': 'Neu hier?',
        'createAccount': 'Konto erstellen',
        'alreadyHaveAccount': 'Haben Sie bereits ein Konto?',
        'dianaTitle': 'Diana - Ihre Gesundheits-KI',
        'dianaSub': 'Verbunden mit zuverlässigen Eurofarma-Daten',
        'dianaChatPlaceholder': 'Fragen Sie etwas über Ihre Routine oder Diabetes...',
        'medReminder': 'Medikamentenplan',
        'stockAlert': 'Bestandswarnung',
        'stockSuffix': 'Tage übrig. Zeit zu kaufen!',
        'stockSafe': 'Sicherer Bestand für weitere',
        'dianaGreeting': 'Hallo! Ich bin Diana, Ihre Eurofarma GlicoCare-Assistentin. Sie können mich alles über Diabetes, Ernährung oder Ihre Routine fragen!',
        'errorAuth': 'Falscher Benutzername oder falsches Passwort. Erstellen Sie ein Konto, wenn Sie neu sind!',
        'errorEmpty': 'Bitte füllen Sie alle Felder aus.',
        'successRegister': 'Konto erfolgreich erstellt! Bitte melden Sie sich an.',
        'dianaThinking': 'Diana schreibt...',
        'notifTitle': 'Benachrichtigungen erlauben?',
        'notifBody': 'GlicoCare möchte Ihnen Medikamentenerinnerungen und Bestandswarnungen senden.',
        'allow': 'Erlauben',
        'deny': 'Jetzt nicht',
      },
      'zh': {
        'startBtn': '启动应用程序',
        'welcomeMsg': '为您的健康提供智能守护。',
        'welcome': '欢迎回来！',
        'subtitle': '登录以访问您的账户并与 Diana 交谈。',
        'sponsor': '由 欧意药业 (Eurofarma) 赞助',
        'signin': '登录',
        'signup': '注册',
        'userPlaceholder': '用户名 or 电子邮件',
        'namePlaceholder': '全名',
        'passPlaceholder': '密码',
        'newHere': '第一次来这里？',
        'createAccount': '创建账户',
        'alreadyHaveAccount': '已经有账户了？',
        'dianaTitle': 'Diana - 您的健康 AI',
        'dianaSub': '连接至欧意药业可靠医疗数据',
        'dianaChatPlaceholder': '询问有关您的日常起居 or 糖尿病的问题...',
        'medReminder': '服药时间表',
        'stockAlert': '库存提醒',
        'stockSuffix': '天。该购买了！',
        'stockSafe': '库存安全还可以维持',
        'dianaGreeting': '您好！我是 Diana，您的欧意药业 GlicoCare 助手。您可以向我咨询任何关于糖尿病、饮食或日常生活的问题！',
        'errorAuth': '用户名或密码错误。如果您是新用户，请创建账户！',
        'errorEmpty': '请填写所有字段。',
        'successRegister': '账户创建成功！请登录。',
        'dianaThinking': 'Diana 正在输入...',
        'notifTitle': '允许发送通知？',
        'notifBody': 'GlicoCare 希望向您发送服药提醒和药品库存警告。',
        'allow': '允许',
        'deny': '暂不',
      }
    };
    return localizedValues[currentLanguage]?[key] ?? localizedValues['en']![key]!;
  }

  void _showNotificationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(_getText('notifTitle'), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff1e3a8a))),
          content: Text(_getText('notifBody')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar("Notificações desativadas.");
              },
              child: Text(_getText('deny'), style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSnackBar("Notificações ativadas com sucesso!");
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff1e3a8a)),
              child: Text(_getText('allow'), style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _handleLogin() {
    final user = _userController.text.trim();
    final password = _passwordController.text;

    if (user.isEmpty || password.isEmpty) {
      _showSnackBar(_getText('errorEmpty'));
      return;
    }

    if (_registeredUsers.containsKey(user) && _registeredUsers[user] == password) {
      setState(() {
        currentScreen = 'dashboard';
      });
      _userController.clear();
      _passwordController.clear();
    } else {
      _showSnackBar(_getText('errorAuth'));
    }
  }

  void _handleRegister() {
    final user = _userController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (user.isEmpty || password.isEmpty || name.isEmpty) {
      _showSnackBar(_getText('errorEmpty'));
      return;
    }

    setState(() {
      _registeredUsers[user] = password;
      currentScreen = 'login';
    });

    _showSnackBar(_getText('successRegister'));
    _passwordController.clear();
    _nameController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showNotificationPermissionDialog();
    });
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: const Color(0xff1e3a8a)),
    );
  }

  Future<void> _handleSendMessage() async {
    final String userText = _chatController.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _chatController.clear();
      _isDianaTyping = true;
    });
    _scrollToBottom();

    final Map<String, String> systemInstructions = {
      'pt': "Você é a Diana, uma IA integrada ao app GlicoCare da Eurofarma. Responda em português de forma acolhedora, inteligente e baseada em dados médicos confiáveis sobre diabetes.",
      'en': "You are Diana, an AI integrated into Eurofarma's GlicoCare app. Respond in English warmly, intelligently, and based on reliable medical data regarding diabetes.",
      'es': "Eres Diana, una IA integrada en la app GlicoCare de Eurofarma. Responde en español de manera cálida, inteligente y basada en datos médicos confiables.",
      'fr': "Vous êtes Diana, une IA intégrée à l'application GlicoCare d'Eurofarma. Répondez en français de manière chaleureuse, intelligente et sur la base de données médicales fiables.",
      'de': "Sie sind Diana, eine KI in der GlicoCare-App von Eurofarma. Antworten Sie auf Deutsch herzlich, intelligent und auf der Grundlage zuverlässiger medizinischer Daten.",
      'zh': "您是 Diana，一款集成在欧意药业 GlicoCare 应用中的 AI 助手。请用中文进行温馨、智能且基于可靠医疗数据的回答。"
    };

    final String systemInstruction = systemInstructions[currentLanguage] ?? systemInstructions['en']!;

    try {
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_groqApiKey',
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {"role": "system", "content": systemInstruction},
            {"role": "user", "content": userText}
          ]
        }),
      );

      setState(() {
        _isDianaTyping = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final String aiResponse = data['choices'][0]['message']['content'];
        
        setState(() {
          _messages.add(ChatMessage(text: aiResponse, isUser: false));
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(text: "Erro temporário na API (Status ${response.statusCode})", isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _isDianaTyping = false;
        _messages.add(ChatMessage(text: "Erro de conexão: $e", isUser: false));
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildAnimatedScreenSwitcher() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      child: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (currentScreen) {
      case 'welcome':
        return _buildWelcomeScreen();
      case 'dashboard':
        return _buildDashboard();
      case 'register':
        return _buildAuthScreen(isRegister: true);
      default:
        return _buildAuthScreen(isRegister: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAnimatedScreenSwitcher(),
    );
  }

  // --- TELA DE INICIAÇÃO ATUALIZADA (TEXTO DE PATROCÍNIO REMOVIDO) ---
  Widget _buildWelcomeScreen() {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xff1e3a8a).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.opacity, 
                size: 100, 
                color: Color(0xff1e3a8a)
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'GlicoCare', 
              style: TextStyle(
                color: Color(0xff1e3a8a), 
                fontSize: 36, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 1
              )
            ),
            const SizedBox(height: 12),
            Text(
              _getText('welcomeMsg'),
              style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 16, letterSpacing: 0.5),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: 260,
              height: 55,
              child: ElevatedButton(
                onPressed: () => setState(() { currentScreen = 'login'; }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1e3a8a),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 4,
                ),
                child: Text(
                  _getText('startBtn'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthScreen({required bool isRegister}) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    final Map<String, String> langDisplayNames = {
      'pt': 'Português (PT)',
      'en': 'English (EN)',
      'es': 'Español (ES)',
      'fr': 'Français (FR)',
      'de': 'Deutsch (DE)',
      'zh': '中文 (ZH)',
    };

    return Scaffold(
      backgroundColor: const Color(0xffdbeafe),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: isWideScreen ? 1000 : double.infinity,
              constraints: const BoxConstraints(minHeight: 580),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Flex(
                direction: isWideScreen ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isWideScreen ? 1 : 0,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xff1e3a8a), Color(0xff3b82f6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: isWideScreen
                            ? const BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
                            : const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.language, color: Colors.white, size: 20),
                              const SizedBox(width: 4),
                              PopupMenuButton<String>(
                                initialValue: currentLanguage,
                                onSelected: (String value) {
                                  setState(() {
                                    currentLanguage = value;
                                    _resetChat();
                                  });
                                },
                                child: Text(
                                  currentLanguage.toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                ),
                                itemBuilder: (BuildContext context) {
                                  return langDisplayNames.entries.map((entry) {
                                    return PopupMenuItem<String>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    );
                                  }).toList();
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Icon(Icons.opacity, color: Colors.cyanAccent, size: 32),
                              SizedBox(width: 10),
                              Text('GlicoCare', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Text(_getText('welcome'), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Text(_getText('subtitle'), style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 16, height: 1.5)),
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(color: const Color(0xfffacc15), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.stars, color: Color(0xff1e3a8a), size: 20),
                                const SizedBox(width: 10),
                                Text(_getText('sponsor'), style: const TextStyle(color: Color(0xff1e3a8a), fontWeight: FontWeight.bold, fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: isWideScreen ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isRegister ? _getText('signup') : _getText('signin'), style: const TextStyle(color: Color(0xff1e3a8a), fontSize: 28, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 30),
                          if (isRegister) ...[
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.badge_outlined, color: Colors.grey),
                                hintText: _getText('namePlaceholder'),
                                filled: true,
                                fillColor: const Color(0xfff8fafc),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextField(
                            controller: _userController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
                              hintText: _getText('userPlaceholder'),
                              filled: true,
                              fillColor: const Color(0xfff8fafc),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                              hintText: _getText('passPlaceholder'),
                              filled: true,
                              fillColor: const Color(0xfff8fafc),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isRegister ? _handleRegister : _handleLogin,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff1e3a8a), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                              child: Text(isRegister ? _getText('signup') : _getText('signin'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isRegister ? _getText('alreadyHaveAccount') : _getText('newHere'), style: const TextStyle(color: Colors.black54)),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    currentScreen = isRegister ? 'login' : 'register';
                                    _userController.clear();
                                    _passwordController.clear();
                                  });
                                },
                                child: Text(isRegister ? _getText('signin') : _getText('createAccount'), style: const TextStyle(color: Color(0xff3b82f6), fontWeight: FontWeight.bold)),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildDashboard() {
    final int days = int.tryParse(_stockDaysController.text) ?? 0;
    final bool isStockLow = days <= 5;

    return Scaffold(
      backgroundColor: const Color(0xfff1f5f9),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.opacity, color: Colors.white),
            SizedBox(width: 8),
            Text('GlicoCare Hub', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: _launchEurofarmaUrl,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xfffacc15), 
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4, offset: const Offset(0, 2))
                  ]
                ),
                child: const Center(
                  child: Row(
                    children: [
                      Text('Eurofarma', style: TextStyle(color: Color(0xff1e3a8a), fontWeight: FontWeight.bold, fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.open_in_new, color: Color(0xff1e3a8a), size: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () => setState(() {
              currentScreen = 'welcome'; 
              _resetChat();
            }),
          )
        ],
        backgroundColor: const Color(0xff1e3a8a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(backgroundColor: Color(0xffdbeafe), child: Icon(Icons.alarm, color: Color(0xff1e3a8a))),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_getText('medReminder'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xff1e3a8a))),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff8fafc),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: TextField(
                                    controller: _medReminderController,
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: "Ex: Metformina às 20:00",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: isStockLow ? const Color(0xfffef2f2) : Colors.white, 
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: isStockLow ? const BorderSide(color: Colors.redAccent, width: 1.5) : BorderSide.none,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: isStockLow ? const Color(0xfffee2e2) : const Color(0xfffef3c7), 
                            child: Icon(Icons.shopping_cart, color: isStockLow ? Colors.red : Colors.amber)
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_getText('stockAlert'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isStockLow ? Colors.red.shade900 : const Color(0xff1e3a8a))),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isStockLow ? const Color(0xfffecaca) : const Color(0xfff1f5f9),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: isStockLow ? Colors.redAccent : Colors.black12),
                                      ),
                                      child: TextField(
                                        controller: _stockDaysController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) => setState(() {}),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isStockLow ? Colors.red.shade900 : Colors.black87),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        isStockLow ? _getText('stockSuffix') : "${_getText('stockSafe')} $days dias.",
                                        style: TextStyle(color: isStockLow ? Colors.red.shade700 : Colors.black54, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xff1e3a8a),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(backgroundColor: Colors.cyanAccent, child: Icon(Icons.psychology, color: Color(0xff1e3a8a))),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_getText('dianaTitle'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(_getText('dianaSub'), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          return Align(
                            alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10, left: msg.isUser ? 40 : 0, right: msg.isUser ? 0 : 40),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: msg.isUser ? const Color(0xff3b82f6) : const Color(0xfff1f5f9),
                                borderRadius: BorderRadius.circular(14).copyWith(
                                  topLeft: msg.isUser ? const Radius.circular(14) : Radius.zero,
                                  topRight: msg.isUser ? Radius.zero : const Radius.circular(14),
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87, fontSize: 14, height: 1.4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isDianaTyping)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.4, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            builder: (context, opacityValue, child) => Opacity(
                              opacity: opacityValue,
                              child: Text(
                                _getText('dianaThinking'),
                                style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 13),
                              ),
                            ),
                            onEnd: () => setState(() {}),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              onSubmitted: (_) => _handleSendMessage(),
                              decoration: InputDecoration(
                                hintText: _getText('dianaChatPlaceholder'),
                                hintStyle: const TextStyle(fontSize: 14),
                                filled: true,
                                fillColor: const Color(0xfff8fafc),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: const Color(0xff1e3a8a),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white, size: 18),
                              onPressed: _handleSendMessage,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}