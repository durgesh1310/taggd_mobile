import 'package:ouat/data/models/categoryModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';

class CategoryManager {
  static final CategoryManager _instance = CategoryManager._internal();
  static CategoryManager getInstance() => _instance;

  CategoryManager._internal();
  CategoryModel? categoryModel;

  saveCategory(CategoryModel localcategoryModel) {
    categoryModel = localcategoryModel;
    PreferencesManager.savePref(
        "CATEGORY", categoryModelToJson(categoryModel!));
  }

  CategoryModel? getCategory() {
    String categoryString = PreferencesManager.getPref("CATEGORY");

    if (categoryString != null && categoryString.isNotEmpty) {
      categoryModel = categoryModelFromJson(categoryString);

      return categoryModel;
    }
  }
}
