import 'package:flutter/material.dart';
import 'package:frontend/components/utils/arSettings/assert_variation_detected.dart';
import 'package:frontend/components/utils/arSettings/assignation_detected.dart';
import 'package:frontend/components/utils/arSettings/create_container_registry.dart';
import 'package:frontend/components/utils/arSettings/create_database.dart';
import 'package:frontend/components/utils/arSettings/create_document.dart';
import 'package:frontend/components/utils/arSettings/create_event.dart';
import 'package:frontend/components/utils/arSettings/create_flexible_ip.dart';
import 'package:frontend/components/utils/arSettings/create_instance.dart';
import 'package:frontend/components/utils/arSettings/create_kubernetes_cluster.dart';
import 'package:frontend/components/utils/arSettings/create_page.dart';
import 'package:frontend/components/utils/arSettings/create_sheet.dart';
import 'package:frontend/components/utils/arSettings/issue_closed_detected.dart';
import 'package:frontend/components/utils/arSettings/issue_detected.dart';
import 'package:frontend/components/utils/arSettings/pr_detected.dart';
import 'package:frontend/components/utils/arSettings/volume_exceeds_limit.dart';
import 'package:frontend/components/utils/arSettings/send_transaction%20.dart';
import 'package:frontend/components/utils/login/eth_login.dart';
import 'package:frontend/components/utils/login/github_login.dart';
import 'package:frontend/components/utils/login/google_login.dart';
import 'package:frontend/components/utils/login/scalway_login.dart';

class ServiceInfo {
  final String name;
  final String description;
  final String iconPath;
  final Color color;
  final Widget login;

  ServiceInfo({
    required this.name,
    required this.description,
    required this.iconPath,
    required this.color,
    required this.login,
  });
}

class ActionInfo {
  final String name;
  final ServiceInfo service;
  Map<String, dynamic> params;
  final Function(
    Function(Map<String, dynamic>) onSettingsChange,
    Map<String, dynamic> params,
  ) settings;
  String id;
  String action;
  String nextId;
  String workflowId;

  ActionInfo({
    this.action = '',
    this.id = '',
    this.nextId = '',
    this.workflowId = '',
    required this.name,
    required this.service,
    required this.params,
    required this.settings,
  });
}

class ReactionInfo {
  final String name;
  final ServiceInfo service;
  Map<String, dynamic> params;
  final Function(
    Function(Map<String, dynamic>) onSettingsChange,
    Map<String, dynamic> params,
  ) settings;
  String id;
  String nextId;
  String reaction;
  String workflowId;

