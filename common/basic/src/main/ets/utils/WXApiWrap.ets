import { Log } from '@abner/log';
import * as wxopensdk from '@tencent/wechat_open_sdk';

const APP_ID = "wx5881fa2638a2ca60"

// WXApi 是第三方app和微信通信的openApi接口，其实例通过WXAPIFactory获取，需要传入应用申请到的AppID
export const WXApi = wxopensdk.WXAPIFactory.createWXAPI(APP_ID)

export type OnWXReq = (req: wxopensdk.BaseReq) => void

export type OnWXResp = (resp: wxopensdk.BaseResp) => void


// WXApiEventHandler为微信数据的回调
class WXApiEventHandlerImpl implements wxopensdk.WXApiEventHandler {
  private onReqCallbacks: Map<OnWXReq, OnWXReq> = new Map
  private onRespCallbacks: Map<OnWXResp, OnWXResp> = new Map

  registerOnWXReqCallback(on: OnWXReq) {
    this.onReqCallbacks.set(on, on)
  }

  unregisterOnWXReqCallback(on: OnWXReq) {
    this.onReqCallbacks.delete(on)
  }

  registerOnWXRespCallback(on: OnWXResp) {
    this.onRespCallbacks.set(on, on)
  }

  unregisterOnWXRespCallback(on: OnWXResp) {
    this.onRespCallbacks.delete(on)
  }

  onReq(req: wxopensdk.BaseReq): void {
    Log.info(`微信 onReq${JSON.stringify(req)}`)
    this.onReqCallbacks.forEach((on) => {
      on(req)
    })
  }

  onResp(resp: wxopensdk.BaseResp): void {
    Log.info(`微信 onResp${JSON.stringify(resp)}`)
    this.onRespCallbacks.forEach((on) => {
      on(resp)
    })
  }
}

export const WXEventHandler = new WXApiEventHandlerImpl