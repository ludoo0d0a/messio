import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:messio/blocs/authentication/model/user.dart';
import 'package:messio/blocs/contacts/bloc.dart';
import 'package:messio/Utils/MessioException.dart';
import 'package:messio/repositories/ChatRepository.dart';
import 'package:messio/repositories/UserDataRepository.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  UserDataRepository userDataRepository;
  StreamSubscription subscription;

  ChatRepository chatRepository;
  ContactsBloc({this.userDataRepository}) : assert(userDataRepository != null);

  ContactsState get initialState => new InitialContactsState();

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    print(event);
    if (event is FetchContactsEvent) {
      yield* mapFetchContactsEventToState();
    }
    if (event is ReceivedContactsEvent){
      //  yield FetchingContactsState();
      yield FetchedContactsState(event.contacts);
    }
    if (event is AddContactEvent) {
      yield* mapAddContactEventToState(event.username);
    }
    if (event is ClickedContactEvent) {
      yield ClickedContactState(event.contact);
    }
  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContactsState();
      subscription?.cancel();
      subscription = userDataRepository.getContacts().listen((contacts)=>{print('dispatching $contacts'),dispatch(ReceivedContactsEvent(contacts))});
    } on MessioException catch(exception){
      print(exception.errorMessage());
      yield ErrorState(exception);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddContactProgressState();
      await userDataRepository.addContact(username);
      User user = await userDataRepository.getUser(username);
      await chatRepository.createChatIdForContact(user);
      yield AddContactSuccessState();
//      dispatch(FetchContactsEvent());
    } on MessioException catch(exception){
      print(exception.errorMessage());
      yield AddContactFailedState(exception);
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


}
