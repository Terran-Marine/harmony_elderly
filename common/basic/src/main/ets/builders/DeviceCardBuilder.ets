import { ResManager } from '../utils'
import { router } from '@kit.ArkUI'
import { RouterConfig } from '../../../../Index'

export enum Pos {
  x = 'x',
  y = 'y'
}


/**
 * 模块item
 *
 * @param title
 * @param icon
 * @param pos
 * @param url
 */
@Builder
export function careItem(title: string, icon: ResourceStr, pos: Pos, url: string = '') {
  if (pos === Pos.x) {
    // 护理工作台
    Row({ space: 10 }) {
      Image(icon)
        .width(48)
        .aspectRatio(1)
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .padding({
      top: 20,
      bottom: 23,
      left: 13,
      right: 13
    })
    // .borderRadius(8)
    // .layoutWeight(1)
    // .backgroundColor(ResManager.EC_MID_WHITE)
    .modStyle()
    .onClick(() => {
      router.pushUrl({
        url
      })
    })
  } else {
    // 设备管理
    Column({ space: 10 }) {
      Image(icon)
        .width(40)
        .aspectRatio(1)
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_SMALL_FS)
    }
    .padding({ top: 23, bottom: 23 })
    // .borderRadius(8)
    // .layoutWeight(1)
    // .backgroundColor(ResManager.EC_MID_WHITE)
    .modStyle()
    .onClick(() => {
      router.pushUrl({
        url
      })
    })
  }
}

// 可复用样式
@Styles
function modStyle() {
  .borderRadius(8)
  .layoutWeight(1)
  .backgroundColor(ResManager.EC_MID_WHITE)
}

@Builder
export function DeviceLayoutBuilder() {
  Row({ space: 10 }) {
    careItem('设备安装', $r('app.media.icon_home_sbaz'), Pos.y, RouterConfig.DEVICE_SETUP_URL)
    careItem('设备绑定', $r('app.media.icon_home_sbkz'), Pos.y, RouterConfig.DEVICE_BIND_URL)
    careItem('我的设备', $r('app.media.icon_home_wdsb'), Pos.y, RouterConfig.DEVICE_MY_URL)
    careItem('报警设备', $r('app.media.icon_home_bjsb'), Pos.y, RouterConfig.DEVICE_ALARM_URL)
  }.width('100%')
  .justifyContent(FlexAlign.SpaceBetween)
}
