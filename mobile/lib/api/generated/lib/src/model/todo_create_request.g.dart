// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_create_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TodoCreateRequest extends TodoCreateRequest {
  @override
  final String? title;

  factory _$TodoCreateRequest([
    void Function(TodoCreateRequestBuilder)? updates,
  ]) => (TodoCreateRequestBuilder()..update(updates))._build();

  _$TodoCreateRequest._({this.title}) : super._();
  @override
  TodoCreateRequest rebuild(void Function(TodoCreateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TodoCreateRequestBuilder toBuilder() =>
      TodoCreateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TodoCreateRequest && title == other.title;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'TodoCreateRequest',
    )..add('title', title)).toString();
  }
}

class TodoCreateRequestBuilder
    implements Builder<TodoCreateRequest, TodoCreateRequestBuilder> {
  _$TodoCreateRequest? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  TodoCreateRequestBuilder() {
    TodoCreateRequest._defaults(this);
  }

  TodoCreateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TodoCreateRequest other) {
    _$v = other as _$TodoCreateRequest;
  }

  @override
  void update(void Function(TodoCreateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TodoCreateRequest build() => _build();

  _$TodoCreateRequest _build() {
    final _$result = _$v ?? _$TodoCreateRequest._(title: title);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
