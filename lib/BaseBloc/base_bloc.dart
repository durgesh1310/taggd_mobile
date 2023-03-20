import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:ouat/data/data_repo.dart';
import './base_event.dart';
import './base_state.dart';


abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<BaseEvent, BaseState> {
  DataRepo dataRepoImpl = DataRepo.getInstance();

  BaseBloc(BaseState initialState) : super(initialState);

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    print(">>>>>>>>>>>>> BaseBloc Event ${event.toString()}");

    if (event is ShowSnackBarErrorEvent) {
      yield ShowSnackBarErrorState(event.error);
    }

    if (event is PlaceHolderEvent) {
      yield PlaceHolderState();
    }

    if (event is ShowDialogInfoEvent) {
      yield ShowDialogInfoState(event.title, event.message);
    }

    if (event is ShowDialogErrorEvent) {
      yield ShowDialogErrorState(event.error);
    }



    if (event is InitStateEvent) {
      // yield initalState;
    }

    if (event is LogoutEvent) {
      yield LogoutState();
    }

    yield* mapBaseEventToBaseState(event);
  }

  Stream<S> mapBaseEventToBaseState(BaseEvent event);

  bool resetToInitStateOnError() => false;


  @override
  void onError(Object error, StackTrace stackTrace) {
    print("On Error");
    print(error.toString());
    print(stackTrace.toString());

    // FirebaseAnalyticsUtils.getInstance().analytics.logEvent(
    //   name: 'bloc_error',
    //   parameters: {
    //     'error': error.toString(),
    //     'stackTrace': stackTrace.toString()
    //   },
    // );

    // Crashlytics.instance.recordError(error, stackTrace);

    if (resetToInitStateOnError()) {
      add(InitStateEvent());
    }

    if (error is DioError) {
      errorHandlerEvent(error);
    } else {
      String? errorMessage;
      if (error is PlatformException) {
        errorMessage = error.message;
      }

      add(ShowDialogErrorEvent(errorMessage ?? error.toString()));
    }
    // super.onError(error, stacktrace);
  }

  void errorHandlerEvent(DioError error) {
    if (error.type == DioErrorType.response) {
     
      
       add(ShowDialogErrorEvent(
                "Something went wrong : " + error.message.toString()));
    }

    if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.sendTimeout) {
      add(ShowDialogErrorEvent(
          "Connection Time Out : " + error.message.toString()));
    }
    if (error.type == DioErrorType.other) {
      add(ShowDialogErrorEvent(
          "Something went wrong : " + error.message.toString()));
    }
  }
}