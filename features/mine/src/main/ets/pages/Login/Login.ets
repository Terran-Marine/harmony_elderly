import { ResManager } from '@hm/basic/Index';

import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from '@abner/log';


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
      }
    }
    .width('100%')
    .height('100%')
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
      controller.executeRequest(loginRequest).then((response: authentication.LoginWithHuaweiIDResponse) => {
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

      }).catch((error: BusinessError) => {
        Log.error(error)
      })
    } catch (error) {
      Log.error(error)
    }

  }
}