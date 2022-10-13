import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:potok/resources/models/comment.dart';
import 'package:potok/resources/models/loadable_list.dart';
import 'package:potok/resources/models/parsed_response.dart';
import 'package:potok/resources/models/share.dart';
import 'package:potok/resources/repositories/repository_base.dart';

class CommentRepository extends RepositoryBase {
  CommentRepository(BuildContext context) : super(context);

  Future<ParsedResponse<Comment>> fetchComment(int commentId) async {
    Response response = await client.get('/api/comments/$commentId/');
    return ParsedResponse(response, Comment.fromJson(response.data));
  }

  Future<LoadMoreResponse<Comment>> fetchPictureComments(
      int pictureId, int page) async {
    Response response = await client.get('/api/pictures/$pictureId/comments/');
    return LoadMoreCommentsResponse.fromJson(response.data);
  }

  Future<Response> likeComment(int commentId) async {
    Response response = await client.put('/api/comments/$commentId/like/');
    return response;
  }

  Future<Response> dislikeComment(int commentId) async {
    Response response = await client.delete('/api/comments/$commentId/like/');
    return response;
  }

  Future<ParsedResponse<Share>> shareComment(int commentId) async {
    Response response = await client.get('/api/comments/$commentId/share/');
    return ParsedResponse(response, Share.fromJson(response.data));
  }

  Future<Response> reportComment(int commentId) async {
    Response response = await client.put('/api/comments/$commentId/report/');
    return response;
  }
}
