import { ResManager, UserAuthStoreInstance, WXApi } from '@hm/basic/Index';

import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from '@abner/log';
import * as wxopensdk from '@tencent/wechat_open_sdk';
import { common } from '@kit.AbilityKit';
import { router } from '@kit.ArkUI';


@Entry
@Component
struct Login {
  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        // app 信息
        Column() {
          Image($r("app.media.pic_login_icon"))
            .width(124)
            .height(76)
            .margin({ bottom: 20 })
          Text() {
            Span('翼康养老')
              .fontColor('#000')
              .fontSize(24)
              .fontWeight(700)
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#fff')

        Button({ stateEffect: true }) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('华为登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }
        }
        .margin({ top: 150 })
        .width(250)
        .height(40)
        .backgroundColor(ResManager.EC_MAIN_COLOR)
        .onClick(() => {
          this.handleHWLogin()
        })


        Button({ stateEffect: true }) {
          Row({ space: 6.5 }) {
            Image(ResManager.IC_HUAWEI)
              .width(24)
              .aspectRatio(1)
            Text('微信登录')
              .fontColor('#fff')
              .fontWeight(500)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
          }
        }
        .margin({ top: 150 })
        .width(250)
        .height(40)
        .backgroundColor(Color.Green)
        .onClick(() => {
          this.handleWXLogin()
        })
      }
    }
    .width('100%')
    .height('100%')
  }

  async handleWXLogin() {
    let req = new wxopensdk.SendAuthReq
    req.isOption1 = false
    req.nonAutomatic = true
    req.scope = 'snsapi_userinfo'
    req.state = 'none'
    req.transaction = 'test123'

    // 向微信发送登录请求:
    //   context为ohos内置类，app间跳转需依赖该类，开发者可在Component中获取
    //   finished为跳转微信的结果：true表示跳转成功；false表示跳转失败，可能是因为微信未安装
    let finished = await WXApi.sendReq(getContext(this) as common.UIAbilityContext, req)


    Log.info(`微信登录 : ${finished}`)

  }

  handleHWLogin() {
    // 创建登录请求，并设置参数
    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    // 用户是否需要登录授权，该值为true且用户未登录或未授权时，会拉起用户登录或授权页面
    loginRequest.forceLogin = true;
    // 用于防跨站点请求伪造
    loginRequest.state = util.generateRandomUUID();


    // 执行登录请求
    try {
      const controller = new authentication.AuthenticationController(getContext(this));
      controller.executeRequest(loginRequest).then(async (response: authentication.LoginWithHuaweiIDResponse) => {
        const loginWithHuaweiIDResponse = response as authentication.LoginWithHuaweiIDResponse;
        const state = loginWithHuaweiIDResponse.state;
        if (state && loginRequest.state !== state) {
          Log.warn(`华为登录失败. The state is different, response state: ${state}`)
          return;
        }
        Log.info(`华为登录成功, response state: ${state}`)
        const loginWithHuaweiIDCredential = loginWithHuaweiIDResponse.data!;
        const code = loginWithHuaweiIDCredential.authorizationCode;
        // const idToken = loginWithHuaweiIDCredential.idToken;
        // const openID = loginWithHuaweiIDCredential.openID;
        // const unionID = loginWithHuaweiIDCredential.unionID;
        // 开发者处理code, idToken, openID, unionID

        Log.info(`华为登录成功, response code: ${code}`)

        UserAuthStoreInstance.context = getContext()
        UserAuthStoreInstance.setUser("DwEEAOBEsgdtFVYfwr71QjqdPxhshpc4JyBy9nxc/azmfQtEanKPsUmF7hOBTKiVKXuHk3VpbUYwPDiVA1syY3SDiuHEDkQwm+HnkPSMlLe61bXr739OoFK7MTXDeep8Svr84W/5vZ64ipgK13ziVg8TH0437IEwY9ENFc+oYp38rOl/8+1qnODF12WKUyM+PjmyDu78v5MxYeKSS0pHeq16qWIqunaRG3hz4nT37alFQBu7jlx8zCT3DXivcn/jn7shMPvYR14x")

        router.pushUrl(
          {
            url: "pages/Index"
          }
        )
        // const token = await loginApi({
        //   code: code ?? "",
        //   clientId: AppConfig.HW_CLIENT_ID,
        //   clientSecret: AppConfig.HW_CLIENT_ID,
        // })
        //
        // Log.info(`登录成功 自己token : ${token}`)


      }).catch((error: BusinessError) => {
        Log.error(error)
      })
    } catch (error) {
      Log.error(error)
    }

  }
}