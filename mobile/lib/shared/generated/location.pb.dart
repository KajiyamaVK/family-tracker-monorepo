// This is a generated file - do not edit.
//
// Generated from location.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Defines a single GPS coordinate update.
/// We use 'double' for lat/lng for maximum precision (PostGIS requirement).
class LocationUpdate extends $pb.GeneratedMessage {
  factory LocationUpdate({
    $core.String? userId,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? accuracy,
    $core.double? speed,
    $core.double? heading,
    $core.double? batteryLevel,
    $fixnum.Int64? timestamp,
    $core.bool? isCharging,
  }) {
    final result = create();
    if (userId != null) result.userId = userId;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (accuracy != null) result.accuracy = accuracy;
    if (speed != null) result.speed = speed;
    if (heading != null) result.heading = heading;
    if (batteryLevel != null) result.batteryLevel = batteryLevel;
    if (timestamp != null) result.timestamp = timestamp;
    if (isCharging != null) result.isCharging = isCharging;
    return result;
  }

  LocationUpdate._();

  factory LocationUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory LocationUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LocationUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'family_tracker'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'accuracy', $pb.PbFieldType.OF)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'speed', $pb.PbFieldType.OF)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'heading', $pb.PbFieldType.OF)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'batteryLevel', $pb.PbFieldType.OF)
    ..aInt64(8, _omitFieldNames ? '' : 'timestamp')
    ..aOB(9, _omitFieldNames ? '' : 'isCharging')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocationUpdate clone() => LocationUpdate()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocationUpdate copyWith(void Function(LocationUpdate) updates) => super.copyWith((message) => updates(message as LocationUpdate)) as LocationUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LocationUpdate create() => LocationUpdate._();
  @$core.override
  LocationUpdate createEmptyInstance() => create();
  static $pb.PbList<LocationUpdate> createRepeated() => $pb.PbList<LocationUpdate>();
  @$core.pragma('dart2js:noInline')
  static LocationUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocationUpdate>(create);
  static LocationUpdate? _defaultInstance;

  /// UUID of the user (v4 string)
  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => $_clearField(1);

  /// Latitude in decimal degrees (e.g., -23.5505)
  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  /// Longitude in decimal degrees (e.g., -46.6333)
  @$pb.TagNumber(3)
  $core.double get longitude => $_getN(2);
  @$pb.TagNumber(3)
  set longitude($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLongitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitude() => $_clearField(3);

  /// Accuracy in meters (Vital for filtering "ghost" jumps)
  @$pb.TagNumber(4)
  $core.double get accuracy => $_getN(3);
  @$pb.TagNumber(4)
  set accuracy($core.double value) => $_setFloat(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccuracy() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccuracy() => $_clearField(4);

  /// Speed in meters/second (Used to detect driving vs walking)
  @$pb.TagNumber(5)
  $core.double get speed => $_getN(4);
  @$pb.TagNumber(5)
  set speed($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpeed() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpeed() => $_clearField(5);

  /// Heading/Bearing in degrees (0-360)
  @$pb.TagNumber(6)
  $core.double get heading => $_getN(5);
  @$pb.TagNumber(6)
  set heading($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHeading() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeading() => $_clearField(6);

  /// Battery level (0.0 to 1.0) - Critical for debugging client issues
  @$pb.TagNumber(7)
  $core.double get batteryLevel => $_getN(6);
  @$pb.TagNumber(7)
  set batteryLevel($core.double value) => $_setFloat(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBatteryLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearBatteryLevel() => $_clearField(7);

  /// Unix timestamp (milliseconds) when the location was RECORDED (not sent)
  @$pb.TagNumber(8)
  $fixnum.Int64 get timestamp => $_getI64(7);
  @$pb.TagNumber(8)
  set timestamp($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTimestamp() => $_has(7);
  @$pb.TagNumber(8)
  void clearTimestamp() => $_clearField(8);

  /// Is the device charging? (Helping distinguish "Plugged in car" vs "Home")
  @$pb.TagNumber(9)
  $core.bool get isCharging => $_getBF(8);
  @$pb.TagNumber(9)
  set isCharging($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIsCharging() => $_has(8);
  @$pb.TagNumber(9)
  void clearIsCharging() => $_clearField(9);
}

/// A batch of updates (for offline syncing)
/// When the device comes back online, it sends a list of these.
class LocationBatch extends $pb.GeneratedMessage {
  factory LocationBatch({
    $core.Iterable<LocationUpdate>? updates,
  }) {
    final result = create();
    if (updates != null) result.updates.addAll(updates);
    return result;
  }

  LocationBatch._();

  factory LocationBatch.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory LocationBatch.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LocationBatch', package: const $pb.PackageName(_omitMessageNames ? '' : 'family_tracker'), createEmptyInstance: create)
    ..pc<LocationUpdate>(1, _omitFieldNames ? '' : 'updates', $pb.PbFieldType.PM, subBuilder: LocationUpdate.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocationBatch clone() => LocationBatch()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LocationBatch copyWith(void Function(LocationBatch) updates) => super.copyWith((message) => updates(message as LocationBatch)) as LocationBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LocationBatch create() => LocationBatch._();
  @$core.override
  LocationBatch createEmptyInstance() => create();
  static $pb.PbList<LocationBatch> createRepeated() => $pb.PbList<LocationBatch>();
  @$core.pragma('dart2js:noInline')
  static LocationBatch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LocationBatch>(create);
  static LocationBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LocationUpdate> get updates => $_getList(0);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
