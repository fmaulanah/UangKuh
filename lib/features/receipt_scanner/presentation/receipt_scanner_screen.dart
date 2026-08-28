import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/theme.dart';
import '../../../app/widgets/app_surface_card.dart';
import '../providers/receipt_scanner_providers.dart';
import 'receipt_review_screen.dart';

class ReceiptScannerScreen extends ConsumerStatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  ConsumerState<ReceiptScannerScreen> createState() =>
      _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends ConsumerState<ReceiptScannerScreen> {
  bool _isProcessing = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan Receipt',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppTheme.spaceXs),
                      Text(
                        'Take a photo or pick from gallery to auto-fill expense.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceLg),
            if (_isProcessing)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: AppTheme.spaceMd),
                      Text('Processing receipt...'),
                    ],
                  ),
                ),
              )
            else ...[
              AppSurfaceCard(
                onTap: () => _pickImage(ImageSource.camera),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.10),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Take Photo',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppTheme.spaceXs),
                          Text(
                            'Use camera to capture receipt',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spaceSm),
              AppSurfaceCard(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.10),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(
                        Icons.photo_library_rounded,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pick from Gallery',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppTheme.spaceXs),
                          Text(
                            'Select an existing receipt photo',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppTheme.spaceMd),
                AppSurfaceCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppTheme.danger,
                      ),
                      const SizedBox(width: AppTheme.spaceSm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.danger,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return;
      }

      if (!mounted) return;

      setState(() {
        _isProcessing = true;
      });

      final ocrService = ref.read(receiptOcrServiceProvider);
      final rawText = await ocrService.recognizeTextFromPath(pickedFile.path);

      if (!mounted) return;

      if (rawText.trim().isEmpty) {
        setState(() {
          _isProcessing = false;
          _errorMessage =
              'Could not read any text from the image. Try a clearer photo.';
        });
        return;
      }

      final parser = ref.read(receiptParserProvider);
      final draft = parser.parse(rawText);

      setState(() {
        _isProcessing = false;
      });

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReceiptReviewScreen(draft: draft),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isProcessing = false;
        _errorMessage = 'Failed to process receipt. Please try again.';
      });
    }
  }
}
