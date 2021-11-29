import 'dart:collection';
import 'package:cat_news/common/utils/utils.dart';
import 'package:cat_news/common/values/values.dart';
import 'package:dio/dio.dart';

class CacheObject {
  Response response;
  int timeStamp;
  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;

  // 函数重载
  @override
  bool operator ==(Object other) => response.hashCode == other.hashCode;

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  // 为确保迭代顺序和对象插入时间顺序一致 使用LinkedHashMap
  // ignore: prefer_collection_literals
  var cache = LinkedHashMap<String, CacheObject>();

  @override
  void onRequest(options, handler) async {
    if (!cacheEnable) {
      return handler.next(options);
    }
    // refresh 标记是否是 ‘下拉刷新’
    bool refresh = options.extra['refresh'] == true;

    // 是否磁盘缓存
    bool cacheDisk = options.extra['cacheDisk'] == true;

    // 如果是下拉刷新 先删除缓存
    if (refresh) {
      if (options.extra['list'] == true) {
        // 若是列表，则只要url中包含当前path的缓存全部删除
        cache.removeWhere((key, value) => key.contains(options.path));
      } else {
        // 如果不是列表，则只删除uri相同的缓存
        delete(options.uri.toString());
      }

      // 删除磁盘缓存
      if (cacheDisk) {
        await StorageUtil().remove(options.uri.toString());
      }

      return handler.next(options);
    }

    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      // 1 内存缓存
      var ob = cache[key];
      if (ob != null) {
        //若缓存未过期，则返回缓存内容
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            cacheMaxage) {
          return handler.resolve(cache[key]!.response);
        } else {
          //若已过期则删除缓存，继续向服务器请求
          cache.remove(key);
        }
      }

      // 2 磁盘缓存
      if (cacheDisk) {
        var cacheData = StorageUtil().getJSON(key);
        if (cacheData != null) {
          return handler.resolve(Response(
            requestOptions: options,
            statusCode: 200,
            data: cacheData,
          ));
        }
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // 如果启用缓存，将返回结果保存到缓存
    if (cacheEnable) {
      await _saveCache(response);
    }
    handler.next(response);
  }

  Future<void> _saveCache(Response object) async {
    RequestOptions options = object.requestOptions;

    // 只缓存 get 的请求
    if (options.extra["noCache"] != true &&
        options.method.toLowerCase() == "get") {
      // 策略：内存、磁盘都写缓存

      // 缓存key
      String key = options.extra["cacheKey"] ?? options.uri.toString();

      // 磁盘缓存
      if (options.extra["cacheDisk"] == true) {
        await StorageUtil().setJSON(key, object.data);
      }

      // 内存缓存
      // 如果缓存数量超过最大数量限制，则先移除最早的一条记录
      if (cache.length == cacheMaxcount) {
        cache.remove(cache[cache.keys.first]);
      }

      cache[key] = CacheObject(object);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}
