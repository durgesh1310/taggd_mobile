import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addToCartModel.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './sendOTP_state.dart';
import './sendOTP_event.dart';

class SendOTPBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  SendOTPBloc(BaseState initialState) : super(SearchInitState());

  @override
  SendOTPState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      print(event.phoneNo);
      yield ShowProgressLoader('Loading...');
      SendOTPModel sendOTPModel = await dataRepo.userRepo.postOtp(event.phoneNo, event.otpReason);
      if(sendOTPModel.success == false){
        yield MessageState(sendOTPModel: sendOTPModel);
      }
      else if (sendOTPModel.success ?? false) {
        yield CompletedState(sendOTPModel: sendOTPModel);
      }
      else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }


  }
}