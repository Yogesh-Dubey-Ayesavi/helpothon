import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_config.dart';

class WebViewScreen extends StatefulWidget {
  final AppConfig config;

  const WebViewScreen({super.key, required this.config});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _controller;
  bool _isLoading = true;
  String _currentUrl = '';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setTransparentStatusBar();
  }

  void _setTransparentStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> _launchExternalUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  Future<void> _handleDataUriDownload(
    String dataUri,
    String? suggestedFilename,
  ) async {
    try {
      final Uri uri = Uri.parse(dataUri);
      final String mimeType = uri.data?.mimeType ?? 'application/octet-stream';
      final Uint8List bytes = uri.data?.contentAsBytes() ?? Uint8List(0);

      if (bytes.isEmpty) {
        throw Exception('No data found in URI');
      }

      String filename = suggestedFilename ?? 'download';
      if (!filename.contains('.')) {
        String extension = _getExtensionFromMimeType(mimeType);
        filename = '$filename$extension';
      }

      final String downloadPath = await _getDownloadPath();
      String filePath = '$downloadPath/$filename';

      // Handle file name conflicts
      filePath = await _resolveFileNameConflicts(
        filePath,
        filename,
        downloadPath,
      );

      // Write file
      final File file = File(filePath);
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloaded: ${file.path.split('/').last}'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () => _openFile(filePath),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error downloading data URI: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      }
    }
  }

  Future<String> _resolveFileNameConflicts(
    String filePath,
    String filename,
    String downloadPath,
  ) async {
    int counter = 1;
    String originalFilename = filename;
    String currentFilePath = filePath;

    while (await File(currentFilePath).exists()) {
      String nameWithoutExt = originalFilename.split('.').first;
      String ext =
          originalFilename.contains('.')
              ? '.${originalFilename.split('.').last}'
              : '';
      String newFilename = '${nameWithoutExt}_$counter$ext';
      currentFilePath = '$downloadPath/$newFilename';
      counter++;
    }

    return currentFilePath;
  }

  String _getExtensionFromMimeType(String mimeType) {
    const Map<String, String> mimeTypeMap = {
      'image/png': '.png',
      'image/jpeg': '.jpg',
      'image/jpg': '.jpg',
      'image/gif': '.gif',
      'image/webp': '.webp',
      'image/svg+xml': '.svg',
      'text/plain': '.txt',
      'text/html': '.html',
      'application/pdf': '.pdf',
      'application/json': '.json',
      'application/zip': '.zip',
    };

    return mimeTypeMap[mimeType.toLowerCase()] ?? '.bin';
  }

  Future<void> _openFile(String filePath) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await OpenFile.open(filePath);
      }
    } catch (e) {
      debugPrint('Error opening file: $e');
    }
  }

  Future<String> _getDownloadPath() async {
    Directory? directory;

    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (e) {
      debugPrint('Error getting download path: $e');
      directory = await getApplicationDocumentsDirectory();
    }

    return directory?.path ?? '';
  }

  Future<void> _handleBlobDownload(
    InAppWebViewController controller,
    String url,
    String? suggestedFilename,
  ) async {
    try {
      final result = await controller.evaluateJavascript(
        source: '''
          (function() {
            return new Promise((resolve, reject) => {
              fetch('$url')
                .then(response => response.blob())
                .then(blob => {
                  const reader = new FileReader();
                  reader.onloadend = function() {
                    resolve(reader.result);
                  };
                  reader.onerror = function() {
                    reject('Failed to read blob');
                  };
                  reader.readAsDataURL(blob);
                })
                .catch(error => reject(error.message));
            });
          })();
        ''',
      );

      if (result != null && result.toString().startsWith('data:')) {
        await _handleDataUriDownload(result.toString(), suggestedFilename);
      } else {
        throw Exception('Failed to convert blob to data URL');
      }
    } catch (e) {
      debugPrint('Error converting blob URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Blob download failed: $e')));
      }
    }
  }

  Future<void> _handleRegularDownload(
    String url,
    String? suggestedFilename,
  ) async {
    try {
      final downloadPath = await _getDownloadPath();
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: downloadPath,
        fileName: suggestedFilename,
        showNotification: true,
        saveInPublicStorage: true,
        openFileFromNotification: true,
      );
      debugPrint("Download task created with ID: $taskId");
    } catch (e) {
      debugPrint("Error downloading file: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      }
    }
  }

  void _injectJavaScript(InAppWebViewController controller) {
    controller.evaluateJavascript(
      source: '''
        // Enhanced error handling
        window.addEventListener('error', function(event) {
          console.log('JavaScript Error:', event.error);
          window.flutter_inappwebview.callHandler('FlutterApp', 'Error: ' + event.error.message);
        });
        
        // Blob download handler
        window.downloadBlob = function(blobUrl, filename) {
          fetch(blobUrl)
            .then(response => response.blob())
            .then(blob => {
              const reader = new FileReader();
              reader.onloadend = function() {
                const base64data = reader.result;
                window.flutter_inappwebview.callHandler('BlobDownload', {
                  data: base64data,
                  filename: filename || 'download.bin'
                });
              };
              reader.readAsDataURL(blob);
            })
            .catch(error => {
              console.error('Error downloading blob:', error);
              window.flutter_inappwebview.callHandler('FlutterApp', 'Blob download error: ' + error.message);
            });
        };
        
        // Override default download behavior for blob URLs
        document.addEventListener('click', function(event) {
          const element = event.target;
          if (element.tagName === 'A' && element.href && element.href.startsWith('blob:')) {
            event.preventDefault();
            const filename = element.download || element.href.split('/').pop() || 'download.bin';
            window.downloadBlob(element.href, filename);
          }
        });
        
        // File input support
        document.addEventListener('change', function(event) {
          if (event.target.type === 'file') {
            console.log('File input detected:', event.target.files);
            window.flutter_inappwebview.callHandler('FlutterApp', 'File input: ' + event.target.files.length + ' files selected');
          }
        });
        
        // Override console methods
        var originalLog = console.log;
        console.log = function() {
          originalLog.apply(console, arguments);
          window.flutter_inappwebview.callHandler('FlutterApp', 'Log: ' + Array.from(arguments).join(' '));
        };
        
        var originalError = console.error;
        console.error = function() {
          originalError.apply(console, arguments);
          window.flutter_inappwebview.callHandler('FlutterApp', 'Error: ' + Array.from(arguments).join(' '));
        };
        
        // Notify that JavaScript is ready
        window.flutter_inappwebview.callHandler('FlutterApp', 'JavaScript ready');
      ''',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.config.url)),
              initialSettings: InAppWebViewSettings(
                useOnDownloadStart: true,
                allowFileAccess: true,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                userAgent:
                    "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
                supportZoom: false,
                builtInZoomControls: false,
                displayZoomControls: false,
                useShouldOverrideUrlLoading: true,
                useOnLoadResource: true,
                clearCache: false,
                clearSessionCache: false,
                geolocationEnabled: true,
              ),
              onDownloadStartRequest: (controller, downloadStartRequest) async {
                final String url = downloadStartRequest.url.toString();
                debugPrint("Download requested for: $url");

                if (url.startsWith('data:')) {
                  await _handleDataUriDownload(
                    url,
                    downloadStartRequest.suggestedFilename,
                  );
                } else if (url.startsWith('blob:')) {
                  await _handleBlobDownload(
                    controller,
                    url,
                    downloadStartRequest.suggestedFilename,
                  );
                } else {
                  await _handleRegularDownload(
                    url,
                    downloadStartRequest.suggestedFilename,
                  );
                }
              },
              onWebViewCreated: (InAppWebViewController controller) {
                _controller = controller;

                controller.addJavaScriptHandler(
                  handlerName: 'FlutterApp',
                  callback: (args) {
                    debugPrint('JavaScript message: ${args[0]}');
                  },
                );

                controller.addJavaScriptHandler(
                  handlerName: 'BlobDownload',
                  callback: (args) async {
                    try {
                      final data = args[0];
                      final dataUrl = data['data'] as String;
                      final filename = data['filename'] as String;

                      debugPrint('Blob download requested for: $filename');
                      await _handleDataUriDownload(dataUrl, filename);
                    } catch (e) {
                      debugPrint('Error handling blob download: $e');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Blob download failed: $e')),
                        );
                      }
                    }
                  },
                );
              },
              onLoadStart: (InAppWebViewController controller, WebUri? url) {
                setState(() {
                  _isLoading = true;
                  _currentUrl = url?.toString() ?? '';
                });
              },
              onLoadStop: (
                InAppWebViewController controller,
                WebUri? url,
              ) async {
                setState(() {
                  _isLoading = false;
                  _currentUrl = url?.toString() ?? '';
                });

                _injectJavaScript(controller);
              },
              onProgressChanged: (
                InAppWebViewController controller,
                int progress,
              ) {
                setState(() {
                  _progress = progress / 100.0;
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();

                if (url.contains(Uri.parse(widget.config.url).host)) {
                  return NavigationActionPolicy.ALLOW;
                }

                _launchExternalUrl(url);
                return NavigationActionPolicy.CANCEL;
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },
              onConsoleMessage: (controller, consoleMessage) {
                debugPrint('Console: ${consoleMessage.message}');
              },
              onReceivedError: (controller, request, error) {
                debugPrint('WebView Error: ${error.description}');
              },
            ),
            if (_isLoading)
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _progress > 0 ? _progress : null,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.config.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading ${widget.config.name}...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
