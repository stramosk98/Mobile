import 'dart:io';

void main() {
  print('Enter first note:');
  double first = double.parse(stdin.readLineSync()!);
  print('Enter second note:');
  double second = double.parse(stdin.readLineSync()!);
  print('Enter third note:');
  double third = double.parse(stdin.readLineSync()!);

  double avg = (first * 2) + (second * 3) + (third * 5);
 
  print('the average of the notes is: ${(avg / 3).toStringAsFixed(2)}');
}
