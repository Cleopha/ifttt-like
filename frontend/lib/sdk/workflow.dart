import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:frontend/controllers/controller_constant.dart';
import 'package:frontend/utils/services.dart';
import 'package:frontend/utils/task.dart';

class Workflow {
  final String id;
  final String name;

  Workflow({
    required this.id,
    required this.name,
  });
}

class FlowAR {
  final String flow;
  final Map<String, dynamic> params;

  FlowAR({
    required this.flow,
    required this.params,
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

class WorkflowAPI {
  Dio dio;

  WorkflowAPI({required this.dio}) {
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  /// Get all workflows by [userId]
  String getWorkflowsUrl(String userId) {
    return "user/$userId/workflow";
  }

  /// Create a new workflow by [userId]
  String postWorkflowUrl(String userId) {
    return "user/$userId/workflow";
  }

  /// Take [workflowId] and return the url to get its tasks
  String getTasksUrl(String userId, String workflowId) {
    return "user/$userId/workflow/$workflowId/task";
  }

  /// Take [userId] and return its workflows
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

  /// Take [userId] and [workflowId] and return the associated [Workflow]
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

  /// Take a [userId] and a [name] and create a new [Workflow]
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

  /// Take [userId] and [workflowId] and delete the associated [Workflow]
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

  /// Take [userId], [workflowId] and [name] and modified the associated [Workflow]'s name
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

  /// Take [userId] and [workflowId] and return the associated [Task]s
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
          action: null,
          reactions: [],
          isActive: false,
        );
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

      ActionInfo action = ActionInfo(
        id: sortedRawTasks.first.id,
        action: sortedRawTasks.first.action,
        nextId: sortedRawTasks.first.nextId,
        workflowId: workflowId,
        name: actions[sortedRawTasks.first.action]!.name,
        service: actions[sortedRawTasks.first.action]!.service,
        params: Map<String, dynamic>.from(
            actions[sortedRawTasks.first.action]!.params)
          ..addAll(sortedRawTasks.first.params),
        settings: actions[sortedRawTasks.first.action]!.settings,
      );

      sortedRawTasks.removeAt(0);

      return Task(
        workflowId: workflowId,
        action: action,
        author: apiController.user?.email ?? "",
        numberOfUsers: 1,
        isActive: true,
        reactions: List<ReactionInfo>.from(
          sortedRawTasks.map(
            (RawTask rawTask) {
              return ReactionInfo(
                id: rawTask.id,
                nextId: rawTask.nextId,
                workflowId: workflowId,
                reaction: rawTask.action,
                name: reactions[rawTask.action]!.name,
                service: reactions[rawTask.action]!.service,
                params:
                    Map<String, dynamic>.from(reactions[rawTask.action]!.params)
                      ..addAll(sortedRawTasks.first.params),
                settings: reactions[rawTask.action]!.settings,
              );
            },
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Take [userId], [workflowId], [title] and [flow] and create a new action [Task]
  Future<Task> addAction(
    String userId,
    String workflowId,
    String title,
    FlowAR flow,
  ) async {
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
          "action": flow.flow,
          "params": flow.params,
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

  /// Take [userId], [workflowId], [title] and [flow] and create a new reaction [Task]
  Future<Task> addReaction(
    String userId,
    String workflowId,
    String title,
    FlowAR flow,
  ) async {
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
          "action": flow.flow,
          "params": flow.params,
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
        action: flow.flow,
        params: flow.params,
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

  /// Take [userId] and return all its tasks
  Future<List<Task>> getAllTasks(String userId) async {
    try {
      Response response = await dio.get("/user/$userId/workflow");

      if (response.statusCode != 200) {
        throw Exception("Error getting tasks");
      }

      List<Task> tasks = [];

      for (dynamic t in response.data) {
        try {
          tasks.add(await getTask(userId, t['id']));
        } catch (e) {
          rethrow;
        }
      }

      return tasks;
    } catch (e) {
      rethrow;
    }
  }

  /// Take [userId], [workflowId] and an [action] to update the task
  Future<void> putAction(
      String userId, String workflowId, ActionInfo action) async {
    try {
      String id = action.id;

      Response response =
          await dio.put("/user/$userId/workflow/$workflowId/task/$id", data: {
        "name": action.name,
        "type": "ACTION",
        "action": action.action,
        "params": action.params,
        "nextTask": action.nextId,
      });

      if (response.statusCode != 200) {
        throw Exception("Error patching task");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Take [userId], [workflowId] and an [reaction] to update the task
  Future<RawTask> putReaction(
      String userId, String workflowId, ReactionInfo reaction) async {
    try {
      String id = reaction.id;

      Response response =
          await dio.put("/user/$userId/workflow/$workflowId/task/$id", data: {
        "name": reaction.name,
        "type": "REACTION",
        "action": reaction.reaction,
        "params": reaction.params,
        "nextTask": reaction.nextId,
      });

      if (response.statusCode != 200) {
        throw Exception("Error patching task");
      }

      return RawTask(
        id: response.data['id'],
        name: response.data['name'],
        type: response.data['type'],
        action: response.data['action'],
        params: response.data['params'],
        nextId: response.data['nextTask'],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Take [userId], [workflowId], a [task] and a [reaction] to delete the task
  Future<void> deleteReaction(String userId, String workflowId, Task task,
      ReactionInfo reaction) async {
    try {
      ReactionInfo? previousReaction;
      ReactionInfo? nextReaction;

      for (ReactionInfo r in task.reactions) {
        if (r.nextId == reaction.id) {
          previousReaction = r;
          break;
        }
      }

      if (previousReaction != null) {
        previousReaction.nextId = reaction.nextId;

        await dio.put(
            "/user/$userId/workflow/$workflowId/task/${previousReaction.id}",
            data: {
              "name": previousReaction.name,
              "type": "REACTION",
              "action": previousReaction.reaction,
              "params": previousReaction.params,
              "nextTask": previousReaction.nextId,
            });
      } else {
        task.action!.id = reaction.nextId;

        await dio.put(
            "/user/$userId/workflow/$workflowId/task/${task.action!.id}",
            data: {
              "name": task.action!.name,
              "type": "action",
              "action": task.action!.action,
              "params": task.action!.params,
              "nextTask": "",
            });
      }

      Response response = await dio
          .delete("/user/$userId/workflow/$workflowId/task/${reaction.id}");

      if (response.statusCode != 200) {
        throw Exception("Error deleting task");
      }

      task.reactions.remove(reaction);
    } catch (e) {
      rethrow;
    }
  }
}
