import 'dart:io';

void main() {
  print('Enter the name of student:');
  String name = stdin.readLineSync()!;

  List<List<double>> notes = [[0, 0], [0, 0], [0, 0], [0, 0]];

  for (int i = 0; i < 4; i++) {
    print('Enter ${i + 1}st note:');
    notes[i][0] = double.parse(stdin.readLineSync()!);

    print('Enter ${i + 1}st weight:');
    notes[i][1] = double.parse(stdin.readLineSync()!);
  }

  double weightedSum = 0;
  double totalWeight = 0;
  
  for (int i = 0; i < 4; i++) {
    weightedSum += notes[i][0] * notes[i][1];
    totalWeight += notes[i][1];
  }

  double avg = weightedSum / totalWeight;

  print('Student $name has an average of ${(avg).toStringAsFixed(2)}');
}
