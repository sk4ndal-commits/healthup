//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'todo_create_request.g.dart';

/// TodoCreateRequest
///
/// Properties:
/// * [title]
@BuiltValue()
abstract class TodoCreateRequest
    implements Built<TodoCreateRequest, TodoCreateRequestBuilder> {
  @BuiltValueField(wireName: r'title')
  String? get title;

  TodoCreateRequest._();

  factory TodoCreateRequest([void updates(TodoCreateRequestBuilder b)]) =
      _$TodoCreateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TodoCreateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TodoCreateRequest> get serializer =>
      _$TodoCreateRequestSerializer();
}

class _$TodoCreateRequestSerializer
    implements PrimitiveSerializer<TodoCreateRequest> {
  @override
  final Iterable<Type> types = const [TodoCreateRequest, _$TodoCreateRequest];

  @override
  final String wireName = r'TodoCreateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TodoCreateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TodoCreateRequest object, {
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
    required TodoCreateRequestBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TodoCreateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TodoCreateRequestBuilder();
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
