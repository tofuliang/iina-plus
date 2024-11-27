// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: DouYinPushFrame.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct DouYinPushFrame {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var seqid: Int64 = 0

  var logid: Int64 = 0

  var service: Int64 = 0

  var method: Int64 = 0

  var headersList: String = String()

  var payloadEncoding: String = String()

  var payloadType: String = String()

  var data: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

#if swift(>=5.5) && canImport(_Concurrency)
extension DouYinPushFrame: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension DouYinPushFrame: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "DouYinPushFrame"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "seqid"),
    2: .same(proto: "logid"),
    3: .same(proto: "service"),
    4: .same(proto: "method"),
    5: .same(proto: "headersList"),
    6: .same(proto: "payloadEncoding"),
    7: .same(proto: "payloadType"),
    8: .same(proto: "data"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt64Field(value: &self.seqid) }()
      case 2: try { try decoder.decodeSingularInt64Field(value: &self.logid) }()
      case 3: try { try decoder.decodeSingularInt64Field(value: &self.service) }()
      case 4: try { try decoder.decodeSingularInt64Field(value: &self.method) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.headersList) }()
      case 6: try { try decoder.decodeSingularStringField(value: &self.payloadEncoding) }()
      case 7: try { try decoder.decodeSingularStringField(value: &self.payloadType) }()
      case 8: try { try decoder.decodeSingularBytesField(value: &self.data) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.seqid != 0 {
      try visitor.visitSingularInt64Field(value: self.seqid, fieldNumber: 1)
    }
    if self.logid != 0 {
      try visitor.visitSingularInt64Field(value: self.logid, fieldNumber: 2)
    }
    if self.service != 0 {
      try visitor.visitSingularInt64Field(value: self.service, fieldNumber: 3)
    }
    if self.method != 0 {
      try visitor.visitSingularInt64Field(value: self.method, fieldNumber: 4)
    }
    if !self.headersList.isEmpty {
      try visitor.visitSingularStringField(value: self.headersList, fieldNumber: 5)
    }
    if !self.payloadEncoding.isEmpty {
      try visitor.visitSingularStringField(value: self.payloadEncoding, fieldNumber: 6)
    }
    if !self.payloadType.isEmpty {
      try visitor.visitSingularStringField(value: self.payloadType, fieldNumber: 7)
    }
    if !self.data.isEmpty {
      try visitor.visitSingularBytesField(value: self.data, fieldNumber: 8)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: DouYinPushFrame, rhs: DouYinPushFrame) -> Bool {
    if lhs.seqid != rhs.seqid {return false}
    if lhs.logid != rhs.logid {return false}
    if lhs.service != rhs.service {return false}
    if lhs.method != rhs.method {return false}
    if lhs.headersList != rhs.headersList {return false}
    if lhs.payloadEncoding != rhs.payloadEncoding {return false}
    if lhs.payloadType != rhs.payloadType {return false}
    if lhs.data != rhs.data {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
