import '../constant/variableconst.dart';

int extractMonth(String date) {
  // Sépare la chaîne de caractères en utilisant le délimiteur "-"
  List<String> parts = date.split("-");

  // Extrait le troisième élément de la liste qui représente le jour du mois
  String monthStr = parts[2];

  // Convertit le jour en entier
  int dayMonth = int.parse(monthStr);

  return dayMonth;
}

Future<List<Map<String, Object?>>> fetchAllData() async {
  List<Map<String, Object?>> response =
      await db.readData("SELECT * FROM Tache");
  return response;
}
