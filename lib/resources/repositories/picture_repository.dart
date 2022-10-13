import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:potok/resources/models/loadable_list.dart';
import 'package:potok/resources/models/parsed_response.dart';
import 'package:potok/resources/models/picture.dart';
import 'package:potok/resources/models/share.dart';
import 'package:potok/resources/repositories/repository_base.dart';

class PictureRepository extends RepositoryBase {
  PictureRepository(BuildContext context) : super(context);

  Future<ParsedResponse<Picture>> fetchPicture(int pictureId) async {
    Response response = await this.client.get('/api/pictures/$pictureId');
    return ParsedResponse(response, Picture.fromJson(response.data));
  }

  Future<LoadMoreResponse<Picture>> fetchProfilePictures(
      int profileId, int page) async {
    Response response =
        await this.client.get('/api/profiles/$profileId/pictures/?page=$page');
    return LoadMorePicturesResponse.fromJson(response.data);
  }

  Future<Response> likePicture(int pictureId) async {
    return this.client.put('/api/pictures/$pictureId/like/');
  }

  Future<Response> dislikePicture(int pictureId) async {
    return this.client.delete('/api/pictures/$pictureId/like/');
  }

  Future<ParsedResponse<Share>> sharePicture(int pictureId) async {
    Response response =
        await this.client.get('/api/pictures/$pictureId/share/');
    return ParsedResponse(response, Share.fromJson(response.data));
  }
}
