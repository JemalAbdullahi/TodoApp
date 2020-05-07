class User{

  final int id;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String userName;
  final String password;
  final String apiKey;
  List<String> groups;

  User({this.firstName, this.lastName, this.emailAddress, this.id, this.apiKey,this.password, this.userName});
}