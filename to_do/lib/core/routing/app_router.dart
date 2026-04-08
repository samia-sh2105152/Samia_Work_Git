import 'package:go_router/go_router.dart';
import 'package:to_do/features/categories/presentation/screens/categories_screen.dart';

class AppRouter {
  static final categories = (
    path: '/',
    name: 'CategoriesScreen',
    screen: CategoriesScreen,
  );
  static final GoRouter router = GoRouter(
    initialLocation: categories.path,
    routes: [
      GoRoute(
        path: categories.path,
        name: categories.name,
        builder: (context, state) => const CategoriesScreen(),
      ),
    ],
  );
}
