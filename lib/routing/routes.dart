// Routes
abstract final class Routes {
  static const login = '/login';
  static const forgotpassword = '/forgotpassword';
  static const resetpassword = '/reset-password';
  static const signup = '/signup';

  static const home = '/home';
  static const map = '/map';
  static const users = '/users';
  static const finance = '/finance';
  static const settings = '/settings';

  // CRUD 5 type of users
  static const collectionCenters = '/collection-centers';
  static String collectionCenterById(String id) => '$collectionCenters/$id';

  static const admins = '/admins';
  static String adminsById(String id) => '$admins/$id';

  static const participants = '/participants';
  static String participantById(String id) => '$participants/$id';

  static const collectors = '/collectorss';
  static String collectorById(String id) => '$collectors/$id';

  static const stores = '/stores';
  static String storesById(String id) => '$stores/$id';
}
