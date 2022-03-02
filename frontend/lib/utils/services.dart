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
    service: services['coinmarketcap']!,
  ),
  'NIST_NEW_CVE_DETECTED': ActionInfo(
    name: 'Une nouvelle CVE a été détectée',
    service: services['nist']!,
  ),
};

Map<String, ReactionInfo> reactions = {};
