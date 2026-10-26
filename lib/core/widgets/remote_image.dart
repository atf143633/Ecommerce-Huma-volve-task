import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RemoteImage extends StatefulWidget {
  const RemoteImage({
    required this.url,
    required this.errorBuilder,
    this.fit,
    this.width,
    this.height,
    super.key,
  });

  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final ImageErrorWidgetBuilder errorBuilder;

  @override
  State<RemoteImage> createState() => _RemoteImageState();
}

class _RemoteImageState extends State<RemoteImage> {
  static final Dio _dio = Dio();

  late Future<Uint8List> _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = _loadImage(widget.url);
  }

  @override
  void didUpdateWidget(covariant RemoteImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _imageBytes = _loadImage(widget.url);
    }
  }

  Future<Uint8List> _loadImage(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null ||
          !const {'http', 'https'}.contains(uri.scheme) ||
          uri.host.isEmpty) {
        throw const FormatException('Expected an absolute HTTP(S) image URL.');
      }

      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final contentType = response.headers
          .value(Headers.contentTypeHeader)
          ?.split(';')
          .first
          .trim()
          .toLowerCase();
      if (contentType == null ||
          !contentType.startsWith('image/') ||
          contentType == 'image/svg+xml') {
        throw FormatException(
          'Expected raster image data, received ${contentType ?? 'no Content-Type'}.',
        );
      }

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        throw const FormatException('Image response was empty.');
      }
      return Uint8List.fromList(bytes);
    } on DioException catch (error, stackTrace) {
      debugPrint('Product image request failed for $url: ${error.message}');
      Error.throwWithStackTrace(error, stackTrace);
    } on FormatException catch (error, stackTrace) {
      debugPrint('Invalid product image response for $url: $error');
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _imageBytes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorBuilder(
            context,
            snapshot.error!,
            snapshot.stackTrace,
          );
        }
        if (!snapshot.hasData) {
          return const SizedBox.expand();
        }
        return Image.memory(
          snapshot.data!,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          errorBuilder: widget.errorBuilder,
        );
      },
    );
  }
}
