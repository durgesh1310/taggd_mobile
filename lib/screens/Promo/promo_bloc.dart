import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './promo_event.dart';
import './promo_state.dart';
import 'package:ouat/data/models/promoListModel.dart';
import 'package:ouat/data/models/promoValidModel.dart';

class PromoBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  PromoBloc(BaseState initialState) : super(SearchInitState());

  @override
  PromoState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      yield ShowProgressLoader('Loading...');
      PromoListModel promoListModel = await dataRepo.userRepo.getPromo();
      if (promoListModel.success ?? false) {
        yield CompletedState(promoListModel: promoListModel);
      }
      else if(promoListModel.data == null){
        yield EmptyState();
      }
      else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }


    if (event is LoadingEvent) {
      yield ShowProgressLoader('Loading...');
      PromoValidModel promoValidModel = await dataRepo.userRepo.checkPromo(event.cart_items, event.cart_value, event.promo);
      if (promoValidModel.success ?? false) {
        yield CompletedCheckState(promoValidModel: promoValidModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }
  }

}