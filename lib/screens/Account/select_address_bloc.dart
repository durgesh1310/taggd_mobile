import 'package:ouat/BaseBloc/base_bloc.dart';
import 'package:ouat/BaseBloc/base_event.dart';
import 'package:ouat/BaseBloc/base_state.dart';
import 'package:ouat/data/data_repo.dart';
import 'package:ouat/data/models/addAddressModel.dart';
import 'package:ouat/data/models/selectAddressModel.dart';
import 'package:ouat/data/repo/user_repo.dart';
import './select_address_event.dart';
import './select_address_state.dart';

class SelectAddressBloc extends BaseBloc{

  final UserRepo userRepo = UserRepo();

  SelectAddressBloc(BaseState initialState) : super(SearchInitState());

  @override
  SelectAddressState get initialState => SearchInitState();

  DataRepo dataRepo = DataRepo.getInstance();


  @override
  Stream<BaseState> mapBaseEventToBaseState(BaseEvent event) async* {
    if (event is LoadEvent) {
      SelectAddressModel  selectAddressModel = await dataRepo.userRepo.getSelectAddress();
      if (selectAddressModel.success ?? false) {
        yield CompletedState(selectAddressModel: selectAddressModel);
      }
      else if(selectAddressModel.code == "200"){
        yield EmptyState();
      }
      else {
        // yield  ErrorState('We aren’t serving here yet');
        yield ErrorState("some thing went wrong");
      }
    }

    if(event is DeletingEvent){
      AddAddressModel deleteAddressModel = await dataRepo.userRepo.getDeleteAddress(event.address_id);
      if(deleteAddressModel.success ?? false){
        yield DeleteState(deleteAddressModel: deleteAddressModel);
      }
      else {
        yield ErrorState("some thing went wrong");
      }
    }
  }
}