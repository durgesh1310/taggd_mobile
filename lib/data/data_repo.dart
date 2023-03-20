import 'package:ouat/data/models/categoryModel.dart';
import 'package:ouat/data/repo/category_repo.dart';
import 'package:ouat/data/repo/user_repo.dart';

class DataRepo {
  static final DataRepo _instance = DataRepo._internal();
  static DataRepo getInstance() => _instance;
//   User user;
  DataRepo._internal();
    UserRepo userRepo = UserRepo.getInstance();


CategoryManager categoryManager = CategoryManager.getInstance();


  // UserRepo userRepo = UserRepo.getInstance();
  // OrderRepo orderRepo = OrderRepo.getInstance();
  // SessionManager sessionManager = SessionManager.getInstance();
}