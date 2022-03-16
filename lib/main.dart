import 'package:flutter/material.dart';
import 'package:flutter_github_client_desktop/github_login_widget.dart';
import 'package:flutter_github_client_desktop/github_oauth_client.dart';
import 'package:flutter_github_client_desktop/github_summary.dart';
import 'package:github/github.dart';
import 'package:flutter_plugin_window_to_front/flutter_plugin_window_to_front.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GitHub Client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      builder: (context, httpClient) {
        return FutureBuilder<CurrentUser>(
          builder: (context, snapshot) {
            FlutterPluginWindowToFront.activate();
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: GitHubSummary(
                gitHub: _getGitHub(httpClient.credentials.accessToken),
              ),
            );
          },
          future: viewerDetail(httpClient.credentials.accessToken),
        );
      },
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }

  Future<CurrentUser> viewerDetail(String accessToken) async {
    final gitHub = GitHub(auth: Authentication.withToken(accessToken));
    return gitHub.users.getCurrentUser();
  }

  GitHub _getGitHub(String accessToken) {
    return GitHub(auth: Authentication.withToken(accessToken));
  }
}
