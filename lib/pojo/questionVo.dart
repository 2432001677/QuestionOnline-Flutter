class QuestionVo {
  String questionId;
  String creator;
  String classId;
  String userName;
  String className;
  String title;
  String content;
  String createDate;
  String updateDate;
  String answerNum;
  String markNum;

  static Map<String, String> toJsonObj(
      questionId, creator, classId, title, content) {
    return {
      'questionId': questionId,
      'creator': creator,
      'classId': classId,
      'title': title,
      'content': content,
    };
  }
}
