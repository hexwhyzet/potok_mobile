import 'package:flutter/cupertino.dart';

abstract class JsonResource {
  @factory
  JsonResource fromJson(Map<String, dynamic> json);
}
