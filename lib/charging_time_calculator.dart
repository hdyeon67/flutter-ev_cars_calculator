import 'package:flutter/material.dart';
import 'dialog/battery_selection_dialog.dart'; // BatterySelectionDialog 파일 import
import 'dialog/custom_battery_dialog.dart'; // CustomBatteryDialog 파일 import
import 'data/ev_battery_capacities.dart'; // evBatteryCapacities 파일 import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChargingTimeCalculator extends StatefulWidget {
  const ChargingTimeCalculator({super.key});

  @override
  _ChargingTimeCalculatorState createState() => _ChargingTimeCalculatorState();
}

class _ChargingTimeCalculatorState extends State<ChargingTimeCalculator> {
  final TextEditingController _chargingPowerController =
      TextEditingController();
  final TextEditingController _currentChargeController =
      TextEditingController();
  final TextEditingController _targetChargeController = TextEditingController();
  final TextEditingController _customBatteryCapacityController =
      TextEditingController();

  double? _batteryCapacity;
  int? _chargingTimeHours;
  int? _chargingTimeMinutes;

  void _calculateChargingTime() {
    final double? chargingPower =
        double.tryParse(_chargingPowerController.text);
    final double? currentCharge =
        double.tryParse(_currentChargeController.text);
    final double? targetCharge = double.tryParse(_targetChargeController.text);

    if (_batteryCapacity != null &&
        chargingPower != null &&
        chargingPower > 0 &&
        currentCharge != null &&
        targetCharge != null &&
        targetCharge > currentCharge) {
      // 충전해야 할 용량 계산
      double chargeNeeded =
          (targetCharge - currentCharge) / 100 * _batteryCapacity!;

      // 충전 시간 계산
      double totalHours = chargeNeeded / chargingPower;
      _chargingTimeHours = totalHours.floor();
      _chargingTimeMinutes = ((totalHours - _chargingTimeHours!) * 60).round();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.green.shade50,
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.battery_full, color: Colors.green),
                title: Text(
                  _batteryCapacity != null
                      ? localizations.selected_battery_capacity(
                          _batteryCapacity!.toStringAsFixed(1))
                      : localizations.select_battery_capacity_msg,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    BatterySelectionDialog.showBatterySelectionDialog(
                      context,
                      evBatteryCapacities,
                      (selectedBatteryCapacity) {
                        setState(() {
                          _batteryCapacity = selectedBatteryCapacity;
                        });
                      },
                      () {
                        CustomBatteryDialog.showCustomBatteryCapacityDialog(
                          context,
                          _customBatteryCapacityController,
                          (enteredCapacity) {
                            setState(() {
                              _batteryCapacity = enteredCapacity;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputField(_currentChargeController,
                localizations.current_charge, Icons.battery_charging_full),
            const SizedBox(height: 16),
            _buildInputField(_targetChargeController,
                localizations.target_charge, Icons.battery_alert),
            const SizedBox(height: 16),
            _buildInputField(_chargingPowerController,
                localizations.charging_power, Icons.power),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _calculateChargingTime();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff536dfe),
                foregroundColor: Colors.white,
              ),
              child: Text(localizations.calculate_charging_time),
            ),
            const SizedBox(height: 16),
            if (_chargingTimeHours != null && _chargingTimeMinutes != null)
              Card(
                color: Colors.green.shade50,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.result_charging_time(
                            _chargingTimeHours, _chargingTimeMinutes),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildInputField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}
