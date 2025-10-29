class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.addresses = const <String>[],
    this.paymentMethods = const <String>[],
    this.notificationsEnabled = true,
    this.twoFactorEnabled = false,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final List<String> addresses;
  final List<String> paymentMethods;
  final bool notificationsEnabled;
  final bool twoFactorEnabled;

  User copyWith({
    String? name,
    String? email,
    String? phone,
    List<String>? addresses,
    List<String>? paymentMethods,
    bool? notificationsEnabled,
    bool? twoFactorEnabled,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      addresses: (json['addresses'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      paymentMethods: (json['paymentMethods'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'addresses': addresses,
        'paymentMethods': paymentMethods,
        'notificationsEnabled': notificationsEnabled,
        'twoFactorEnabled': twoFactorEnabled,
      };
}
