class ModelTaskManager {
  int? iD;
  String? title;
  String? timeStart;
  String? timeEnd;
  String? description;
  String? dateEcheance;
  int? statutID;

  ModelTaskManager(
      {this.iD,
      this.title,
      this.timeStart,
      this.timeEnd,
      this.description,
      this.dateEcheance,
      this.statutID});

  ModelTaskManager.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    title = json['Title'];
    timeStart = json['time_start'];
    timeEnd = json['time_end'];
    description = json['Description'];
    dateEcheance = json['DateEcheance'];
    statutID = json['Statut_ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Title'] = this.title;
    data['time_start'] = this.timeStart;
    data['time_end'] = this.timeEnd;
    data['Description'] = this.description;
    data['DateEcheance'] = this.dateEcheance;
    data['Statut_ID'] = this.statutID;
    return data;
  }
}
