import router from '@ohos.router'
import { EcDialogUpload, getUserInfoApi, ResManager, RouterConfig, UserInfoModel } from '@hm/basic/Index'
import { Log } from '@abner/log'
import { fileIo } from '@kit.CoreFileKit'


@Entry
@Component
struct Setting {
  @StorageProp('topHeight')
  topHeight: number = 0
  // 上传弹层控制
  uploadDialog: CustomDialogController = new CustomDialogController({
    // 使用自定义弹层组件
    builder: EcDialogUpload({
      callback: (url: string) => {
        this.photoUpload(url)
      }
    }),
    alignment: DialogAlignment.Bottom
  })
  @State
  userInfo: UserInfoModel = {} as UserInfoModel

  async photoUpload(url: string) {
    try {
      const imageFile = fileIo.openSync(url, fileIo.OpenMode.READ_ONLY)

      const appImageFile = `${getContext().cacheDir}/${imageFile.name}`

      fileIo.copyFileSync(imageFile.fd, appImageFile)


      Log.info(`photoUpload : ${appImageFile}`)
      this.userInfo = {
        avatar: `${appImageFile}`
      } as UserInfoModel

      // const formData = new FormData()
      // formData.append("file", `internal://${appImageFile}`)
      //
      // const res = await UploadApi(formData)
      //
      // AlertDialog.show({ message: res })


    } catch (e) {
      Log.error(e)
    }
  }

  aboutToAppear(): void {
    this.getUserInfo()
  }

  async getUserInfo() {
    try {
      this.userInfo = await getUserInfoApi()
      Log.info(`userInfo ${JSON.stringify(this.userInfo)}`)
    } catch (e) {
      Log.error(e)
    }
  }

  @Builder
  cellItem(title: string, rightContent: string = '') {
    Row() {
      Text(title)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_MODULE_TITLE_FS)
        .fontWeight(500)
      Row({ space: 10 }) {
        if (rightContent) {
          // 昵称修改
          Text(rightContent)
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_NORMAL_FS)
        } else {
          // 上传
          Image(this.userInfo.avatar ||
            'https://bkimg.cdn.bcebos.com/pic/8c1001e93901213fb80eea5d87b021d12f2eb8383fa0?x-bce-process=image/format,f_auto/watermark,image_d2F0ZXIvYmFpa2UyNzI,g_7,xp_5,yp_5,P_20/resize,m_lfit,limit_1,h_1080')
            .width(34)
            .aspectRatio(1)
            .borderRadius(17)

          // Image("/data/storage/el2/base/haps/phone/cache/medal_save.png")
          //   .width(34)
          //   .aspectRatio(1)
          //   .borderRadius(17)

        }
        Image($r('app.media.ic_arrow_black'))
          .width(7)
          .height(16)
      }
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .justifyContent(FlexAlign.SpaceBetween)
    .onClick(() => {
      if (rightContent) {
        router.pushUrl({
          url: RouterConfig.USER_NAME_URL
        })
      } else {
        this.uploadDialog.open()
      }
    })
  }

  build() {
    Navigation() {
      Column() {
        Column() {
          List() {
            ListItem() {
              this.cellItem('头像')
            }

            ListItem() {
              this.cellItem('昵称', this.userInfo.nickName || '许家印')
            }
          }
          .width('100%')
          .height('auto')
          .padding({ left: 14, right: 18, })
          .divider({ strokeWidth: 1, color: ResManager.EC_MID_LINE })
        }
        .margin({
          top: ResManager.EC_CONTENT_SPACE,
          left: ResManager.EC_CONTENT_SPACE,
          right: ResManager.EC_CONTENT_SPACE
        })
        // .width('100%')
        .backgroundColor('#fff')
        .borderRadius(ResManager.EC_NORMAL_RD)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .title('个人设置')
    .padding({ top: this.topHeight })
    .titleMode(NavigationTitleMode.Mini)
  }
}

