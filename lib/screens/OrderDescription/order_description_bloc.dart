import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/cancelReasonModel.dart';
import 'package:ouat/data/models/cancelReturnItemModel.dart';
import 'package:ouat/data/models/orderDescriptionModel.dart';
import 'package:ouat/data/models/sizeExchangedModel.dart';
import 'package:ouat/data/models/sizeExchangingModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './order_description_event.dart';
import './order_description_state.dart';

class OrderDescriptionBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  OrderDescriptionBloc(BaseState initialState) : super(SearchInitState());

  @override
  OrderDescriptionState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      yield ShowProgressLoader('Loading...');
      OrderDescriptionModel orderDescriptionModel = await dataRepo.userRepo.getOrderDetail(event.order_number);
      if (orderDescriptionModel.success ?? false || orderDescriptionModel.code == 200) {
        yield CompletedState(orderDescriptionModel: orderDescriptionModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is LoadingEvent) {
      yield ShowProgressLoader('Loading...');
      CancelReasonModel cancelReasonModel = await dataRepo.userRepo.getCancelReason(event.order_number!);
      if (cancelReasonModel.success ?? false || cancelReasonModel.code == 200) {
        yield CancelledReasonState(cancelReasonModel: cancelReasonModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is ExchangeEvent) {
      yield ShowProgressLoader('Loading...');
      CancelReasonModel cancelReasonModel = await dataRepo.userRepo.getExchangeReason(event.order_number!);
      if (cancelReasonModel.success ?? false || cancelReasonModel.code == 200) {
        yield CancelledReasonState(cancelReasonModel: cancelReasonModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is ProgressEvent) {
      yield ShowProgressLoader('Loading...');
      CancelReasonModel cancelReasonModel = await dataRepo.userRepo.getReturnReason(event.order_number!);
      if (cancelReasonModel.success ?? false || cancelReasonModel.code == 200) {
        yield CancelledReasonState(cancelReasonModel: cancelReasonModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is ProcessingEvent) {
      yield ShowProgressLoader('Loading...');
      CancelReturnItemModel cancelReturnItemModel = await dataRepo.userRepo.postCancelItem(
        event.order_item_id,
        event.sku,
        event.reason_id,
        event.refund_type
      );
      if (cancelReturnItemModel.success ?? false || cancelReturnItemModel.code == 200) {
        yield DoneState(cancelReturnItemModel: cancelReturnItemModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is ProgressingEvent) {
      yield ShowProgressLoader('Loading...');
      SizeExchangedModel sizeExchangedModel = await dataRepo.userRepo.postExchangeItem(
          event.order_item_id,
          event.sku,
          event.reason_id,
      );
      if (sizeExchangedModel.success ?? false || sizeExchangedModel.code == 200) {
        yield ExchangeState(sizeExchangedModel: sizeExchangedModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is ProcessEvent) {
      yield ShowProgressLoader('Loading...');
      CancelReturnItemModel cancelReturnItemModel = await dataRepo.userRepo.postReturnItem(
          event.order_item_id,
          event.sku,
          event.reason_id,
        event.refund_type
      );
      if (cancelReturnItemModel.success ?? false || cancelReturnItemModel == 200) {
        yield DoneState(cancelReturnItemModel: cancelReturnItemModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if(event is SizeExchangeEvent){
      yield ShowProgressLoader('Loading...');
      SizeExchangingModel sizeExchangingModel = await dataRepo.userRepo.postSizeExchange(
        event.order_item_id
      );
      if (sizeExchangingModel.success ?? false || sizeExchangingModel == 200) {
        yield SizeExchangeState(sizeExchangeModel: sizeExchangingModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }


  }
}