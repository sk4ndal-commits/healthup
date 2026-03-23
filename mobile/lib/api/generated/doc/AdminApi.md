# api_client.api.AdminApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1AdminUsersGet**](AdminApi.md#apiv1adminusersget) | **GET** /api/v1/Admin/users | 
[**apiV1AdminUsersIdGet**](AdminApi.md#apiv1adminusersidget) | **GET** /api/v1/Admin/users/{id} | 
[**apiV1AdminUsersIdResetPasswordPost**](AdminApi.md#apiv1adminusersidresetpasswordpost) | **POST** /api/v1/Admin/users/{id}/reset-password | 
[**apiV1AdminUsersIdToggleActivePost**](AdminApi.md#apiv1adminusersidtoggleactivepost) | **POST** /api/v1/Admin/users/{id}/toggle-active | 
[**apiV1AdminUsersPost**](AdminApi.md#apiv1adminuserspost) | **POST** /api/v1/Admin/users | 


# **apiV1AdminUsersGet**
> apiV1AdminUsersGet()



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getAdminApi();

try {
    api.apiV1AdminUsersGet();
} catch on DioException (e) {
    print('Exception when calling AdminApi->apiV1AdminUsersGet: $e\n');
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

# **apiV1AdminUsersIdGet**
> apiV1AdminUsersIdGet(id)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getAdminApi();
final int id = 56; // int | 

try {
    api.apiV1AdminUsersIdGet(id);
} catch on DioException (e) {
    print('Exception when calling AdminApi->apiV1AdminUsersIdGet: $e\n');
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

# **apiV1AdminUsersIdResetPasswordPost**
> apiV1AdminUsersIdResetPasswordPost(id, adminResetPasswordRequest)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getAdminApi();
final int id = 56; // int | 
final AdminResetPasswordRequest adminResetPasswordRequest = ; // AdminResetPasswordRequest | 

try {
    api.apiV1AdminUsersIdResetPasswordPost(id, adminResetPasswordRequest);
} catch on DioException (e) {
    print('Exception when calling AdminApi->apiV1AdminUsersIdResetPasswordPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **adminResetPasswordRequest** | [**AdminResetPasswordRequest**](AdminResetPasswordRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminUsersIdToggleActivePost**
> apiV1AdminUsersIdToggleActivePost(id)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getAdminApi();
final int id = 56; // int | 

try {
    api.apiV1AdminUsersIdToggleActivePost(id);
} catch on DioException (e) {
    print('Exception when calling AdminApi->apiV1AdminUsersIdToggleActivePost: $e\n');
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

# **apiV1AdminUsersPost**
> apiV1AdminUsersPost(createUserRequest)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getAdminApi();
final CreateUserRequest createUserRequest = ; // CreateUserRequest | 

try {
    api.apiV1AdminUsersPost(createUserRequest);
} catch on DioException (e) {
    print('Exception when calling AdminApi->apiV1AdminUsersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createUserRequest** | [**CreateUserRequest**](CreateUserRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

