void main() {
  // case 1
  print(refund([15_000, 45_000, 20_000, 30_000], 50_000));

  // case 2
  print(refund([25_000, 10_000, 25_000, 40_000], 50_000));
}

List<int> refund(List<int> transactions, int target) {
  // loop through the transactions
  for (int i = 0; i < transactions.length; i++) {
    // early exit if target is bigger than transaction
    if (transactions[i] > target) continue;
    // to find the other pair the the transaction, exclude transaction index i
    final int rest = target - transactions[i];
    final int index = transactions.indexWhere((e) => e == rest, i + 1);

    // if found, return current index and index other pair
    if (index != -1) return [i, index];
  }

  // no pair found case
  return [];
}
