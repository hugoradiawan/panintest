void main() {
  final List<int> nominals = [20_000, 50_000, 100_000];
  try {
    print(withdraw(nominals, 370_000));
  } on InvalidWithdrawValue catch (e) {
    print(e.message);
  }

  try {
    print(withdraw(nominals, 115_000));
  } on InvalidWithdrawValue catch (e) {
    print(e.message);
  }
}

class InvalidWithdrawValue implements Exception {
  final String message;
  InvalidWithdrawValue(this.message);
}

Map<int, int> withdraw(List<int> nominals, int toWithdrawValue) {
  // sort the list, the bigest first
  nominals = nominals..sort((a, b) => b.compareTo(a));
  int tempvalue = toWithdrawValue;

  // prepare the structure result
  final Map<int, int> result = nominals.fold({}, (s, a) {
    s.putIfAbsent(a, () => 0);
    return s;
  });

  // loop through the available nominals
  for (int i = 0; i < nominals.length; i++) {
    // get the amount of nominal
    final int amount = tempvalue ~/ nominals[i];
    // assign it to the result
    result[nominals[i]] = amount;
    // prepare the tempvalue for next loop
    tempvalue = tempvalue - (amount * nominals[i]);
  }

  // if we have rest value
  if (tempvalue != 0) throw InvalidWithdrawValue('Nominal tidak valid');
  return result;
}
