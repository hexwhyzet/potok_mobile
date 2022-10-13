import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:potok/resources/models/profile.dart';
import 'package:potok/resources/models/profile_preview.dart';
import 'package:potok/resources/repositories/repository_base.dart';

class ProfileRepository extends RepositoryBase {
  ProfileRepository(BuildContext context) : super(context);

  Future<Profile> fetchProfile(int profileId) async {
    Response response = await client.get('/api/profiles/$profileId/');
    return Profile.fromJson(response.data);
  }

  Future<ProfilePreview> fetchProfilePreview(int profileId) async {
    Response response = await client.get('/api/profiles/$profileId/preview/');
    return ProfilePreview.fromJson(response.data);
  }

  Future<Response> subscribe(int profileId) async {
    Response response = await client.put('/api/profiles/$profileId/subscription/');
    return response;
  }

  Future<Response> unsubscribe(int profileId) async {
    Response response = await client.delete('/api/profiles/$profileId/subscription/');
    return response;
  }
}
