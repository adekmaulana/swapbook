import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constant.dart';
import '../interceptors/auth.interceptor.dart';

class ApiService extends GetxService {
  ApiService();

  static final _options = BaseOptions(
    baseUrl: AppUrl.baseUrl,
    connectTimeout: const Duration(milliseconds: AppUrl.connectionTimeout),
    receiveTimeout: const Duration(milliseconds: AppUrl.receiveTimeout),
    responseType: ResponseType.json,
    contentType: Headers.jsonContentType,
    headers: {
      HttpHeaders.acceptHeader: Headers.jsonContentType,
    },
    extra: {
      'withCredentials': true,
      'withXSRFToken': true,
    },
    validateStatus: (status) {
      return status != null && status >= 200 && status < 500;
    },
  );

  Dio get dio => _dio;

  // dio instance
  final Dio _dio = Dio(_options)
    ..interceptors.addAll(
      [
        AuthInterceptor(),
        PrettyDioLogger(
          requestHeader: kDebugMode ? true : false,
          requestBody: kDebugMode ? true : false,
          responseBody: kDebugMode ? true : false,
          error: true,
          compact: true,
          logPrint: (o) => log(o.toString(), name: 'DIO'),
        ),
      ],
    );

  Future<Response> get(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e, stack) {
      await _sendToFirebaseCrashlytics(
        e,
        stack,
        'error while doing "GET" request',
        url,
        data,
        queryParameters,
      );
      rethrow;
    }
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e, stack) {
      await _sendToFirebaseCrashlytics(
        e,
        stack,
        'error while doing "POST" request',
        url,
        data,
        queryParameters,
      );
      rethrow;
    }
  }

  Future<void> _sendToFirebaseCrashlytics(
    dynamic error,
    StackTrace? stack,
    String reason,
    String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  ) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      reason: reason,
      information: [
        'url: "$url"',
        'data: ${data is FormData ? data : data is Map ? jsonEncode(data) : data}',
        'queryParameters: ${jsonEncode(queryParameters)}',
      ],
    );
  }
}
