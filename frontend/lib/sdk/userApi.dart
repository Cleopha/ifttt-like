import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/services.dart';

class Workflow {
  final String id;
  final String name;

  Workflow({
    required this.id,
    required this.name,
  });
}

class RawTask {
  final String id;
  final String name;
  final String type;
  final String action;
  final Map<String, dynamic> params;
  final String nextId;

  RawTask({
    required this.id,
    required this.name,
    required this.type,
    required this.action,
    required this.params,
    required this.nextId,
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

class Task {
  final String? title;
  final String author;
  final int numberOfUsers;
  final ActionInfo action;
  final List<ReactionInfo> reactions;
  final bool isActive;

  Task({
    this.title,
    required this.author,
    required this.numberOfUsers,
    required this.action,
    required this.reactions,
    required this.isActive,
  });
}

class WorkflowAPI {
  Dio dio;

  WorkflowAPI({required this.dio}) {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  List<String> getActionServiceNameAndPath(String action) {
    if (action.length >= "GITHUB".length &&
        action.substring(0, "GITHUB".length) == "GITHUB") {
      return ["Github", "assets/github.png"];
    } else if (action.length >= "GOOGLE".length &&
        action.substring(0, "GOOGLE".length) == "GOOGLE") {
      return ["Google", "assets/google.png"];
    } else if (action.length >= "SCALEWAY".length &&
        action.substring(0, "SCALEWAY".length) == "SCALEWAY") {
      return ["Scaleway", "assets/scaleway.png"];
    } else if (action.length >= "COINMARKETCAP".length &&
        action.substring(0, "COINMARKETCAP".length) == "COINMARKETCAP") {
      return ["CoinMarketCap", "assets/coinmarketcap.png"];
    } else if (action.length >= "NIST".length &&
        action.substring(0, "NIST".length) == "NIST") {
      return ["Nist", "assets/nist.png"];
    } else if (action.length >= "NOTION".length &&
        action.substring(0, "NOTION".length) == "NOTION") {
      return ["Notion", "assets/notion.png"];
    } else if (action.length >= "ONEDRIVE".length &&
        action.substring(0, "ONEDRIVE".length) == "ONEDRIVE") {
      return ["OneDrive", "assets/onedrive.png"];
    } else {
      return ["Unknown", "assets/unknown.png"];
    }
  }

  String getWorkflowsUrl(String userId) {
    return "user/$userId/workflow";
  }

  String postWorkflowUrl(String userId) {
    return "user/$userId/workflow";
  }

  String getTasksUrl(String userId, String workflowId) {
    return "user/$userId/workflow/$workflowId/task";
  }

  Future<List<Workflow>> getWorkflows(String userId) async {
    try {
      Response response = await dio.get(getWorkflowsUrl(userId));

      if (response.statusCode != 200) {
        throw Exception("Error getting workflows");
      }

      return List<Workflow>.from(response.data.map((dynamic w) {
        return Workflow(
          id: w['id'],
          name: w['name'],
        );
      }));
    } catch (e) {
      rethrow;
    }
  }

  Future<Workflow> getWorkflow(String userId, String workflowId) async {
    try {
      Response response =
          await dio.get(getWorkflowsUrl(userId) + "/$workflowId");

      if (response.statusCode != 200) {
        throw Exception("Error getting workflow");
      }

      return Workflow(
        id: response.data['id'],
        name: response.data['name'],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Workflow> postWorkflow(String userId, String name) async {
    try {
      Response response = await dio.post(postWorkflowUrl(userId), data: {
        "name": name,
      });

      if (response.statusCode != 201) {
        throw Exception("Error posting workflow");
      }

      return Workflow(
        id: response.data['id'],
        name: name,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteWorkflow(String userId, String workflowId) async {
    try {
      Response response =
          await dio.delete(postWorkflowUrl(userId) + "/$workflowId");

      if (response.statusCode != 200) {
        throw Exception("Error deleting workflow");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> putWorkflow(
      String userId, String workflowId, String name) async {
    try {
      Response response =
          await dio.put(postWorkflowUrl(userId) + "/$workflowId", data: {
        "name": name,
      });

      if (response.statusCode != 200) {
        throw Exception("Error putting workflow");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task> getTask(String userId, String workflowId) async {
    try {
      Response response = await dio.get(getTasksUrl(userId, workflowId));

      if (response.statusCode != 200) {
        throw Exception("Error getting tasks");
      }

      List<RawTask> rawTasks =
          List<RawTask>.from(response.data.map((dynamic t) {
        return RawTask(
          id: t['id'],
          name: t['name'],
          type: t['type'],
          action: t['action'],
          params: t['params'],
          nextId: t['nextTask'],
        );
      }));

      if (rawTasks.isEmpty) {
        return Task(
            author: userId,
            numberOfUsers: 1,
            action: ActionInfo(
              name: "",
              service: ServiceInfo(
                iconPath: "TODO",
                name: "TODO",
                color: Colors.amber,
              ),
            ),
            reactions: [],
            isActive: false);
      }

      List<RawTask> sortedRawTasks = [];

      for (RawTask rawTask in rawTasks) {
        if (rawTask.type == "ACTION") {
          sortedRawTasks.add(rawTask);
          rawTasks.remove(rawTask);
          break;
        }
      }

      if (sortedRawTasks.isEmpty) {
        throw Exception("No action tasks found");
      }

      while (rawTasks.isNotEmpty) {
        RawTask rawTask = rawTasks
            .firstWhere((RawTask t) => t.id == sortedRawTasks.last.nextId);

        rawTasks.remove(rawTask);
        sortedRawTasks.add(rawTask);
      }

      List<String> nameAndpath =
          getActionServiceNameAndPath(sortedRawTasks.first.action);

      ActionInfo action = ActionInfo(
        name: sortedRawTasks.first.action,
        service: ServiceInfo(
          name: nameAndpath[0],
          iconPath: nameAndpath[1],
          color: Colors.amber,
        ),
      );

      sortedRawTasks.removeAt(0);

      return Task(
        title: workflowId,
        action: action,
        author: userId,
        numberOfUsers: 1,
        isActive: true,
        reactions: List<ReactionInfo>.from(
          sortedRawTasks.map(
            (RawTask rawTask) {
              List<String> nameAndpath =
                  getActionServiceNameAndPath(sortedRawTasks.first.action);

              return ReactionInfo(
                name: rawTask.action,
                service: ServiceInfo(
                  name: nameAndpath[0],
                  iconPath: nameAndpath[1],
                  color: Colors.amber,
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Task> addAction(String userId, String workflowId, String title,
      String action, Map<String, dynamic> params) async {
    try {
      Response response = await dio.get(getTasksUrl(userId, workflowId));

      if (response.statusCode != 200) {
        throw Exception("Error getting tasks");
      }

      List<RawTask> rawTasks =
          List<RawTask>.from(response.data.map((dynamic t) {
        return RawTask(
          id: t['id'],
          name: t['name'],
          type: t['type'],
          action: t['action'],
          params: t['params'],
          nextId: t['nextId'],
        );
      }));

      RawTask? actionTask;

      for (RawTask rawTask in rawTasks) {
        if (rawTask.type == "ACTION") {
          actionTask = rawTask;
        }
      }

      if (actionTask != null) {
        throw Exception("Action tasks already exist");
      }

      RawTask? firstReaction;

      for (RawTask t in rawTasks) {
        bool isNextIdSet = false;

        for (RawTask t2 in rawTasks) {
          if (t2.nextId == t.id) {
            isNextIdSet = true;
            break;
          }
        }

        if (!isNextIdSet) {
          firstReaction = t;
          break;
        }
      }

      if (firstReaction == null && rawTasks.isNotEmpty) {
        throw Exception("Reactions produce a circular dependency (E2)");
      } else {
        firstReaction = actionTask;
      }

      String nextId = "";

      if (firstReaction != null) {
        nextId = firstReaction.id;
      }

      response = await dio.post(
        "/user/$userId/workflow/$workflowId/task",
        data: {
          "name": title,
          "type": "ACTION",
          "action": action,
          "params": params,
          "nextTask": nextId,
        },
      );

      if (response.statusCode != 201) {
        throw Exception("Error posting task");
      }

      return getTask(userId, workflowId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Task> addReaction(String userId, String workflowId, String title,
      String reaction, Map<String, dynamic> params) async {
    try {
      Response response = await dio.get(getTasksUrl(userId, workflowId));

      if (response.statusCode != 200) {
        throw Exception("Error getting tasks");
      }

      List<RawTask> rawTasks = List<RawTask>.from(
        response.data.map(
          (dynamic t) {
            return RawTask(
              id: t['id'],
              name: t['name'],
              type: t['type'],
              action: t['action'],
              params: t['params'],
              nextId: t['nextTask'],
            );
          },
        ),
      );

      RawTask? lastReaction;

      for (RawTask t in rawTasks) {
        if (t.nextId.isEmpty) {
          lastReaction = t;
          break;
        }
      }

      if (lastReaction == null) {
        throw Exception("Reactions produce a circular dependency (E1)");
      }

      response = await dio.post(
        "/user/$userId/workflow/$workflowId/task",
        data: {
          "name": title,
          "type": "REACTION",
          "action": reaction,
          "params": params,
          "nextTask": "",
        },
      );

      if (response.statusCode != 201) {
        throw Exception("Error posting task");
      }

      RawTask rawTask = RawTask(
        id: response.data['id'],
        name: title,
        type: "REACTION",
        action: reaction,
        params: params,
        nextId: "",
      );

      response = await dio.put(
        "/user/$userId/workflow/$workflowId/task/${lastReaction.id}",
        data: {
          "name": lastReaction.name,
          "type": lastReaction.type,
          "action": lastReaction.action,
          "params": lastReaction.params,
          "nextTask": rawTask.id,
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Error patching task");
      }

      return getTask(userId, workflowId);
    } catch (e) {
      rethrow;
    }
  }
}
