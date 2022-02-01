import 'package:flutter/material.dart';

class ServiceInfo {
  final String name;
  final String iconPath;
  final Color color;

  ServiceInfo({
    required this.name,
    required this.iconPath,
    required this.color,
  });
}

class ActionInfo {
  final String name;
  final ServiceInfo service;

  ActionInfo({
    required this.name,
    required this.service,
  });
}

class ReactionInfo {
  final String name;
  final ServiceInfo service;

  ReactionInfo({
    required this.name,
    required this.service,
  });
}

Map<String, ServiceInfo> services = {
  'github': ServiceInfo(
    name: 'GitHub',
    iconPath: 'assets/icons/tags/github.svg',
    color: const Color(0xff4078c0),
  ),
  'spotify': ServiceInfo(
    name: 'Spotify',
    iconPath: 'assets/icons/tags/spotify.svg',
    color: const Color(0xff1db954),
  ),
  'googleDrive': ServiceInfo(
    name: 'Google Drive',
    iconPath: 'assets/icons/tags/googleDrive.svg',
    color: const Color(0xff23448b),
  ),
  'slack': ServiceInfo(
    name: 'Slack',
    iconPath: 'assets/icons/tags/slack.svg',
    color: const Color(0xff4a154b),
  ),
  'scaleway': ServiceInfo(
    name: 'Scaleway',
    iconPath: 'assets/icons/tags/scaleway.svg',
    color: const Color(0xff510099),
  ),
  'discord': ServiceInfo(
    name: 'Discord',
    iconPath: 'assets/icons/tags/discord.svg',
    color: const Color(0xff7289da),
  ),
  'notion': ServiceInfo(
    name: 'Notion',
    iconPath: 'assets/icons/tags/notion.svg',
    color: Colors.black,
  ),
  'timer': ServiceInfo(
    name: 'Timer',
    iconPath: 'assets/icons/tags/timer.svg',
    color: const Color(0xff333333),
  ),
};

Map<String, ActionInfo> actions = {
  'prMerge': ActionInfo(
    name: 'A Pull Request Merged',
    service: services['github']!,
  ),
  'issueOpen': ActionInfo(
    name: 'An Issue Opened',
    service: services['github']!,
  ),
  'release': ActionInfo(
    name: 'Ther Is A New Release',
    service: services['github']!,
  ),
  'userSponsor': ActionInfo(
    name: 'A New Sponsor',
    service: services['github']!,
  ),
  'specificRole': ActionInfo(
    name: 'I Have A Specific Role',
    service: services['discord']!,
  ),
  'bucketStorage': ActionInfo(
    name: 'A Bucket Has Overloaded',
    service: services['scaleway']!,
  ),
  'folderChange': ActionInfo(
    name: 'The Folder Has Changed',
    service: services['googleDrive']!,
  ),
  'xHours': ActionInfo(
    name: 'X Hours Has Elapsed',
    service: services['timer']!,
  ),
  'date': ActionInfo(
    name: 'It Is A Specific Date',
    service: services['timer']!,
  ),
};

Map<String, ReactionInfo> reactions = {
  'openIssue': ReactionInfo(
    name: 'Open An Issue',
    service: services['github']!,
  ),
  'playMusic': ReactionInfo(
    name: 'Play Music',
    service: services['spotify']!,
  ),
  'addUserPlaylist': ReactionInfo(
    name: 'Add User To Playlist',
    service: services['spotify']!,
  ),
  'sendMessage': ReactionInfo(
    name: 'Send Message',
    service: services['discord']!,
  ),
  'addRole': ReactionInfo(
    name: 'Add Role',
    service: services['discord']!,
  ),
  'createChannel': ReactionInfo(
    name: 'Create Channel',
    service: services['slack']!,
  ),
  'pingUser': ReactionInfo(
    name: 'Ping User',
    service: services['slack']!,
  ),
  'startServerless': ReactionInfo(
    name: 'Start Serverless',
    service: services['scaleway']!,
  ),
  'addUserToPage': ReactionInfo(
    name: 'Add User To Page',
    service: services['notion']!,
  ),
  'storeFile': ReactionInfo(
    name: 'Store File',
    service: services['googleDrive']!,
  ),
};
