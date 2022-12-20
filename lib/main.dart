import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  return runApp(ModularApp(module: AppModule(), child: AppWidget()));
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/page1');

    return MaterialApp.router(
      title: 'My Smart App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}

class AppModule extends Module {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => HomePage(),
          children: [
            ChildRoute('/page1/',
                child: (context, args) =>
                    const InternalPage(title: 'page 1', color: Colors.red)),
            ChildRoute(
              '/page2/',
              child: (context, args) => const DrawerPage(),
              children: [
                ChildRoute(
                  '/page2_1/',
                  child: (context, args) => const InternalPage(
                    title: 'page 2.1',
                    color: Colors.pink,
                  ),
                ),
                ChildRoute(
                  '/page2_2/',
                  child: (context, args) => const InternalPage(
                    title: 'page 2.2',
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            ChildRoute(
              '/page3/',
              child: (context, args) =>
                  const InternalPage(title: 'page 3', color: Colors.green),
            ),
          ],
        ),
      ];
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () => Modular.to.navigate('/page1'),
            icon: const Icon(Icons.air),
          ),
          IconButton(
            onPressed: () => Modular.to.navigate('/page2'),
            icon: const Icon(Icons.fire_hydrant),
          ),
          IconButton(
            onPressed: () => Modular.to.navigate('/page3'),
            icon: const Icon(Icons.wallet),
          ),
        ],
      ),
      body: Row(
        children: const [
          Expanded(child: RouterOutlet()),
        ],
      ),
    );
  }
}

class InternalPage extends StatelessWidget {
  final String title;
  final Color color;
  const InternalPage({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: Center(child: Text(title)),
    );
  }
}

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Modular.to.navigate('/page2/page2_2/');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          color: Colors.cyan,
          child: Column(
            children: [
              ListTile(
                title: const Text('Page 2.1'),
                onTap: () => Modular.to.navigate('/page2/page2_1/'),
              ),
              ListTile(
                title: const Text('Page 2.2'),
                onTap: () => Modular.to.navigate('/page2/page2_2/'),
              )
            ],
          ),
        ),
        const Expanded(child: RouterOutlet())
      ],
    );
  }
}
