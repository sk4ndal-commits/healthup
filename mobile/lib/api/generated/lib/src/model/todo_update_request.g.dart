// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_update_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TodoUpdateRequest extends TodoUpdateRequest {
  @override
  final String? title;
  @override
  final bool? isDone;

  factory _$TodoUpdateRequest([
    void Function(TodoUpdateRequestBuilder)? updates,
  ]) => (TodoUpdateRequestBuilder()..update(updates))._build();

  _$TodoUpdateRequest._({this.title, this.isDone}) : super._();
  @override
  TodoUpdateRequest rebuild(void Function(TodoUpdateRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TodoUpdateRequestBuilder toBuilder() =>
      TodoUpdateRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TodoUpdateRequest &&
        title == other.title &&
        isDone == other.isDone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, isDone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TodoUpdateRequest')
          ..add('title', title)
          ..add('isDone', isDone))
        .toString();
  }
}

class TodoUpdateRequestBuilder
    implements Builder<TodoUpdateRequest, TodoUpdateRequestBuilder> {
  _$TodoUpdateRequest? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  bool? _isDone;
  bool? get isDone => _$this._isDone;
  set isDone(bool? isDone) => _$this._isDone = isDone;

  TodoUpdateRequestBuilder() {
    TodoUpdateRequest._defaults(this);
  }

  TodoUpdateRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _isDone = $v.isDone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TodoUpdateRequest other) {
    _$v = other as _$TodoUpdateRequest;
  }

  @override
  void update(void Function(TodoUpdateRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TodoUpdateRequest build() => _build();

  _$TodoUpdateRequest _build() {
    final _$result = _$v ?? _$TodoUpdateRequest._(title: title, isDone: isDone);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
