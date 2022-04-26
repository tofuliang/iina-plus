//
//  BiliLive.swift
//  IINA+
//
//  Created by xjbeta on 4/26/22.
//  Copyright © 2022 xjbeta. All rights reserved.
//

import Cocoa
import PromiseKit
import Alamofire
import PMKAlamofire
import Marshal

class BiliLive: NSObject, SupportSiteProtocol {
    func liveInfo(_ url: String) -> Promise<LiveInfo> {
        var info = BiliLiveInfo()
        return getBiliLiveRoomId(url).get {
            info = $0
        }.then {
            self.getBiliUserInfo($0.roomId)
        }.map {
            info.name = $0.name
            info.avatar = $0.avatar
            return info
        }
    }
    
    func decodeUrl(_ url: String) -> Promise<YouGetJSON> {
        var yougetJson = YouGetJSON(rawUrl: url)
        return getBiliLiveRoomId(url).get {
            yougetJson.title = $0.title
            yougetJson.id = $0.roomId
        }.then {
            self.getBiliLiveJSON("\($0.roomId)")
        }.map {
            $0.write(to: yougetJson)
        }
    }
    
    func getBiliLiveRoomId(_ url: String) -> Promise<(BiliLiveInfo)> {
        AF.request("https://api.live.bilibili.com/room/v1/Room/get_info?room_id=\(url.lastPathComponent)").responseData().map {
            let json: JSONObject = try JSONParser.JSONObjectWithData($0.data)
            let longID: Int = try json.value(for: "data.room_id")

            var info = BiliLiveInfo()
            info.title = try json.value(for: "data.title")
            info.isLiving = try json.value(for: "data.live_status") == 1
            info.roomId = longID
            info.cover = try json.value(for: "data.user_cover")
            return info
        }
    }
    
    func getBiliUserInfo(_ roomId: Int) -> Promise<(BiliLiveInfo)> {
        AF.request("https://api.live.bilibili.com/live_user/v1/UserInfo/get_anchor_in_room?roomid=\(roomId)").responseData().map {
            let json: JSONObject = try JSONParser.JSONObjectWithData($0.data)
            var info = BiliLiveInfo()
            info.name = try json.value(for: "data.info.uname")
            info.avatar = try json.value(for: "data.info.face")
            return info
        }
    }
    
    func getBiliLiveJSON(_ roomID: String, _ quality: Int = 20000) -> Promise<(BiliLivePlayUrl)> {
        AF.request("https://api.live.bilibili.com/xlive/web-room/v2/index/getRoomPlayInfo?room_id=\(roomID)&protocol=0,1&format=0,1,2&codec=0,1&qn=\(quality)&platform=web&ptype=8").responseData().map {
            let json: JSONObject = try JSONParser.JSONObjectWithData($0.data)
            let playUrl: BiliLivePlayUrl = try BiliLivePlayUrl(object: json)
            return playUrl
        }
    }
}

struct BiliLiveInfo: Unmarshaling, LiveInfo {
    var title: String = ""
    var name: String = ""
    var avatar: String = ""
    var isLiving = false
    var roomId: Int = -1
    var cover: String = ""
    
    var site: SupportSites = .biliLive
    
    init() {
    }
    
    init(object: MarshaledObject) throws {
        title = try object.value(for: "title")
        name = try object.value(for: "info.uname")
        avatar = try object.value(for: "info.face")
        isLiving = "\(try object.any(for: "live_status"))" == "1"
    }
}

struct BiliLivePlayUrl: Unmarshaling {
    let qualityDescriptions: [QualityDescription]
    let streams: [BiliLiveStream]

    struct QualityDescription: Unmarshaling {
        let qn: Int
        let desc: String
        init(object: MarshaledObject) throws {
            qn = try object.value(for: "qn")
            desc = try object.value(for: "desc")
        }
    }
    
    struct BiliLiveStream: Unmarshaling {
        let protocolName: String
        let formats: [Format]
        init(object: MarshaledObject) throws {
            protocolName = try object.value(for: "protocol_name")
            formats = try object.value(for: "format")
        }
    }
    
    struct Format: Unmarshaling {
        let formatName: String
        let codecs: [Codec]
        init(object: MarshaledObject) throws {
            formatName = try object.value(for: "format_name")
            codecs = try object.value(for: "codec")
        }
    }
    
    struct Codec: Unmarshaling {
        let codecName: String
        let currentQn: Int
        let acceptQns: [Int]
        let baseUrl: String
        let urlInfos: [UrlInfo]
        init(object: MarshaledObject) throws {
            codecName = try object.value(for: "codec_name")
            currentQn = try object.value(for: "current_qn")
            acceptQns = try object.value(for: "accept_qn")
            baseUrl = try object.value(for: "base_url")
            urlInfos = try object.value(for: "url_info")
        }
        
        func urls() -> [String] {
            urlInfos.map {
                $0.host + baseUrl + $0.extra
            }
        }
    }
    
    struct UrlInfo: Unmarshaling {
        let host: String
        let extra: String
        let streamTtl: Int
        init(object: MarshaledObject) throws {
            host = try object.value(for: "host")
            extra = try object.value(for: "extra")
            streamTtl = try object.value(for: "stream_ttl")
        }
    }
    
    init(object: MarshaledObject) throws {
        qualityDescriptions = try object.value(for: "data.playurl_info.playurl.g_qn_desc")
        streams = try object.value(for: "data.playurl_info.playurl.stream")
    }
    
    func write(to yougetJson: YouGetJSON) -> YouGetJSON {
        var json = yougetJson
        
        let codecs = streams.flatMap {
            $0.formats.flatMap {
                $0.codecs
            }
        }
        
//        if let codec = codecs.last(where: { $0.codecName == "hevc" }) ?? codecs.first {
        if let codec = codecs.first {
            qualityDescriptions.filter {
                codec.acceptQns.contains($0.qn)
            }.forEach {
                var s = Stream(url: "")
                s.quality = $0.qn
                if codec.currentQn == $0.qn {
                    var urls = codec.urls()
                    s.url = urls.removeFirst()
                    s.src = urls
                }
                json.streams[$0.desc] = s
            }
        }
        
        return json
    }
}
