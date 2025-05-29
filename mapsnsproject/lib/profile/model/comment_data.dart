

class Comment{

  String content;
  String userId;
  String markerId;
  
  Comment({
   required this.content,
   required this.userId,
   required this.markerId
});

  factory Comment.fromJson(Map<String,dynamic> json){
    return Comment(content: json['content'], userId: json['userId'], markerId: json['markerId']);
  }

  ///댓글 내용 get할때.
  Map<String, dynamic> toJson() {
    return {
      content : 'content',
      userId : 'userId',
    };
  }
}