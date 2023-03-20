import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/orderListingModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/searchModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './order_listing_event.dart';
import './order_listing_state.dart';

class OrderListingBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  OrderListingBloc(BaseState initialState) : super(SearchInitState());

  @override
  OrderListingState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      yield LoadingState();
      OrderListingModel orderListingModel = await dataRepo.userRepo.getOrderList(event.pageNo);
      HomeModel homeModel = await dataRepo.userRepo.getHomeScreen();
      SortBarModel sortBarModel = await dataRepo.userRepo.getSortBar();
      if (orderListingModel.success ?? false) {
        yield CompletedState(orderListingModel: orderListingModel, homeModel: homeModel, sortBarModel: sortBarModel);
      }
      else if (orderListingModel.success == false &&
          orderListingModel.message![0].msgText == "Unauthorized" &&
          orderListingModel.code == "500"
      ) {
        yield NotAuthorisedState();
      }
      else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is CountingEvent) {
      yield ShowProgressLoader('Loading...');
      OrderStatusModel orderStatusModel = await dataRepo.userRepo.getItemsNumber();
      if (orderStatusModel.success ?? false) {
        yield CountingState(orderStatusModel: orderStatusModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if(event is NextSearchLoadEvent){
      // yield LoadingState();
      OrderListingModel orderListingModel = await dataRepo.userRepo.getOrderList(event.pageNo);
      if (orderListingModel.success ?? false) {
        if(orderListingModel.data != null){
          if(event.orderListDetailResponse!.isNotEmpty){
            orderListingModel.data!.orderListDetailResponse = [...event.orderListDetailResponse ?? [],...orderListingModel.data!.orderListDetailResponse??[]];
          }
          yield CompletedState(orderListingModel: orderListingModel);
        }
        else{
          yield NoMoreItemState();
        }

      }

    }
  }
}