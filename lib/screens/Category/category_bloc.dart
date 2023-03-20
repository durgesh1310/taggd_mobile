import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';

import 'package:ouat/data/models/categoryModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import 'package:ouat/screens/Category/category_event.dart';
import 'package:ouat/screens/Category/category_state.dart';

class CategoryBloc extends BaseBloc {
  final UserRepo userRepo = UserRepo();

  CategoryBloc(BaseState initialState) : super(SearchInitState());

  @override
  CategoryState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      // yield ShowProgressLoader('Loading...');
      CategoryModel? categoryModel =
          await dataRepo.categoryManager.getCategory();

      yield CompletedState(categoryModel: categoryModel);
    }
  }
}
