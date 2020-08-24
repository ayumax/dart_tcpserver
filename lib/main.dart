import 'dart:io';

import 'package:objectdeliverer_dart/objectdeliverer_dart.dart';

class TweetItem implements IJsonSerializable {
  String userName;
  String accountName;
  String tweet;
  String icon;

  TweetItem.fromTweetInfo(this.userName, this.accountName, this.tweet)
      : icon = 'images/myUser.png';

  TweetItem.fromJson(Map<String, dynamic> json)
      : userName = json['userName'] as String,
        accountName = json['accountName'] as String,
        tweet = json['tweet'] as String,
        icon = 'images/myUser.png';

  @override
  Map<String, dynamic> toJson() => {
        'userName': userName,
        'accountName': accountName,
        'tweet': tweet,
      };
}

Future main(List<String> args) async {
  print('start server');

  IJsonSerializable.addMakeInstanceFunction(
      TweetItem, (json) => TweetItem.fromJson(json));

  ObjectDelivererManager<TweetItem> objectDeliverer;

  objectDeliverer = ObjectDelivererManager<TweetItem>()
    ..connected.listen((x) => print('接続済み'))
    ..disconnected.listen((x) => print('接続待ち'))
    ..receiveData.listen((x) {
      x.message.userName = 'server😀';
      x.message.tweet = '>>' + x.message.tweet;
      objectDeliverer.sendMessage(x.message);
    });

  await objectDeliverer.start(ProtocolTcpIpServer.fromParam(50310),
      PacketRuleSizeBody.fromParam(4), ObjectJsonDeliveryBox<TweetItem>());

  while (true) {
    await Future.delayed(const Duration(seconds: 1));
  }

  print('hoge end');
}
