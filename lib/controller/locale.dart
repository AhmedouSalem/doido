import 'package:get/get.dart';

class MyLocaleController implements Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys {
    return {
      "ar": {
        "titre": "مدير المهام",
        "noTask": "لا توجد مهام",
        "noteStart": "لديك",
        "noteEnd": "من المهام اليوم",
        "addTask": "+ إضافة مهمة",
        "to": "إلى",
        "daysOfWeek": "الاثنين_الثلاثاء_الأربعاء_الخميس_الجمعة_السبت_الأحد",
        "months":
            "يناير_فبراير_مارس_أبريل_مايو_يونيو_يوليو_أغسطس_سبتمبر_أكتوبر_نوفمبر_ديسمبر",
        "Add Task": "إضافة مهمة",
        "Title": "عنوان",
        "Date": "التاريخ",
        "Start": "توقيت البدء",
        "End": "توقيت الإنتهاء",
        "Description": "وصف المهمة",
        "Edit Task": "تعديل مهمة",
        "Edit": "تعديل",
        "Done": "تم",
        "Delete": "مسح",
      },
      "en": {
        "titre": "Task Manager",
        "noTask": "No tasks found",
        "noteStart": "You have",
        "noteEnd": "Tasks Today",
        "addTask": "+ add Task",
        "to": "to",
        "daysOfWeek":
            "Monday_Tuesday_Wednesday_Thursday_Friday_Saturday_Sunday",
        "months":
            "January_February_March_April_May_June_July_August_September_October_November_December",
        "Add Task": "Add Task",
        "Title": "Title",
        "Date": "Date",
        "Start": "Time start",
        "End": "Time end",
        "Description": "Description",
        "Edit Task": "Edit Task",
        "Edit": "Edit",
        "Done": "Done",
        "Delete": "Delete",
      },
      "fr": {
        "titre": "Gestionnaire Des Tâches",
        "noTask": "Aucune Tâche trouvée",
        "noteStart": "Vous avez",
        "noteEnd": "Tâches Aujourd'hui",
        "addTask": "+ Ajouter",
        "to": "à",
        "daysOfWeek": "lundi_mardi_mercredi_jeudi_vendredi_samedi_dimanche",
        "months":
            "janvier_février_mars_avril_mai_juin_juillet_août_septembre_octobre_novembre_décembre",
        "Add Task": "Ajouter une Tâche",
        "Title": "Titre",
        "Date": "Date",
        "Start": "Début",
        "End": "Fin",
        "Description": "Description",
        "Edit Task": "Modifier une tâche",
        "Edit": "Modifier",
        "Done": "Accomplir",
        "Delete": "Supprimer",
      },
    };
  }
}
