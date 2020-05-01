class AnswerForm {
  String question;
  String creator;
  String content;

  static Map<String, String> toJsonObj(question, creator, content) {
    return {
      "question": question,
      "creator": creator,
      "content": content,
    };
  }
}
