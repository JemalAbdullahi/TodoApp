class User {
  final int id;
  //final String firstName;
  //final String lastName;
  final String emailAddress;
  final String username;
  final String password;
  final String apiKey;
  //List<String> groups;

  User(
      {//this.firstName,
      //this.lastName,
      this.emailAddress,
      this.id,
      this.apiKey,
      this.password,
      this.username});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        username: parsedJson['username'],
        //lastName: parsedJson['lastname'],
        emailAddress: parsedJson['emailaddress'],
        //firstName: parsedJson['firstname'],
        password: parsedJson['password'],
        id: parsedJson['id'],
        apiKey: parsedJson['api_key']);
  }
}
