import 'dart:developer';
import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/scratchCardsModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import '../../data/models/scratchCodeModel.dart';
import '../../data/models/validateOTPModel.dart';
import '../../data/prefs/PreferencesManager.dart';
import './scratch_card_event.dart';
import './scratch_card_state.dart';


class ScratchCardBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  ScratchCardBloc(BaseState initialState) : super(SearchInitState());

  @override
  ScratchCardState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      //yield ShowProgressLoader('Loading...');
      await PreferencesManager.init();
      CustomerDetail? customerDetail = dataRepo.userRepo.getSavedUser();
      log("$customerDetail");
      if (customerDetail == null) {
        yield NotAuthorisedState();
      } else {
        ScratchCardsModel scratchCardsModel = await dataRepo.userRepo.getScratchCards();
        if (scratchCardsModel.success ?? false) {
          yield CompletedState(scratchCardsModel: scratchCardsModel);
        } else {
          // yield  ErrorState('We aren’t serving here yet');
          yield ErrorState("some thing went wrong");
        }
      }
    }


    if (event is LoadScratchCodeEvent) {
      //yield ShowProgressLoader('Loading...');
      ScratchCodeModel scratchCodeModel = await dataRepo.userRepo.getScratchCodeCards();
      if (scratchCodeModel.success ?? false) {
        yield CompletedCodeState(scratchCodeModel: scratchCodeModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
       // yield ErrorState("some thing went wrong");
      }
    }
  }

}