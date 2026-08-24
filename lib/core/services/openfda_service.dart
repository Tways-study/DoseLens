import '../constants/api_constants.dart';
import '../network/dio_client.dart';

/// OpenFDA Public Drug Label Lookup Service
class OpenFdaService {
  final DioClient _dioClient;

  OpenFdaService({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  /// Search drug information by generic or brand name
  Future<Map<String, dynamic>?> searchDrug(String drugName) async {
    try {
      final sanitizedName = drugName.trim().replaceAll(' ', '+');
      final query = 'openfda.brand_name:"$sanitizedName"+openfda.generic_name:"$sanitizedName"';

      final response = await _dioClient.get(
        ApiConstants.openFdaBaseUrl,
        queryParameters: {
          'search': query,
          'limit': 1,
        },
      );

      final results = response.data['results'] as List?;
      if (results != null && results.isNotEmpty) {
        return results.first as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
