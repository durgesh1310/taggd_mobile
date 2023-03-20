import 'dart:developer';

import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToWishListModel.dart';
import 'package:ouat/data/models/deleteWishListModel.dart';
import 'package:ouat/data/models/searchModel.dart';
import 'package:ouat/data/models/validateOTPModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './search_state.dart';
import './search_event.dart';
import 'package:ouat/data/prefs/PreferencesManager.dart';


class SearchBloc extends BaseBloc {
  final UserRepo userRepo = UserRepo();

  SearchBloc(BaseState initialState) : super(SearchInitState());

  @override
  SearchState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();

  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is SearchLoadEvent) {
      yield SearchLoadingState();
      SearchModel searchModel = await dataRepo.userRepo
          .getSearch(event.query, event.filterData, event.sortBy, event.pageNo);
      if (searchModel.success ?? false) {
        // if(event.plpCard!.isNotEmpty){
        //   searchModel.data!.plpCard = [...event.plpCard ?? [],...searchModel.data!.plpCard??[]];
        // }
        yield CompletedState(searchModel: searchModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if(event is NextSearchLoadEvent){
      SearchModel searchModel = await dataRepo.userRepo
          .getSearch(event.query, event.filterData, event.sortBy, event.pageNo);
      if(searchModel.success ?? false){
        if(event.plpCard!.isNotEmpty){
          searchModel.data!.plpCard = [...event.plpCard ?? [],...searchModel.data!.plpCard??[]];
        }
        yield CompletedState(searchModel: searchModel);
      }
    }

    if(event is NextPlpLoadEvent){
      if(event.collection){
        SearchModel searchModel = await dataRepo.userRepo
            .getPlpCollection(event.query, event.filterData, event.sortBy, event.pageNo);
        if(searchModel.success ?? false){
          if(event.plpCard!.isNotEmpty){
            searchModel.data!.plpCard = [...event.plpCard ?? [],...searchModel.data!.plpCard??[]];
          }
          yield CompletedState(searchModel: searchModel);
        }
      }
      else{
        SearchModel searchModel = await dataRepo.userRepo
            .getPlp(event.query, event.filterData, event.sortBy, event.pageNo);
        if(searchModel.success ?? false){
          if(event.plpCard!.isNotEmpty){
            searchModel.data!.plpCard = [...event.plpCard ?? [],...searchModel.data!.plpCard??[]];
          }
          yield CompletedState(searchModel: searchModel);
        }
      }
    }

    if (event is LoadingEvent) {
      yield SearchLoadingState();
      if(event.collection){
        SearchModel searchModel = await dataRepo.userRepo.getPlpCollection(event.query, event.filterData, event.sortBy, event.pageNo);
        if(searchModel.code == "307"){
          yield RedirectingState();
        }
        else if (searchModel.success ?? false) {
          yield CompletedState(searchModel: searchModel);
        }
        else {
          // yield  ErrorState('We aren’t serving here yet');
          yield ErrorState("some thing went wrong");
        }
      }
      else{
        SearchModel searchModel = await dataRepo.userRepo.getPlp(event.query, event.filterData, event.sortBy, event.pageNo);
        if(searchModel.code == "307"){
          yield RedirectingState();
        }
        else if (searchModel.success ?? false) {
          yield CompletedState(searchModel: searchModel);
        }
        else {
          // yield  ErrorState('We aren’t serving here yet');
          yield ErrorState("some thing went wrong");
        }
      }
    }

    if (event is WishlistingEvent) {
      // yield ShowProgressLoader('Loading...');
      await PreferencesManager.init();
      CustomerDetail? customerDetail = dataRepo.userRepo.getSavedUser();
      log("$customerDetail");
      if (customerDetail == null) {
        //yield NotAuthorisedState();
      }
      else{
        if(event.item_wishlisted == false){
          AddToWishListModel addToWishListModel = await dataRepo.userRepo.addToWishList(event.product_id);
          if (addToWishListModel.success ?? false) {
            yield WishlistingState(addToWishListModel: addToWishListModel);
          } else {
            // yield  ErrorState('We aren’t serving here yet');
            yield ErrorState("some thing went wrong");
          }
        }
        else{
          DeleteWishListModel deleteWishListModel = await dataRepo.userRepo.deleteWishId(event.product_id);
          if(deleteWishListModel.success ?? false){
            yield UnFavouriteState();

          }
        }
      }
    }
  }
}
