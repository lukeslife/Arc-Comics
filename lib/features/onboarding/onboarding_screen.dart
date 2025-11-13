import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api/komga_client.dart';
import '../../data/storage/credentials_store.dart';

final _credentialsStoreProvider = Provider((_) => CredentialsStore());

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _baseUrlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _useApiKey = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingCredentials() async {
    final store = ref.read(_credentialsStoreProvider);
    final baseUrl = await store.getBaseUrl();
    final apiKey = await store.getApiKey();
    final username = await store.getUsername();
    
    if (baseUrl != null) _baseUrlController.text = baseUrl;
    if (apiKey != null && apiKey.isNotEmpty) {
      _apiKeyController.text = apiKey;
      _useApiKey = true;
    }
    if (username != null) {
      _usernameController.text = username;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingCredentials();
    });
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final baseUrl = _baseUrlController.text.trim();
      final apiKey = _useApiKey ? _apiKeyController.text.trim() : null;
      final username = _useApiKey ? null : _usernameController.text.trim();
      final password = _useApiKey ? null : _passwordController.text;

      if (baseUrl.isEmpty) {
        throw Exception('Base URL is required');
      }

      if (_useApiKey && (apiKey == null || apiKey.isEmpty)) {
        throw Exception('API key is required when using API key authentication');
      }

      if (!_useApiKey && (username == null || username.isEmpty || password == null || password.isEmpty)) {
        throw Exception('Username and password are required when using basic authentication');
      }

      final client = KomgaClient.withCredentials(
        baseUrl: baseUrl,
        apiKey: apiKey,
        username: username,
        password: password,
      );

      final connected = await client.testConnection();
      
      if (!connected) {
        throw Exception('Failed to connect to server. Please check your credentials and URL.');
      }

      // Save credentials
      final store = ref.read(_credentialsStoreProvider);
      await store.setBaseUrl(baseUrl);
      await store.setApiKey(apiKey);
      await store.setUsername(username);
      await store.setPassword(password);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup Komga Server'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome to Arc Comics',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connect to your Komga server to get started.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _baseUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Server URL',
                    hintText: 'https://komga.example.com',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Komga server URL';
                    }
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.hasScheme) {
                      return 'Please enter a valid URL (e.g., https://komga.example.com)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Use API Key Authentication'),
                  subtitle: const Text('Otherwise use username/password'),
                  value: _useApiKey,
                  onChanged: (value) {
                    setState(() {
                      _useApiKey = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                if (_useApiKey) ...[
                  TextFormField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      prefixIcon: Icon(Icons.key),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: _useApiKey
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'API key is required';
                            }
                            return null;
                          }
                        : null,
                  ),
                ] else ...[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'your-username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: !_useApiKey
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: !_useApiKey
                        ? (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          }
                        : null,
                  ),
                ],
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isLoading ? null : _testConnection,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Connect', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
