import 'package:intl/intl.dart';

String formatDateBydMMMYYYY(DateTime dateTime) {
  return DateFormat('dd/MM/yyyy').format(dateTime);
}
