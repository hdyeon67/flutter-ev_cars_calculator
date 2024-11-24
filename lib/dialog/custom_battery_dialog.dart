import 'package:flutter/material.dart';
import 'package:electric_cars_calculator/unit/show_toast.dart';

class CustomBatteryDialog {
  static void showCustomBatteryCapacityDialog(
    BuildContext context,
    TextEditingController controller,
    Function(double) onBatteryCapacityEntered,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Battery Capacity'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Battery Capacity (kWh)',
              border: OutlineInputBorder(),
              // prefixIcon: Icon(Icons.battery_full),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final double? enteredCapacity =
                    double.tryParse(controller.text);
                if (enteredCapacity != null) {
                  onBatteryCapacityEntered(enteredCapacity);
                  Navigator.of(context).pop();
                } else {
                  showToast('Please enter a valid number');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
