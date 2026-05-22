// DIO singleton is provided via lib/src/core/di/providers.dart.
// Add custom API calls here if the app integrates with external REST endpoints.
//
// Example usage in a service:
//
//   class SomeApiService {
//     SomeApiService(this._dio);
//     final Dio _dio;
//
//     Future<SomeModel> fetchSomething() async {
//       final response = await _dio.get('/endpoint');
//       return SomeModel.fromJson(response.data);
//     }
//   }
