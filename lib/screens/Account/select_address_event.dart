import 'package:ouat/BaseBloc/base_event.dart';

class SelectAddressEvent extends BaseEvent{
  SelectAddressEvent([List props = const []]) : super(props);
}

class LoadEvent extends SelectAddressEvent {}

class DeletingEvent extends SelectAddressEvent {
  int address_id;
  DeletingEvent(this.address_id):super([address_id]);
}
