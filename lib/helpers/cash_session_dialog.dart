import 'package:flutter/material.dart';
import 'package:localix/data/tables/cash_sesion.dart';
import 'package:localix/features/app_page/presentation/app_page.dart';
import 'package:localix/helpers/cash_service.dart';

class CashSessionDialog {
  static bool _dialogShowing = false;

  static Future<bool> showPendingSessionDialog(
    BuildContext context,
    CashSessionValidation validation,
  ) async {
    if (_dialogShowing) {
      return false;
    }

    _dialogShowing = true;
    try {
      final titleMap = {
        CloseReason.forced: 'App se cerró inesperadamente',
        CloseReason.dayClosed: 'Caja abierta desde otro día',
        CloseReason.inactivity: 'Inactividad detectada',
        CloseReason.temporallyClosed: 'Sesión temporal pendiente',
      };

      final title = titleMap[validation.closeReason] ?? 'Sesión pendiente';
      final color = validation.closeReason == CloseReason.forced
          ? Colors.red
          : PuventColors.primaryGreen.color;

      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                      Icon(
                        validation.closeReason == CloseReason.forced
                            ? Icons.warning_rounded
                            : validation.closeReason == CloseReason.dayClosed
                                ? Icons.calendar_today
                                : Icons.phone_android,
                        color: color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    validation.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 5,
                    softWrap: true,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Text(
                    validation.closeReason == CloseReason.forced
                        ? 'Considera que CERRAR terminará con la sesión actual.'
                        : 'Considera que CERRAR terminará con la sesión actual y CONTINUAR reanudará la sesión.',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 3,
                    softWrap: true,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cerrar Caja'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

      return result ?? false;
    } finally {
      _dialogShowing = false;
    }
  }
}
