// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reset_password_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminResetPasswordRequest extends AdminResetPasswordRequest {
  @override
  final String? newPassword;

  factory _$AdminResetPasswordRequest(
          [void Function(AdminResetPasswordRequestBuilder)? updates]) =>
      (AdminResetPasswordRequestBuilder()..update(updates))._build();

  _$AdminResetPasswordRequest._({this.newPassword}) : super._();
  @override
  AdminResetPasswordRequest rebuild(
          void Function(AdminResetPasswordRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminResetPasswordRequestBuilder toBuilder() =>
      AdminResetPasswordRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminResetPasswordRequest &&
        newPassword == other.newPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminResetPasswordRequest')
          ..add('newPassword', newPassword))
        .toString();
  }
}

class AdminResetPasswordRequestBuilder
    implements
        Builder<AdminResetPasswordRequest, AdminResetPasswordRequestBuilder> {
  _$AdminResetPasswordRequest? _$v;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  AdminResetPasswordRequestBuilder() {
    AdminResetPasswordRequest._defaults(this);
  }

  AdminResetPasswordRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _newPassword = $v.newPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminResetPasswordRequest other) {
    _$v = other as _$AdminResetPasswordRequest;
  }

  @override
  void update(void Function(AdminResetPasswordRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminResetPasswordRequest build() => _build();

  _$AdminResetPasswordRequest _build() {
    final _$result = _$v ??
        _$AdminResetPasswordRequest._(
          newPassword: newPassword,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
