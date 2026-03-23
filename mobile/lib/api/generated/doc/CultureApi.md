# api_client.api.CultureApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**cultureSetCulturePost**](CultureApi.md#culturesetculturepost) | **POST** /Culture/SetCulture | 


# **cultureSetCulturePost**
> cultureSetCulturePost(culture, returnUrl)



### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: Bearer
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('Bearer').apiKeyPrefix = 'Bearer';

final api = ApiClient().getCultureApi();
final String culture = culture_example; // String | 
final String returnUrl = returnUrl_example; // String | 

try {
    api.cultureSetCulturePost(culture, returnUrl);
} catch on DioException (e) {
    print('Exception when calling CultureApi->cultureSetCulturePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **culture** | **String**|  | [optional] 
 **returnUrl** | **String**|  | [optional] 

### Return type

void (empty response body)

### Authorization

[Bearer](../README.md#Bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

