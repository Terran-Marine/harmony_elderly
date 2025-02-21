import { ResManager } from '../../../../Index';
import { camera, cameraPicker as picker } from '@kit.CameraKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from '@abner/log';
import { photoAccessHelper } from '@kit.MediaLibraryKit';


@CustomDialog
export struct EcDialogUpload {
  // 控制器
  controller: CustomDialogController
  callback: (url: string) => void = () => {
  }

  //打开相机
  async takeCamera() {
    try {
      let pickerProfile: picker.PickerProfile = {
        cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK
      };
      let pickerResult: picker.PickerResult = await picker.pick(getContext(),
        [picker.PickerMediaType.PHOTO], pickerProfile);
      Log.info("the pick pickerResult is:" + JSON.stringify(pickerResult));
      this.callback(pickerResult.resultUri)

      this.controller.close()

    } catch (error) {
      let err = error as BusinessError;
      Log.error(`the pick call failed. error code: ${err.code}`);
    }
  }

  //打开相册
  takePhoto() {
    try {
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
        Log.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' +
        JSON.stringify(photoSelectResult));

        if (photoSelectResult.photoUris?.length > 0) {
          this.callback(photoSelectResult.photoUris[0])
        }
        this.controller.close()

      }).catch((err: BusinessError) => {
        Log.info(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      Log.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  }

  build() {
    Column() {
      // 选项列表
      List() {
        ListItem() {
          Text('拍照')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => {
          this.takeCamera()
        })

        ListItem() {
          Text('从相册选择')
            .fontColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
            .onClick(() => {
              this.takePhoto()
            })
        }

        ListItem() {
          Text('取消')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_MODULE_TITLE_FS)
            .fontWeight(500)
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding(15)
        }
        .onClick(() => {
          this.controller.close()
        })
      }
      .width('100%')
      .height('auto')
      .divider({ strokeWidth: 0.5, color: ResManager.EC_MID_LINE })
      .padding(ResManager.EC_CONTENT_SPACE)
      .backgroundColor('#fff')
      .borderRadius(ResManager.EC_NORMAL_RD)

    }
  }
}
