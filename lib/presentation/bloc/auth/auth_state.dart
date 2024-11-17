part of 'auth_cubit.dart';

enum AuthStatus{
  unknown,
  unauthenticated,
  authenticated
}

class AuthState {
  final AuthStatus status;
  final User? user;

  const AuthState({
    required this.status,
    this.user,
  });

  factory AuthState.initial(){
    return const AuthState(status: AuthStatus.unknown);
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          user == other.user;

  @override
  int get hashCode => status.hashCode ^ user.hashCode;
}
