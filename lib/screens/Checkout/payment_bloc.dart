import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/orderStatusV1Model.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/models/placeOrderModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './payment_state.dart';
import './payment_event.dart';

class PaymentBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  PaymentBloc(BaseState initialState) : super(SearchInitState());

  @override
  PaymentState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadingEvent) {
      yield ShowProgressLoader('Loading...');
      PlaceOrderModel placeOrderModel = await dataRepo.userRepo.postPlaceOrder(event.payment_method);
      if (placeOrderModel.success ?? false) {
        yield CompletedState(placeOrderModel: placeOrderModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is PincodeEvent) {
      PincodeValidationModel pincodeValidationModel =
      await dataRepo.userRepo.getPincodeCheck(event.pincode);
      if (pincodeValidationModel.success ?? false) {
        yield CompletedCheckState(
            pincodeValidationModel: pincodeValidationModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is LoadEvent) {
      OrderStatusV1Model orderStatusV1Model = await dataRepo.userRepo.putOrderStatus(
          event.order_id,
          event.payment_status,
          event.payment_id,
          event.razorpay_order_id,
          event.signature);
      if (orderStatusV1Model.success ?? false) {
        yield StatusState(orderStatusV1Model: orderStatusV1Model);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }
  }

}