import 'package:flutter/material.dart';
import 'package:frontend/components/utils/arSettings/assert_variation_detected.dart';
import 'package:frontend/components/utils/arSettings/volume_exceeds_limit.dart';

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
  final Map<String, dynamic> params;
  final Function(
    Function(Map<String, dynamic>) onSettingsChange,
    Map<String, dynamic> params,
  ) settings;

  ActionInfo({
    required this.name,
    required this.service,
    required this.params,
    required this.settings,
  });
}

class ReactionInfo {
  final String name;
  final ServiceInfo service;
  final Map<String, dynamic> params;
  final Function(
    Function(Map<String, dynamic>) onSettingsChange,
    Map<String, dynamic> params,
  ) settings;

  ReactionInfo({
    required this.name,
    required this.service,
    required this.params,
    required this.settings,
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
  'google': ServiceInfo(
    name: 'Google',
    description:
        'Google est un moteur de recherche gratuit et libre d\'accès sur le World Wide Web, ayant donné son nom à la société Google. C\'est aujourd\'hui le moteur de recherche et le site web le plus visité au monde3 : 90 % des internautes l\'utilisaient en 2018.',
    iconPath: 'assets/icons/tags/google.svg',
    color: const Color(0xff23448b),
  ),
  'coinmarketcap': ServiceInfo(
    name: 'CoinMarketCap',
    description:
        'CoinMarketCap est le site de référence pour suivre les prix des crypto-actifs dans un monde des cryptomonnaies en pleine expansion. Sa mission est de rendre la crypto plus accessible et efficace au grand public en lui fournissant des informations impartiales, qualitatives et précises afin qu\'ils puissent en tirer leurs propres conclusions.',
    iconPath: 'assets/icons/tags/coinmarketcap.svg',
    color: const Color(0xff1db954),
  ),
  'nist': ServiceInfo(
    name: 'Nist',
    description:
        'Le National Institute of Standards and Technology, est une agence du département du Commerce des États-Unis. Son but est de promouvoir l\'économie en développant des technologies, la métrologie et des normes de concert avec l\'industrie.',
    iconPath: 'assets/icons/tags/nist.svg',
    color: const Color(0xff333333),
  ),
  'scaleway': ServiceInfo(
    name: 'Scaleway',
    description:
        'Notre mission est de vous apporter le cloud qui donne et a du sens avec une combinaison de puissance de calcul et stockage conforme aux normes RGPD : flexible, fiable, sécurisée, durable et au juste prix. Avec plus de 20 ans d’expertise dans l’innovation, nous proposons un écosystème complet : du bare metal aux datacenters, en passant par l’intelligence artificielle, le calcul, ou encore des serveurs dédiés haut de gamme. Scaleway est le seul fournisseur de type triple play à proposer à la fois de la colocation en datacenter, du cloud public et du cloud privé, le tout avec une approche innovante et holistique pour une consommation énergétique responsable.',
    iconPath: 'assets/icons/tags/scaleway.svg',
    color: const Color(0xff510099),
  ),
  'ethereum': ServiceInfo(
    name: 'Ethereum',
    description:
        'Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed without any possibility of downtime, censorship, fraud or third-party interference.',
    iconPath: 'assets/icons/tags/ethereum.svg',
    color: const Color(0xffe4405f),
  ),
  'notion': ServiceInfo(
    name: 'Notion',
    description:
        'A new tool that blends your everyday work apps into one. It\'s the all-in-one workspace for you and your team.',
    iconPath: 'assets/icons/tags/notion.svg',
    color: Colors.black,
  ),
};

Map<String, ActionInfo> actions = {
  'GITHUB_NEW_PR_DETECTED': ActionInfo(
    name: 'Une nouvelle Pull Request a été détectée',
    service: services['github']!,
    params: {
      'user': '',
      'repo': '',
      'filter': 'repos',
      'state': 'all',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GITHUB_NEW_ISSUE_DETECTED': ActionInfo(
    name: 'Une nouvelle Issue a été détectée',
    service: services['github']!,
    params: {
      'user': '',
      'repo': '',
      'filter': 'repos',
      'state': 'all',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GITHUB_NEW_ASSIGNATION_DETECTED': ActionInfo(
    name: 'Une nouvelle Assignation a été détectée',
    service: services['github']!,
    params: {
      'user': '',
      'repo': '',
      'filter': 'assigned',
      'state': 'all',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GITHUB_NEW_ISSUE_CLOSED_DETECTED': ActionInfo(
    name: 'Une nouvelle Fermeture d\'Issue a été détectée',
    service: services['github']!,
    params: {
      'user': '',
      'repo': '',
      'filter': 'repos',
      'state': 'closed',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_NEW_INCOMING_EVENT': ActionInfo(
    name: 'Un nouvelle Evenement a été ajouté',
    service: services['google']!,
    params: {},
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'COINMARKETCAP_ASSET_VARIATION_DETECTED': ActionInfo(
    name: 'Une variation d\'un Asset a été détectée',
    service: services['coinmarketcap']!,
    params: {
      'limit': 24,
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'NIST_NEW_CVE_DETECTED': ActionInfo(
    name: 'Une nouvelle CVE a été détectée',
    service: services['nist']!,
    params: {},
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_VOLUME_EXCEEDS_LIMIT': ActionInfo(
    name: 'Le volume de la VM a dépassé la limite',
    service: services['scaleway']!,
    params: {
      'zone': '',
      'limit': 0,
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        VolumeExceedsLimit(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
};

Map<String, ReactionInfo> reactions = {
  'ETH_SEND_TRANSACTION': ReactionInfo(
    name: 'Envoyer une transaction',
    service: services['ethereum']!,
    params: {
      'to': '',
      'value': 0,
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_CREATE_NEW_DOCUMENT': ReactionInfo(
    name: 'Créer un nouveau document',
    service: services['google']!,
    params: {
      'title': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_CREATE_NEW_SHEET': ReactionInfo(
    name: 'Créer une nouveau sheet',
    service: services['google']!,
    params: {
      'title': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_CREATE_NEW_EVENT': ReactionInfo(
    name: 'Créer un nouvel événement',
    service: services['google']!,
    params: {
      'title': '',
      'date': '2024-02-12T11:00:00+01:00',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'NOTION_CREATE_NEW_PAGE': ReactionInfo(
    name: 'Créer une nouvelle page',
    service: services['notion']!,
    params: {
      'title': '',
      'from': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_CONTAINER_REGISTRY': ReactionInfo(
    name: 'Créer un nouveau conteneur',
    service: services['scaleway']!,
    params: {
      'reguion': 'fr-par',
      'name': '',
      'projectID': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_DATABASE': ReactionInfo(
    name: 'Créer une nouvelle base de données',
    service: services['scaleway']!,
    params: {
      'name': '',
      'projectID': '',
      'username': '',
      'password': '',
      'engine': 'PostgreSQL-14',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_FLEXIBLE_IP': ReactionInfo(
    name: 'Créer une nouvelle IP flexible',
    service: services['scaleway']!,
    params: {
      'projectID': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_INSTANCE': ReactionInfo(
    name: 'Créer une nouvelle instance',
    service: services['scaleway']!,
    params: {
      'name': '',
      'projectID': '',
      'zone': 'fr-par-1',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_KUBERNETES_CLUSTER': ReactionInfo(
    name: 'Créer un nouveau cluster Kubernetes',
    service: services['scaleway']!,
    params: {
      'name': '',
      'projectID': '',
      'reguion': 'fr-par',
      'cni': 'unknown_cni',
      'ingress': 'unknown_ingress',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        AssertVariationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
};
