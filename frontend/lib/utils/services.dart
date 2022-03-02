import 'package:flutter/material.dart';

class ServiceInfo {
  final String name;
  final String description;
  final String iconPath;
  final Color color;

  ServiceInfo({
    required this.name,
    required this.description,
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
    description:
        'GitHub is the best place to share code with friends, co-workers, classmates, and complete strangers. Turn on Applets to automatically track issues, pull requests, repositories, and to quickly create issues.',
    iconPath: 'assets/icons/tags/github.svg',
    color: const Color(0xff4078c0),
  ),
  'spotify': ServiceInfo(
    name: 'Spotify',
    description:
        'Spotify is a digital music service that gives you access to millions of songs. Applets can help you save your Discover Weekly and Release Radar playlists, share your favorite tunes, and much more.',
    iconPath: 'assets/icons/tags/spotify.svg',
    color: const Color(0xff1db954),
  ),
  'google': ServiceInfo(
    name: 'Google Drive',
    description:
        'Google Drive lets you store and access your files anywhere — on the web, on your hard drive, or on the go. Applets let you send the most important information into your Google Drive, automatically',
    iconPath: 'assets/icons/tags/googleDrive.svg',
    color: const Color(0xff23448b),
  ),
  'slack': ServiceInfo(
    name: 'Slack',
    description:
        'Slack brings all your team communication into one place. Turn on Applets to bring important information into channels, quickly share photos, automate reminders, and much more.',
    iconPath: 'assets/icons/tags/slack.svg',
    color: const Color(0xff4a154b),
  ),
  'scaleway': ServiceInfo(
    name: 'Scaleway',
    description:
        'Notre mission est de vous apporter le cloud qui donne et a du sens avec une combinaison de puissance de calcul et stockage conforme aux normes RGPD : flexible, fiable, sécurisée, durable et au juste prix. Avec plus de 20 ans d’expertise dans l’innovation, nous proposons un écosystème complet : du bare metal aux datacenters, en passant par l’intelligence artificielle, le calcul, ou encore des serveurs dédiés haut de gamme. Scaleway est le seul fournisseur de type triple play à proposer à la fois de la colocation en datacenter, du cloud public et du cloud privé, le tout avec une approche innovante et holistique pour une consommation énergétique responsable.',
    iconPath: 'assets/icons/tags/scaleway.svg',
    color: const Color(0xff510099),
  ),
  'discord': ServiceInfo(
    name: 'Discord',
    description:
        'Whether you’re part of a school club, gaming group, worldwide art community, or just a handful of friends that want to spend time together, Discord makes it easy to talk every day and hang out more often.',
    iconPath: 'assets/icons/tags/discord.svg',
    color: const Color(0xff7289da),
  ),
  'notion': ServiceInfo(
    name: 'Notion',
    description:
        'A new tool that blends your everyday work apps into one. It\'s the all-in-one workspace for you and your team.',
    iconPath: 'assets/icons/tags/notion.svg',
    color: Colors.black,
  ),
  'timer': ServiceInfo(
    name: 'Timer',
    description: 'Use Timer services to time your reactions.',
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