  ReactionInfo({
    this.reaction = '',
    this.id = '',
    this.nextId = '',
    this.workflowId = '',
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
    login: const GithubLogin(),
  ),
  'google': ServiceInfo(
    name: 'Google',
    description:
        'Google est un moteur de recherche gratuit et libre d\'acc??s sur le World Wide Web, ayant donn?? son nom ?? la soci??t?? Google. C\'est aujourd\'hui le moteur de recherche et le site web le plus visit?? au monde3 : 90 % des internautes l\'utilisaient en 2018.',
    iconPath: 'assets/icons/tags/google.svg',
    color: const Color(0xff23448b),
    login: const GoogleLogin(),
  ),
  'coinmarketcap': ServiceInfo(
    name: 'CoinMarketCap',
    description:
        'CoinMarketCap est le site de r??f??rence pour suivre les prix des crypto-actifs dans un monde des cryptomonnaies en pleine expansion. Sa mission est de rendre la crypto plus accessible et efficace au grand public en lui fournissant des informations impartiales, qualitatives et pr??cises afin qu\'ils puissent en tirer leurs propres conclusions.',
    iconPath: 'assets/icons/tags/coinmarketcap.svg',
    color: const Color(0xff1db954),
    login: Container(),
  ),
  'nist': ServiceInfo(
    name: 'Nist',
    description:
        'Le National Institute of Standards and Technology, est une agence du d??partement du Commerce des ??tats-Unis. Son but est de promouvoir l\'??conomie en d??veloppant des technologies, la m??trologie et des normes de concert avec l\'industrie.',
    iconPath: 'assets/icons/tags/nist.svg',
    color: const Color(0xff333333),
    login: Container(),
  ),
  'scaleway': ServiceInfo(
    name: 'Scaleway',
    description:
        'Notre mission est de vous apporter le cloud qui donne et a du sens avec une combinaison de puissance de calcul et stockage conforme aux normes RGPD : flexible, fiable, s??curis??e, durable et au juste prix. Avec plus de 20 ans d???expertise dans l???innovation, nous proposons un ??cosyst??me complet : du bare metal aux datacenters, en passant par l???intelligence artificielle, le calcul, ou encore des serveurs d??di??s haut de gamme. Scaleway est le seul fournisseur de type triple play ?? proposer ?? la fois de la colocation en datacenter, du cloud public et du cloud priv??, le tout avec une approche innovante et holistique pour une consommation ??nerg??tique responsable.',
    iconPath: 'assets/icons/tags/scaleway.svg',
    color: const Color(0xff510099),
    login: const ScalewayLogin(),
  ),
  'ethereum': ServiceInfo(
    name: 'Ethereum',
    description:
        'Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed without any possibility of downtime, censorship, fraud or third-party interference.',
    iconPath: 'assets/icons/tags/ethereum.svg',
    color: const Color(0xffe4405f),
    login: const EthLogin(),
  ),
  'notion': ServiceInfo(
    name: 'Notion',
    description:
        'A new tool that blends your everyday work apps into one. It\'s the all-in-one workspace for you and your team.',
    iconPath: 'assets/icons/tags/notion.svg',
    color: Colors.black,
    login: Container(),
  ),
};

Map<String, ActionInfo> actions = {
  'GITHUB_NEW_PR_DETECTED': ActionInfo(
    name: 'Une nouvelle Pull Request a ??t?? d??tect??e',
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
        PrDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GITHUB_NEW_ISSUE_DETECTED': ActionInfo(
    name: 'Une nouvelle Issue a ??t?? d??tect??e',
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
        IssueDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GITHUB_NEW_ISSUE_ASSIGNATION_DETECTED': ActionInfo(
    name: 'Une nouvelle Assignation d\' issue a ??t?? d??tect??e',
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
        AssignationDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GITHUB_NEW_ISSUE_CLOSED_DETECTED': ActionInfo(
    name: 'Une nouvelle Fermeture d\'Issue a ??t?? d??tect??e',
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
        IssueClosedDetected(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_NEW_INCOMING_EVENT': ActionInfo(
    name: 'Un nouvelle Evenement a ??t?? ajout??',
    service: services['google']!,
    params: {},
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        Container(),
  ),
  'COINMARKETCAP_ASSET_VARIATION_DETECTED': ActionInfo(
    name: 'Une variation d\'un Asset a ??t?? d??tect??e',
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
    name: 'Une nouvelle CVE a ??t?? d??tect??e',
    service: services['nist']!,
    params: {},
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        Container(),
  ),
  'SCALEWAY_VOLUME_EXCEEDS_LIMIT': ActionInfo(
    name: 'Le volume de la VM a d??pass?? la limite',
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
        SendTransaction(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_CREATE_NEW_DOCUMENT': ReactionInfo(
    name: 'Cr??er un nouveau document',
    service: services['google']!,
    params: {
      'title': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        CreateNewDocument(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_CREATE_NEW_SHEET': ReactionInfo(
    name: 'Cr??er une nouveau sheet',
    service: services['google']!,
    params: {
      'title': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        CreateNewSheet(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'GOOGLE_CREATE_NEW_EVENT': ReactionInfo(
    name: 'Cr??er un nouvel ??v??nement',
    service: services['google']!,
    params: {
      'title': '',
      'start': DateTime.now().toIso8601String(),
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        CreateNewEvent(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'NOTION_CREATE_NEW_PAGE': ReactionInfo(
    name: 'Cr??er une nouvelle page',
    service: services['notion']!,
    params: {
      'title': '',
      'from': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        CreateNewPage(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_CONTAINER_REGISTRY': ReactionInfo(
    name: 'Cr??er un nouveau conteneur',
    service: services['scaleway']!,
    params: {
      'region': 'fr-par',
      'name': '',
      'projectID': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        CreateContainerRegistry(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_DATABASE': ReactionInfo(
    name: 'Cr??er une nouvelle base de donn??es',
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
        CreateDatabase(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_FLEXIBLE_IP': ReactionInfo(
    name: 'Cr??er une nouvelle IP flexible',
    service: services['scaleway']!,
    params: {
      'projectID': '',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        CreateFlexibleIp(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_INSTANCE': ReactionInfo(
    name: 'Cr??er une nouvelle instance',
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
        CreateInstance(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
  'SCALEWAY_CREATE_NEW_KUBERNETES_CLUSTER': ReactionInfo(
    name: 'Cr??er un nouveau cluster Kubernetes',
    service: services['scaleway']!,
    params: {
      'name': '',
      'projectID': '',
      'region': 'fr-par',
      'cni': 'unknown_cni',
      'ingress': 'unknown_ingress',
    },
    settings: (
      Function(Map<String, dynamic>) onSettingsChamge,
      Map<String, dynamic> params,
    ) =>
        CreateKubernetesCluster(
      onSettingsChange: onSettingsChamge,
      params: params,
    ),
  ),
};
