// abstraction in oops is an essential feature of oop which implies only keeping the essentials and removing unnecessary information.
//you can declare fields that are not static and final,and define public,protected,and private concrete methods.
abstract class BaseApiService{

  Future<dynamic>getGetApiResponse(String url);
  Future<dynamic>getPostApiResponse(String url,dynamic data);

}