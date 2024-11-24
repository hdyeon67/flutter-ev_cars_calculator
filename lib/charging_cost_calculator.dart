import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dialog/battery_selection_dialog.dart'; // BatterySelectionDialog 파일 import
import 'dialog/custom_battery_dialog.dart'; // CustomBatteryDialog 파일 import
import 'data/ev_battery_capacities.dart'; // evBatteryCapacities 파일 import

class ChargingCostCalculator extends StatefulWidget {
  const ChargingCostCalculator({super.key});

  @override
  _ChargingCostCalculatorState createState() => _ChargingCostCalculatorState();
}

class _ChargingCostCalculatorState extends State<ChargingCostCalculator> {
  final TextEditingController _chargingRateController = TextEditingController();
  final TextEditingController _costPerKWhController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _customBatteryCapacityController =
      TextEditingController();

  double? _batteryCapacity;
  double? _totalCost;
  double? _chargedAmount;
  String _currency = 'KRW';

  void _calculateCost() {
    final double? chargingRate = double.tryParse(_chargingRateController.text);
    final double? costPerKWh = double.tryParse(_costPerKWhController.text);
    final double? hours = double.tryParse(_hourController.text);
    final double? minutes = double.tryParse(_minuteController.text);

    if (_batteryCapacity != null &&
        chargingRate != null &&
        costPerKWh != null &&
        hours != null &&
        minutes != null) {
      double totalHours = hours + (minutes / 60);
      _chargedAmount = chargingRate * totalHours;
      _totalCost = _chargedAmount! * costPerKWh;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      ? 'Battery: ${_batteryCapacity!.toStringAsFixed(1)} kWh'
                      : 'Select Battery Capacity',
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
            _buildInputField(
                _chargingRateController, 'Charging Rate (kW)', Icons.flash_on),
            const SizedBox(height: 16),
            _buildCurrencySelector(),
            const SizedBox(height: 16),
            _buildTimeInputs(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _calculateCost();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff536dfe),
                foregroundColor: Colors.white,
              ),
              child: const Text('Calculate Cost'),
            ),
            const SizedBox(height: 20),
            if (_totalCost != null && _chargedAmount != null)
              Card(
                color: Colors.green.shade50,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Charged Amount: ${_chargedAmount!.toStringAsFixed(2)} kWh',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Cost: ${_currency == 'KRW' ? '₩' : '\$'}${_totalCost!.toStringAsFixed((_currency == 'KRW' ? 0 : 2))}',
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

  Row _buildCurrencySelector() {
    return Row(
      children: [
        Expanded(
          child: _buildInputField(
              _costPerKWhController, 'Cost per kWh', Icons.credit_card),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: _currency,
          items: ['KRW', 'USD'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currency = value!;
            });
          },
        ),
      ],
    );
  }

  Row _buildTimeInputs() {
    return Row(
      children: [
        Expanded(
          child: _buildLimitedInputField(_hourController, 'Hours', Icons.timer),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildLimitedInputField(
              _minuteController, 'Minutes', Icons.timer),
        ),
      ],
    );
  }

  Widget _buildLimitedInputField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // 숫자만 허용
        LengthLimitingTextInputFormatter(2), // 최대 2자리로 제한
      ],
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
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
