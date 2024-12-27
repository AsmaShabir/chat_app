
//The colon is used to initialize fields, invoke parent class constructors,
// or set values that require some processing before the constructor’s body runs.
// The fields initialized in this way will have their values set even before the constructor body starts executing.


import 'package:chat_app/data/response/status.dart';


class ApiResponse<T>{
  Status? status;
  T? data;
  String? message;

  ApiResponse(this.status,this.data,this.message);

  ApiResponse.loading():status = Status.LOADING;

  ApiResponse.completed(this.data):status = Status.COMPLETED;

  ApiResponse.error(this.message):status = Status.ERROR;

  @override
  String toString(){
    return "Status: $status \n Message: $message \n data: $data ";
  }

}