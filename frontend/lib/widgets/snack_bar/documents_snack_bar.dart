import 'package:erp_frontend_v2/constants/style.dart';
import 'package:erp_frontend_v2/models/app_localizations.dart';
import 'package:erp_frontend_v2/models/document/document_model.dart';
import 'package:erp_frontend_v2/providers/document/document_provider.dart';
import 'package:erp_frontend_v2/services/eFactura.dart';
import 'package:erp_frontend_v2/widgets/eFactura/efactura_button.dart';
import 'package:erp_frontend_v2/widgets/buttons/tertiary_button.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/custom_toast.dart';
import 'package:erp_frontend_v2/widgets/dialog_widgets/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

OverlayEntry? _snackBarOverlayEntry;

void showCustomSnackBar(BuildContext context,
    {required List<String> selectedIds,
    required VoidCallback onClose,
    required WidgetRef ref}) {
  // If no rows are selected, hide the snack bar
  if (selectedIds.isEmpty) {
    hideCustomSnackBar();
    return;
  }

  // Remove the existing overlay if it exists
  _snackBarOverlayEntry?.remove();

  // Create a new overlay entry and show it
  _snackBarOverlayEntry =
      _buildOverlayEntry(context, selectedIds, onClose, ref);
  Overlay.of(context).insert(_snackBarOverlayEntry!);
}

OverlayEntry _buildOverlayEntry(BuildContext context, List<String> selectedIds,
    VoidCallback onClose, WidgetRef ref) {
  return OverlayEntry(
    builder: (context) => Positioned(
      bottom: 8,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: _CustomSnackBarContent(
          selectedIds: selectedIds,
          onClose: onClose,
          ref: ref,
        ),
      ),
    ),
  );
}

void hideCustomSnackBar() {
  _snackBarOverlayEntry?.remove();
  _snackBarOverlayEntry = null;
}

class _CustomSnackBarContent extends StatelessWidget {
  final List<String> selectedIds;
  final VoidCallback onClose;
  final WidgetRef ref;

  const _CustomSnackBarContent({
    Key? key,
    required this.selectedIds,
    required this.onClose,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final documentState = ref.watch(documentNotifierProvider);
    return documentState.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      data: (documentList) {
        // Filter the documentList to only include selected documents
        final filteredDocuments = documentList.where((document) {
          return selectedIds.contains(document.hId);
        }).toList();

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: CustomStyle.customContainerDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: true,
                  backgroundColor: CustomColor.bgDark),
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Show the count of selected documents
                  Text(
                    '${filteredDocuments.length} ${'select_count'.tr(context)}',
                    style: CustomStyle.bold16(color: CustomColor.textSecondary),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  eFacturaButton(
                    asyncOnTap: () async {
                      // Check if any filtered documents have specific statuses
                      if (filteredDocuments.any(
                        (document) =>
                            document.eFactura?.status == 'success' ||
                            document.eFactura?.status == 'new',
                      )) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningCustomDialog(
                              type: WarningType.error,
                              title: 'error'.tr(context),
                              subtitle: 'send_eInvoice_error'.tr(context),
                              primaryButtonText: 'close'.tr(context),
                              primaryButtonAction: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      } else {
                        // Get document IDs from filtered documents
                        List<String> documentIds = filteredDocuments
                            .map((document) => document.hId ?? '')
                            .toList();
                        await _sendEfactura(context, documentIds, false, ref);
                      }
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  InkWell(
                    onTap: onClose,
                    child: const Icon(
                      Icons.close,
                      color: CustomColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () {
        return Container(); // Or show a loading indicator
      },
      error: (error, stackTrace) {
        return Text("Error: $error");
      },
    );
  }
}

Future<void> _sendEfactura(BuildContext context, List<String> documentIds,
    bool regenarate, WidgetRef ref) async {
  try {
    await EfacturaService().uploadEfacturaDocument(
      hIdList: documentIds,
      regenerate: regenarate,
    );
    ref.read(documentNotifierProvider.notifier).refreshDocuments();
  } catch (error) {
    showToast('error_try_again'.tr(context), ToastType.error);
  }
}
