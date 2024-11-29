import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BatterySelectionDialog {
  static void showBatterySelectionDialog(
    BuildContext context,
    Map<String, double> batteryCapacities,
    Function(double) onBatterySelected,
    Function() onCustomBatteryPressed, // CustomBatteryDialog 호출 콜백
  ) {
    final localizations = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          // height: 800,
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 40,
            bottom: 40,
          ), //
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white, // 모달 배경색
            borderRadius: BorderRadius.all(
              Radius.circular(20), // 모달 전체 라운딩 처리
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.select_battery_capacity_msg,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: batteryCapacities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final carModel = batteryCapacities.keys.elementAt(index);
                    final capacity = batteryCapacities[carModel]!;
                    return ListTile(
                      leading: const Icon(
                        Icons.battery_full,
                        color: Colors.green,
                      ),
                      title: Text(
                        carModel,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('$capacity kWh'),
                      onTap: () {
                        onBatterySelected(capacity);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // 기존 다이얼로그 닫기
                  onCustomBatteryPressed(); // 사용자 정의 배터리 용량 입력 호출
                },
                icon: const Icon(Icons.edit, color: Colors.blue),
                label: Text(
                  localizations.custom_battery_capacity_enter_msg,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
