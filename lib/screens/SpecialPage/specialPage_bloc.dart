// import 'package:bloc/bloc.dart';
import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './specialPage_event.dart';
import './specialPage_state.dart';
class SpecialPageBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  SpecialPageBloc(BaseState initialState) : super(SearchInitState());

  @override
  SpecialPageState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      //yield ShowProgressLoader('Loading...');
      HomeModel homeModel = await dataRepo.userRepo.getSpecialPage(event.id);
      if (homeModel.success ?? false) {
        yield CompletedState(homeModel: homeModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }
  }

}