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
  'google': ServiceInfo(
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
  'GITHUB_NEW_PR_DETECTED': ActionInfo(
    name: 'Une nouvelle Pull Request a été détectée',
    service: services['github']!,
  ),
  'GITHUB_NEW_ISSUE_DETECTED': ActionInfo(
    name: 'Une nouvelle Issue a été détectée',
    service: services['github']!,
  ),
  'GITHUB_NEW_ASSIGNATION_DETECTED': ActionInfo(
    name: 'Une nouvelle Assignation a été détectée',
    service: services['github']!,
  ),
  'GITHUB_NEW_ISSUE_CLOSED_DETECTED': ActionInfo(
    name: 'Une nouvelle Fermeture d\'Issue a été détectée',
    service: services['github']!,
  ),
  'GOOGLE_NEW_INCOMING_EVENT': ActionInfo(
    name: 'Un nouvelle Evenement a été ajouté',
    service: services['google']!,
  ),
  'SCALEWAY_VOLUME_EXCEEDS_LIMIT': ActionInfo(
    name: 'Le volume de la VM a dépassé la limite',
    service: services['scaleway']!,
  ),
  'COINMARKETCAP_ASSET_VARIATION_DETECTED': ActionInfo(
    name: 'Une variation d\'un Asset a été détectée',
    service: services['scaleway']!,
  ),
  'NIST_NEW_CVE_DETECTED': ActionInfo(
    name: 'Une nouvelle CVE a été détectée',
    service: services['scaleway']!,
  ),
};

Map<String, ReactionInfo> reactions = {
  'GOOGLE_CREATE_NEW_EVENT': ReactionInfo(
    name: 'Création d\'un nouvel Evenement',
    service: services['google']!,
  ),
  'GOOGLE_CREATE_NEW_DOCUMENT': ReactionInfo(
    name: 'Création d\'un nouveau Document',
    service: services['google']!,
  ),
  'GOOGLE_CREATE_NEW_SHEET': ReactionInfo(
    name: 'Création d\'un nouveau Sheet',
    service: services['google']!,
  ),
  'SCALEWAY_CREATE_NEW_FLEXIBLE_IP': ReactionInfo(
    name: 'Création d\'une nouvelle IP Flexible',
    service: services['scaleway']!,
  ),
  'SCALEWAY_CREATE_NEW_INSTANCE': ReactionInfo(
    name: 'Création d\'une nouvelle Instance',
    service: services['scaleway']!,
  ),
  'SCALEWAY_CREATE_NEW_DATABASE': ReactionInfo(
    name: 'Création d\'une nouvelle Base de Données',
    service: services['scaleway']!,
  ),
  'SCALEWAY_CREATE_NEW_KUBERNETES_CLUSTER': ReactionInfo(
    name: 'Création d\'un nouveau Cluster Kubernetes',
    service: services['scaleway']!,
  ),
  'SCALEWAY_CREATE_NEW_CONTAINER_REGISTRY': ReactionInfo(
    name: 'Création d\'un nouveau Registre de Conteneur',
    service: services['scaleway']!,
  ),
  'ONEDRIVE_CREATE_NEW_POWER_POINT': ReactionInfo(
    name: 'Création d\'un nouveau Power Point',
    service: services['google']!,
  ),
  'ONEDRIVE_CREATE_NEW_FORM': ReactionInfo(
    name: 'Création d\'un nouveau Formulaire',
    service: services['google']!,
  ),
  'NOTION_CREATE_NEW_PAGE': ReactionInfo(
    name: 'Création d\'une nouvelle Page',
    service: services['notion']!,
  ),
};
