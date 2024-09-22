import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import 'home_screen.dart'; // ホーム画面のインポート

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ローディング状態を管理するための変数
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ローディング中はインジケーターを表示
            if (_isLoading)
              CircularProgressIndicator()
            else ...[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'メールアドレス'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('ログイン'),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    // ログイン処理
                    await _authService.signIn(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                    // ログイン成功後にホーム画面へ遷移
                    Navigator.pushReplacementNamed(context, '/home');
                  } on FirebaseAuthException catch (e) {
                    // エラーメッセージを表示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message ?? 'ログインに失敗しました')),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
              ),
              TextButton(
                child: Text('新規登録はこちら'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
