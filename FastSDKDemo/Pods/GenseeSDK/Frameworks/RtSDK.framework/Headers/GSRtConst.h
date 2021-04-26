//
//  GSRtConst.h
//  RtSDK
//
//  Created by net263 on 2020/10/27.
//  Copyright © 2020 Geensee. All rights reserved.
//

#ifndef GSRtConst_h
#define GSRtConst_h
typedef NS_ENUM(NSInteger, GSRandomSelectType) {
    GSRANDOMSELECT_BEGIN = 1,
    GSRANDOMSELECT_RESULT,
    GSRANDOMSELECT_CANCEL
};

#define GS_KEY_CLASS_NAME   @"training.class.name"
#define GS_KEY_CLASS_ID   @"training.class.id"
#define GS_KEY_MY_NAME   @"training.user.my.name"
#define GS_KEY_MY_ID   @"training.user.my.id"
#define GS_KEY_AUDIO_CODEC_TYPE   @"save.audio.codec"
#define GS_KEY_VIDEO_W   @"save.video.width"
#define GS_KEY_VIDEO_H   @"save.video.height"
#define GS_KEY_VIDEO_FPS   @"save.video.fps"
#define GS_KEY_VIDEO_RATIO   @"save.video.ratio"
#define GS_KEY_APP_VERSION   @"app.version"
#define GS_KEY_APP_PLATFORM   @"app.platform"
#define GS_KEY_WEB_URL   @"class.info.web.url"
#define GS_KEY_UPLOAD_URL   @"diagnose.upload.url"
#define GS_KEY_SITE_ID   @"site.id"
#define GS_KEY_ALB_ADDRESS   @"alb.address"
#define GS_KEY_ALB_ADDRESS2   @"alb.address.2"
#define GS_KEY_WEB_API_URL   @"web.api.url"
#define GS_KEY_USER_MY_ROLE   @"training.user.my.role"
#define GS_KEY_RECORD_MODE   @"record.mode"//0:not auto; 1: auto after join; 2: auto after broadcast
#define GS_KEY_AS_DOUBLE_STREAM   @"as.enable.doublestream" //0:not enable; 1: enable
#define GS_KEY_CHAT_DISABLE_ATTENDEE_PRIVATE      @"chat.disable.attendee.private"    //0:enabled [default]; 1: disabled
#define GS_KEY_HONGBAO_ENABLE   @"hongbao.enable"    //0: disabled; 1: enabled;
#define GS_KEY_DASHANG_ENABLE   @"dashang.enable"    //0: disabled; 1: enabled;
#define GS_KEY_WEB_PLAYER_URL   @"url.for.preview.of.webplayer"
#define GS_KEY_USER_ATTENDEE_PUSH   @"user.attendee.push"  //0: no push; 1: push[default]
#define GS_KEY_USER_REAL_COUNT   @"user.real.count"
#define GS_KEY_VIDEO_LOGO_DATA_PNG   @"video.logo.data.png"
#define GS_KEY_CHAT_BARRAGE_ENABLE   @"chat.barrage.enable"
#define GS_KEY_PICSERVERADDRESS        @"pic.server.address"
#define GS_KEY_CONFTYPE            @"training.conf.type"



#define GS_KEY_SAVE_LOD_WIDTH    @"save.lod.width"
#define GS_KEY_SAVE_LOD_HEIGHT   @"save.lod.height"
#define GS_KEY_SAVE_LOD_FPS      @"save.lod.fps"

#define GS_KEY_VIDEO_HARDWARE_ENCODE   @"video.hw.encode"            // val   1 : support hardware encoding
#define GS_KEY_VIDEO_HARDWARE_FORCEKEY  @"video.hw.encode.forcekey"    // val   1 : generate new avc info

#define GS_KEY_AS_MAX_FPS   @"as.max.fps"

#define GS_KEY_INTERACT_URL   @"Interact.url"// 参加者打赏订单url

//ios 商店审核问题，修改掉阿里和微信支付的标识
#define GS_KEY_ALI_PAY_ENABLE      @"pay.ol.type.1.enable"//支付宝
#define GS_KEY_WECHAT_PAY_ENABLE   @"pay.ol.type.2.enable"//微信"
#define GS_String KEY_REWARD_RANGE   @"reward.range"

#define GS_KEY_CAMERA_INDEX   @"KEY_CAMERA_INDEX"
#define GS_KEY_VIDEO_DOC_RATIO   @"KEY_VIDEO_DOC_RATIO"
#define GS_KEY_MEDAL_ENABLE   @"medal.enable"
#define GS_KEY_FAVOUR_ENABLE   @"praise.enable"
#define GS_KEY_ANTIRECORDSCREEN_ENABLE   @"anti.record.screen"
#define GS_KEY_ANTIRECORDSCREEN_LEVEL   @"anti.record.screen.level"

