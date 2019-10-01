

import 'package:messio/blocs/authentication/repository/AuthenticationRepository.dart';
import 'package:messio/blocs/authentication/repository/StorageRepository.dart';
import 'package:messio/blocs/authentication/repository/UserDataRepository.dart';
import 'package:mockito/mockito.dart';

class AuthenticationRepositoryMock extends Mock implements AuthenticationRepository{}
class UserDataRepositoryMock extends Mock implements UserDataRepository{}
class StorageRepositoryMock extends Mock implements StorageRepository{}