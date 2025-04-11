class SignUpModel {
  final String firstName;
  final String lastName;
  final String phone;
  final String countryCode;
  final String email;

  SignUpModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.countryCode,
    required this.email,
  });


  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
      'countrycode': countryCode,
      'email': email,
    };
  }


  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      firstName: json['firstname'],
      lastName: json['lastname'],
      phone: json['phone'],
      countryCode: json['countrycode'],
      email: json['email'],
    );
  }
}