#define GS_KEY_TEACHER_VIDEO_SEAT @"teacher_video_seat"
#define GS_KEY_ATTENDE_VIDEO_SEAT @"attende_video_seat"

#define GS_KEY_COUNTDOWN @"CountDown"
#define GS_KEY_RESPONDER @"Responder"

#define GS_KEY_MINICLASS_AUTO_UP_SEAT        @"miniclass.auto.upseat"//自动上席
#define GS_KEY_BHVUPLOAD_URL                @"bhvupload.url"            //外推URL
#define GS_KEY_BHVUPLOAD_ENABLE            @"bhvupload.enable"          //外推是否可用

//roomdata
#define GS_KEY_USER_ROSTRUM            @"user.rostrum"
#define GS_KEY_USER_ASKER              @"user.asker"
#define GS_KEY_USER_ASKER_1            @"user.asker.1"
#define GS_KEY_USER_ASKER_2            @"user.asker.2"
#define GS_KEY_USER_ASKER_3            @"user.asker.3"
#define GS_KEY_CLASS_MODE              @"class.mode"                //1:free; 0:non-free
#define GS_KEY_CHAT_MODE               @"chat.mode"                    //0:deny; 1:allow all; 2: allow public only; 3: allow private only
#define GS_KEY_QA_MODE                 @"qa.mode"
#define GS_KEY_PANELIST_MIC_ENABLE     @"panelist.mic.enable"        //0: deny, 1: enable
#define GS_KEY_PANELIST_SHOW_ENABLE    @"panelist.show.attendee.enable"
#define GS_KEY_SCREEN_LOCK             @"screen.lock"                //screen look, 1: lock, 0: free
#define GS_KEY_ASKER_ANNO              @"asker.anno"                //asker anno, 1: enbale[def], 0: disable
#define GS_KEY_HONGBAO_KEY             @"hongbao.key"
#define GS_KEY_DOC_PREVIEW             @"doc.preview"                //0: disable, 1: enable
#define GS_KEY_HANDUP_USERLIST_ORDER   @"handup.userlist.order"
#define GS_KEY_CHAT_CENSOR             @"chat.censor"                //0: disable, 1: enable
#define GS_KEY_USER_APP_USER_INFO      @"user.app.info"
#define GS_KEY_DBT_STATUS              @"dbt.status"
#define GS_DOUBLE_TEACHER_KEY_CLASS_STATE            @"dtk.class.state" //short for double teacher class state, val: "0", stop; "1", start
#define GS_KEY_VCLASS_STATUS            @"vclass_status"
#define GS_KEY_TEACHER_VIDEO_SEAT       @"teacher_video_seat"
#define GS_KEY_ATTENDE_VIDEO_SEAT       @"attende_video_seat"
#define GS_VIDEO_PREVIEW_ENABLE         @"video.preview.enabled"
#define GS_KEY_CLASS_END_COUNTDOWN       @"class_end_countdown"
#define GS_KEY_CLASS_REPORT              @"class_report"
#define GS_KEY_VIDEO_LAYOUT_SWITCH          @"video.layout.switch" //0 常规演示，1视频墙模式
#define GS_KEY_MCC_AUTO_RECORD              @"class.config.auto.record" //自动开始录制
#define GS_KEY_MCC_AUTO_RING                @"class.config.auto.ring"                //上课自动打铃
#define GS_KEY_MCC_AUTO_STOP_RECORD         @"class.config.auto.stoprecord"          //自动结束录制
#define GS_KEY_MCC_AUTO_END_RING            @"class.config.auto.endring"             //下课自动打铃
#define GS_KEY_MCC_AUTO_REPORT              @"class.config.auto.report"              //弹出学员课堂报告
#define GS_KEY_MCC_SEAT_WITH_RACE           @"class.config.seat.with.race"           //抢答自动上台
#define GS_KEY_MCC_ANNO_WITH_SEAT           @"class.config.anno.with.seat"           //上席自动获取标注权限
#define GS_KEY_MCC_FORCE_TOP                @"class.config.force.top"                //学员强制置顶
#define GS_KEY_MCC_PREVIEW_DOC              @"class.config.preview.doc"              //文档预览
#define GS_KEY_MCC_PRAISE_ENABLE            @"class.config.praise.enable"            //开启点赞
#define GS_KET_VIDEO_RESOLUTION_INDEX       @"video.resolution.index"        //0 320*180 1 640*360 2 1280*720
#define GS_KEY_VIDEO_FPS_INDEX              @"video.fps.index"                //0 15 1 20 2 25
#endif
