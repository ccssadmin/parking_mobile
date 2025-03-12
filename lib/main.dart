import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:par/screens/splash_screen.dart';
// Ensure Hive is imported
// Ensure the splash screen is imported

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await initHiveForFlutter();

  // Define the GraphQL endpoint
  const String graphqlEndpoint = String.fromEnvironment(
    'GRAPHQL_ENDPOINT',
    defaultValue: 'https://parkkingzapi.crestclimbers.com/graphql/',
  );

  // Create an HTTP link for GraphQL
  final HttpLink httpLink = HttpLink(graphqlEndpoint);

  // Create a ValueNotifier for the GraphQL client
  final ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  // Run the app
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textTheme: const TextTheme(
              displayLarge:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          home: const Splash(), // Ensure this matches your splash screen widget
        ),
      ),
    );
  }
}
