

class AuthModel {
  final String uid;
  final String email;
  final String? name;
  final String? imageUrl;

  AuthModel({
    required this.uid,
    required this.email,
    this.name,
    this.imageUrl,
  });

// Factory constructor to create an AuthModel from a Firebase User object
// factory AuthModel.fromFirebaseUser( user) {
//   return AuthModel(
//     uid: user.uid,
//     email: user.email!,
// name: user.name,
//     photoURL: user.photoURL,
//   );
// }
}