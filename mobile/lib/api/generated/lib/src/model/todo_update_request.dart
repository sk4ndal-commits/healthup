//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'todo_update_request.g.dart';

/// TodoUpdateRequest
///
/// Properties:
/// * [title]
/// * [isDone]
@BuiltValue()
abstract class TodoUpdateRequest
    implements Built<TodoUpdateRequest, TodoUpdateRequestBuilder> {
  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'isDone')
  bool? get isDone;

  TodoUpdateRequest._();

  factory TodoUpdateRequest([void updates(TodoUpdateRequestBuilder b)]) =
      _$TodoUpdateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TodoUpdateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TodoUpdateRequest> get serializer =>
      _$TodoUpdateRequestSerializer();
}

class _$TodoUpdateRequestSerializer
    implements PrimitiveSerializer<TodoUpdateRequest> {
  @override
  final Iterable<Type> types = const [TodoUpdateRequest, _$TodoUpdateRequest];

  @override
  final String wireName = r'TodoUpdateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TodoUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isDone != null) {
      yield r'isDone';
      yield serializers.serialize(
        object.isDone,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TodoUpdateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TodoUpdateRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.title = valueDes;
          break;
        case r'isDone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TodoUpdateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TodoUpdateRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
