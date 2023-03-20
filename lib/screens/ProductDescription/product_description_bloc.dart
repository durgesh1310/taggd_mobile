import 'dart:developer';
import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/commonBannerModel.dart';
import 'package:ouat/data/models/deleteWishListModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/productDescriptionModel.dart';
import 'package:ouat/data/models/recommendationModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './product_description_event.dart';
import './product_description_state.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';

class ProductDescriptionBloc extends BaseBloc {
  final UserRepo userRepo = UserRepo();

  ProductDescriptionBloc(BaseState initialState) : super(SearchInitState());

  @override
  ProductDescriptionState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
       //yield ShowProgressLoader('Loading...');
      ProductDescriptionModel productDescriptionModel =
          await dataRepo.userRepo.getProductDescription(event.pid);
      if (productDescriptionModel.success ?? false) {
        yield CompletedState(productDescriptionModel: productDescriptionModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is LoadingEvent) {
      //yield ShowProgressLoader('Loading...');
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

    if (event is ProgressEvent) {
      yield ShowProgressLoader('Loading...');
      AddToCartModel addToCartModel =
          await dataRepo.userRepo.addToCart(event.sku, event.quantity);
      if (addToCartModel.success) {
        yield CompletedAddingState(addToCartModel: addToCartModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is AddToFavouriteEvent) {
      if(event.productDescriptionModel!.data!.isItemWishListed == true){
         DeleteWishListModel deleteWishListModel = await dataRepo.userRepo.deleteWishId((event.productDescriptionModel!.data!.productId  ?? 0));
         if(deleteWishListModel.success ?? false){
           yield UnFavouriteState();
           
         }

      }else{
        await PreferencesManager.init();
        CustomerDetail? customerDetail = dataRepo.userRepo.getSavedUser();
        log("$customerDetail");
        if (customerDetail == null) {
         // yield NotAuthorisedState();
        }
        else{
          AddToWishListModel addtoWishListModel = await dataRepo.userRepo.addToWishList(
              event.productDescriptionModel!.data!.productId ??
              12);
          if(addtoWishListModel.success ??false){
            yield FavouriteState();
        }
      }
       

      }
     
      
    }

    if (event is CountingEvent) {
      //yield ShowProgressLoader('Loading...');
      OrderStatusModel orderStatusModel = await dataRepo.userRepo.getItemsNumber();
      if (orderStatusModel.success ?? false) {
        yield CountingState(orderStatusModel: orderStatusModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is RecommendingEvent) {
      RecommendationModel recommendationModel = await dataRepo.userRepo.getRecommendations(event.pid);
      if (recommendationModel.success ?? false) {
        yield RecommendingState(recommendationModel: recommendationModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorRecommendingState();
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
