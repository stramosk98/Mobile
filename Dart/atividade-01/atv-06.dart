import 'dart:io';

void main() {
  print('Enter the temperature in Fahrenheit: ');
  int fahrenheit = int.parse(stdin.readLineSync()!);

  print('The temperature in Fahrenheit is: $fahrenheit, and in Celsius is: ${(5 * (fahrenheit - 32) / 9).toStringAsFixed(2)}°C');
}
