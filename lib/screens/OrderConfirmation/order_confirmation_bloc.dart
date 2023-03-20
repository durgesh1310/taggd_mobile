import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/orderConfirmationModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import '../../data/models/commonBannerModel.dart';
import './order_confirmation_state.dart';
import './order_confirmation_event.dart';

class OrderConfirmationBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  OrderConfirmationBloc(BaseState initialState) : super(SearchInitState());

  @override
  OrderConfirmationState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      //yield ShowProgressLoader('Loading...');
      OrderConfirmationModel orderConfirmationModel = await dataRepo.userRepo.postOrderConfirm(event.order_id);
      if (orderConfirmationModel.success ?? false) {
        yield CompletedState(orderConfirmationModel: orderConfirmationModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if(event is BannerEvent){
      CommonBannerModel commonBannerModel = await dataRepo.userRepo.getCommonBanner();
      if (commonBannerModel.success ?? false) {
        yield BannerState(commonBannerModel: commonBannerModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorBannerState();
      }
    }

  }

}