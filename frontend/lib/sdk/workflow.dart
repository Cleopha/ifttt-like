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

      ActionInfo action = actions[sortedRawTasks.first.action]!;

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
              return reactions[rawTask.action]!;
            },
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

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
}
