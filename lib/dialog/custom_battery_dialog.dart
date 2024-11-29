import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:electric_cars_calculator/unit/show_toast.dart';

class CustomBatteryDialog {
  static void showCustomBatteryCapacityDialog(
    BuildContext context,
    TextEditingController controller,
    Function(double) onBatteryCapacityEntered,
  ) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.custom_battery_capacity_title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: localizations.custom_battery_capacity_hint,
              border: const OutlineInputBorder(),
              // prefixIcon: Icon(Icons.battery_full),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final double? enteredCapacity =
                    double.tryParse(controller.text);
                if (enteredCapacity != null) {
                  onBatteryCapacityEntered(enteredCapacity);
                  Navigator.of(context).pop();
                } else {
                  showToast(localizations.no_number_msg);
                }
              },
              child: Text(localizations.ok),
            ),
          ],
        );
      },
    );
  }
}
