import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/pincodeValidationModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './shipping_address_event.dart';
import './shipping_address_state.dart';


class ShippingAddressBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  ShippingAddressBloc(BaseState initialState) : super(SearchInitState());

  @override
  ShippingAddressState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {

    if (event is ProgressEvent) {
      yield ShowProgressLoader('Loading...');
      AddAddressModel addAddressModel = await dataRepo.userRepo.addAddress(
          event.fullname, 
          event.pincode, 
          event.address, 
          event.landmark, 
          event.mobile, 
          event.city, 
          event.state
      );
      if (addAddressModel.success ?? false) {
        yield CompletedAddingState(addAddressModel: addAddressModel);
      } else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if (event is LoadingEvent) {
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
  }



}