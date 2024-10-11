import 'dart:io';

void main() {
  print('Enter the sex:');
  String sex = stdin.readLineSync()!;

  print('Enter the height:');
  double height = double.parse(stdin.readLineSync()!);

  double ideal = sex == 'M' ? (72.7 * height) - 58 : (62.1 * height) - 44.7;

  print('Your ideal weight is: ${ideal.toStringAsFixed(2)}kg');
}
 