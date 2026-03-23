# api_client.api.TodoApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1TodoGet**](TodoApi.md#apiv1todoget) | **GET** /api/v1/Todo | 
[**apiV1TodoIdDelete**](TodoApi.md#apiv1todoiddelete) | **DELETE** /api/v1/Todo/{id} | 
[**apiV1TodoIdGet**](TodoApi.md#apiv1todoidget) | **GET** /api/v1/Todo/{id} | 
[**apiV1TodoIdPut**](TodoApi.md#apiv1todoidput) | **PUT** /api/v1/Todo/{id} | 
[**apiV1TodoIdTogglePost**](TodoApi.md#apiv1todoidtogglepost) | **POST** /api/v1/Todo/{id}/toggle | 
[**apiV1TodoPost**](TodoApi.md#apiv1todopost) | **POST** /api/v1/Todo | 


# **apiV1TodoGet**
> apiV1TodoGet()



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getTodoApi();

try {
    api.apiV1TodoGet();
} catch on DioException (e) {
    print('Exception when calling TodoApi->apiV1TodoGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1TodoIdDelete**
> apiV1TodoIdDelete(id)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getTodoApi();
final int id = 56; // int | 

try {
    api.apiV1TodoIdDelete(id);
} catch on DioException (e) {
    print('Exception when calling TodoApi->apiV1TodoIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1TodoIdGet**
> apiV1TodoIdGet(id)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getTodoApi();
final int id = 56; // int | 

try {
    api.apiV1TodoIdGet(id);
} catch on DioException (e) {
    print('Exception when calling TodoApi->apiV1TodoIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1TodoIdPut**
> apiV1TodoIdPut(id, todoUpdateRequest)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getTodoApi();
final int id = 56; // int | 
final TodoUpdateRequest todoUpdateRequest = ; // TodoUpdateRequest | 

try {
    api.apiV1TodoIdPut(id, todoUpdateRequest);
} catch on DioException (e) {
    print('Exception when calling TodoApi->apiV1TodoIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **todoUpdateRequest** | [**TodoUpdateRequest**](TodoUpdateRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1TodoIdTogglePost**
> apiV1TodoIdTogglePost(id)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getTodoApi();
final int id = 56; // int | 

try {
    api.apiV1TodoIdTogglePost(id);
} catch on DioException (e) {
    print('Exception when calling TodoApi->apiV1TodoIdTogglePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1TodoPost**
> apiV1TodoPost(todoCreateRequest)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getTodoApi();
final TodoCreateRequest todoCreateRequest = ; // TodoCreateRequest | 

try {
    api.apiV1TodoPost(todoCreateRequest);
} catch on DioException (e) {
    print('Exception when calling TodoApi->apiV1TodoPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **todoCreateRequest** | [**TodoCreateRequest**](TodoCreateRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

