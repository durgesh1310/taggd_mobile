import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/sendOTPModel.dart';
import 'package:ouat/data/models/signUpModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './signup_state.dart';
import './signup_event.dart';

class SignUpBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  SignUpBloc(BaseState initialState) : super(SearchInitialState());

  @override
  SignUpState get initialState => SearchInitialState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadSignUpEvent) {
      yield ShowProgressLoader('Loading...');
      SignUpModel signUpModel = await dataRepo.userRepo.signUpCustomer(
          event.name,
          event.gender,
          event.email,
          event.mobno
      );
      if (signUpModel.success) {
        yield CompletedSignUpState(signUpModel: signUpModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorSignUpState("some thing went wrong");
      }
    }

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
        yield ErrorSignUpState("some thing went wrong");
      }
    }
  }
}