import 'package:equatable/equatable.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/homeModel.dart';
import 'package:ouat/data/models/orderStatusModel.dart';
import 'package:ouat/data/models/sortBarModel.dart';
import 'package:ouat/screens/Splash/splash_event.dart';

abstract class SplashActivityState extends BaseState {
  SplashActivityState([List props = const []]) : super(props);

  // SplashActivityState([List props = const []]) : super(props);
}

class SplashInitState extends SplashActivityState {}


// class UnInitialized extends AuthState {
//   @override
//   List<Object> get props => [];
// }

class SearchStateEmpty extends SplashActivityState {
   @override
  List<Object> get props => [];
}

class UnInitialized extends SplashActivityState {
   @override
  List<Object> get props => [];
}

// class SplashInitState extends SplashActivityState {
//    @override
//   List<Object> get props => [];
// }

class SplashLoaderState extends SplashActivityState {
   @override
  List<Object> get props => [];
}

class DoneState extends SplashActivityState {
   final HomeModel? homeModel;
   final SortBarModel? sortBarModel;
   final OrderStatusModel? orderStatusModel;
   final bool? boolisSignUpScreen; 
  DoneState({this.homeModel, this.sortBarModel,this.orderStatusModel,this.boolisSignUpScreen});
  List<Object?> get props => [homeModel , sortBarModel,orderStatusModel,boolisSignUpScreen];
}

class OpenAuthenticationScreen extends SplashActivityState {
   @override
  List<Object> get props => [];
}

class OpenDashboardScreen extends SplashActivityState {
   @override
  List<Object> get props => [];
}

class NotAuthorisedState extends SplashActivityState{
    @override
  List<Object> get props => [];

}

class ErrorState extends SplashActivityState {
  final String message;
  ErrorState(this.message);
}
