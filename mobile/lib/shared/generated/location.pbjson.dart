// This is a generated file - do not edit.
//
// Generated from location.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use locationUpdateDescriptor instead')
const LocationUpdate$json = {
  '1': 'LocationUpdate',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 3, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'accuracy', '3': 4, '4': 1, '5': 2, '10': 'accuracy'},
    {'1': 'speed', '3': 5, '4': 1, '5': 2, '10': 'speed'},
    {'1': 'heading', '3': 6, '4': 1, '5': 2, '10': 'heading'},
    {'1': 'battery_level', '3': 7, '4': 1, '5': 2, '10': 'batteryLevel'},
    {'1': 'timestamp', '3': 8, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'is_charging', '3': 9, '4': 1, '5': 8, '10': 'isCharging'},
  ],
};

/// Descriptor for `LocationUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationUpdateDescriptor = $convert.base64Decode(
    'Cg5Mb2NhdGlvblVwZGF0ZRIXCgd1c2VyX2lkGAEgASgJUgZ1c2VySWQSGgoIbGF0aXR1ZGUYAi'
    'ABKAFSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgDIAEoAVIJbG9uZ2l0dWRlEhoKCGFjY3VyYWN5'
    'GAQgASgCUghhY2N1cmFjeRIUCgVzcGVlZBgFIAEoAlIFc3BlZWQSGAoHaGVhZGluZxgGIAEoAl'
    'IHaGVhZGluZxIjCg1iYXR0ZXJ5X2xldmVsGAcgASgCUgxiYXR0ZXJ5TGV2ZWwSHAoJdGltZXN0'
    'YW1wGAggASgDUgl0aW1lc3RhbXASHwoLaXNfY2hhcmdpbmcYCSABKAhSCmlzQ2hhcmdpbmc=');

@$core.Deprecated('Use locationBatchDescriptor instead')
const LocationBatch$json = {
  '1': 'LocationBatch',
  '2': [
    {'1': 'updates', '3': 1, '4': 3, '5': 11, '6': '.family_tracker.LocationUpdate', '10': 'updates'},
  ],
};

/// Descriptor for `LocationBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationBatchDescriptor = $convert.base64Decode(
    'Cg1Mb2NhdGlvbkJhdGNoEjgKB3VwZGF0ZXMYASADKAsyHi5mYW1pbHlfdHJhY2tlci5Mb2NhdG'
    'lvblVwZGF0ZVIHdXBkYXRlcw==');

