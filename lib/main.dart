import 'package:appins/providers/user_provider.dart';
import 'package:appins/responsive/mobile_screen_layout.dart';
import 'package:appins/responsive/responsive_layout_screen.dart';
import 'package:appins/responsive/web_screen_layout.dart';
import 'package:appins/screens/login_screen.dart';
import 'package:appins/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCgpR_oyu-gltQ51rbVdTj8BqBuy6_k0AE',
        appId: '1:831272423260:web:70c0d49f770c05638d7b99',
        messagingSenderId: '831272423260',
        projectId: 'appins-5dd14',
        storageBucket: 'appins-5dd14.appspot.com',
        authDomain: 'appins-5dd14.firebaseapp.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // theo dõi trạng thái đăng nhập
              if (snapshot.hasData) {
                //nếu ảnh chụp nhanh có dữ liệu nghĩa là người dùng đã đăng nhập thì chúng tôi sẽ kiểm tra độ rộng của màn hình và hiển thị bố cục màn hình theo đó
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // nếu chưa đăng nhập thì chúng tôi sẽ hiển thị màn hình đăng nhập
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
