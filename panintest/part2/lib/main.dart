import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const TransferPage(),
    );
  }
}

class TransferPageController extends GetxController {
  static const int _saldo = 2_000_000;
  final RxString tujuan = RxString('');
  final RxInt nominal = RxInt(0);
  final RxBool isDisabled = true.obs;
  final RxnString error = RxnString();
  bool transferOnProgress = false;

  void onTransferTapped() async {
    if (isDisabled.isTrue) {
      return;
    }
    if ((await _askPin()) != true) {
      return;
    }
    isDisabled.value = true;
    if (transferOnProgress) return;
    transferOnProgress = true;
    late final bool callApiResult;
    try {
      callApiResult = await _callApi();
    } catch (e) {
      error.value = e.toString();
    } finally {
      transferOnProgress = false;
      isDisabled.value = false;
    }
    if (!callApiResult) {
      error.value = 'Something Wrong';
    }
  }

  Future<bool?> _askPin() {
    return Get.bottomSheet<bool>(
      PinBottonSheet(),
      backgroundColor: Colors.white,
    );
  }

  Future<bool> _callApi() async {
    await Future.delayed(const Duration(seconds: 3), () => true);
    print('API CALLED');
    return true;
  }

  bool _isValid(int nominal) {
    if (tujuan.isEmpty) return false;
    if (nominal == 0) return false;
    if (nominal > _saldo) return false;
    return true;
  }

  @override
  void onReady() {
    everAll([tujuan, nominal, isDisabled], (_) {
      isDisabled.value = !_isValid(nominal.value);
    });
    super.onReady();
  }
}

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Secure Transfer'),
    ),
    body: GetBuilder<TransferPageController>(
      init: TransferPageController(),
      builder: (c) => Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextField(onChanged: c.tujuan.call),
            const Spacer(),
            TextField(onChanged: (v) => c.nominal.value = int.tryParse(v) ?? 0),
            const Spacer(flex: 5),
            Obx(
              () => ElevatedButton(
                onPressed: c.isDisabled.value ? null : c.onTransferTapped,
                child: const Text('Transfer'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PinBottonSheetController extends GetxController {
  final List<int> rndNums = List<int>.generate(10, (v) => v)..shuffle();
  final RxString pin = RxString('');
  final RxnBool isCorrect = RxnBool();
  static const _correctPin = '123456';

  void onTap(int v) {
    pin.value += v.toString();
    print(pin.value);
    if (pin.value.length >= 6) {
      if (_correctPin == pin.value) {
        print('correct');
        Get.back<bool>(result: true);
      } else {
        pin.value = '';
        isCorrect.value = false;
      }
    }
  }
}

class PinBottonSheet extends StatelessWidget {
  const PinBottonSheet({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<PinBottonSheetController>(
    init: PinBottonSheetController(),
    builder: (c) {
      return Column(
        spacing: 4,
        children: [
          SizedBox(height: 50),
          Obx(
            () => c.isCorrect.value != false
                ? SizedBox.shrink()
                : Text('Pass is Incorrect, try again'),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              TextButton(
                onPressed: () => c.onTap(c.rndNums[1]),
                child: Text(c.rndNums[1].toString()),
              ),
              TextButton(
                onPressed: () => c.onTap(c.rndNums[2]),
                child: Text(c.rndNums[2].toString()),
              ),
              TextButton(
                onPressed: () => c.onTap(c.rndNums[3]),
                child: Text(c.rndNums[3].toString()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              TextButton(
                onPressed: () => c.onTap(c.rndNums[4]),
                child: Text(c.rndNums[4].toString()),
              ),
              TextButton(
                onPressed: () => c.onTap(c.rndNums[5]),
                child: Text(c.rndNums[5].toString()),
              ),
              TextButton(
                onPressed: () => c.onTap(c.rndNums[6]),
                child: Text(c.rndNums[6].toString()),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              TextButton(
                onPressed: () => c.onTap(c.rndNums[7]),
                child: Text(c.rndNums[7].toString()),
              ),
              TextButton(
                onPressed: () => c.onTap(c.rndNums[8]),
                child: Text(c.rndNums[8].toString()),
              ),
              TextButton(
                onPressed: () => c.onTap(c.rndNums[9]),
                child: Text(c.rndNums[9].toString()),
              ),
            ],
          ),
          Center(
            child: TextButton(
              onPressed: () => c.onTap(c.rndNums[0]),
              child: Text(c.rndNums[0].toString()),
            ),
          ),
        ],
      );
    },
  );
}
