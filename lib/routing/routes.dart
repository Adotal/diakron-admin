// Routes
abstract final class Routes {
  static const login = '/login';
  static const forgotpassword = '/forgotpassword';
  static const resetpassword = '/reset-password';
  static const signup = '/signup';

  static const home = '/';
  static const map = '/map';
  static const users = '/users';
  static const finance = '/finance';
  static const settings = '/settings';

  // CRUD
  static const collectionCenters = '/collection-centers';
  static String collectionCenterById(String id) => '$collectionCenters/$id';
}
