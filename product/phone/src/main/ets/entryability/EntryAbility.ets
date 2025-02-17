import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import "../utils";
import { Log } from '@abner/log';
import { Http, RouterConfig, UserAuthStoreInstance } from '@hm/basic';

interface ParamsType {
  pageNum: number,
  pageSize: number
}


export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Log.info("EntryAbility onCreate");

    const params: ParamsType = {
      pageNum: 1, pageSize: 10
    }

    Http.get<null>("/employee/nursing-task/pageQuery", params)
      .then((response: null) => {
        AlertDialog.show({
          message: JSON.stringify(response, null, 2)
        })
      })

  }

  onDestroy(): void {
    Log.info("EntryAbility onDestroy");
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    Log.info("EntryAbility onWindowStageCreate");

    UserAuthStoreInstance.context = this.context

    const adWin = await windowStage.createSubWindow("ad_window")
    await adWin.showWindow()
    adWin.setUIContent(RouterConfig.SPLASH_URL)

    const token = await UserAuthStoreInstance.getUser()

    Log.info(`token : ${token}`)

    if (token) {
      //加载广告页


      windowStage.loadContent('pages/Index', (err, data) => {
        if (err.code) {
          Log.error(`EntryAbility Failed to load the content. ${JSON.stringify(err)}`)
          return;
        }
        Log.info(`EntryAbility Succeeded in loading the content. ${JSON.stringify(err)}`)
      });
    } else {
      windowStage.loadContent(RouterConfig.LOGIN_URL)
    }


  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    Log.info("EntryAbility onWindowStageDestroy");
  }

  onForeground(): void {
    // Ability has brought to foreground
    Log.info("EntryAbility onForeground");
  }

  onBackground(): void {
    // Ability has back to background
    Log.info("EntryAbility onBackground");
  }
}