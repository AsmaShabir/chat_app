
class AppException implements Exception{
  final _message;
  final _prefix;
  AppException([this._message,this._prefix]);

  String toString(){
    return '$_message$_prefix';
  }
}

class fetchDataException extends AppException{
  fetchDataException([String? message ]):super(message,'Error during communication');
}

class badRequestException extends AppException{
  badRequestException([String? message ]):super(message,'Invalid request');
}

class unauthorizedException extends AppException{
  unauthorizedException([String? message ]):super(message,'Unauthorized request');
}

class invalidInputException extends AppException{
  invalidInputException([String? message ]):super(message,'Invalid input');
}
class storeDataException extends AppException{
  storeDataException([String? message ]):super(message,'failed to store data');
}