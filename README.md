# AutoControl-Dart

Project that allows you to control your bluetooth RC car from your phone.

If you want to compile this app yourself you need to have Flutter SDK installed.

The app sends values ranging from 0 to 200 through bluetooth. On the receiving end you need to change the value type to integer (for ex. using atoi function), change the range to the one you require (in my case it was -100 to 100) and send it to your DC motor driver.
