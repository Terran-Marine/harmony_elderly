import { FormData } from '@ohos/axios'
import { Http } from '../utils'

/**
 * 登录接口
 * */
export const UploadApi = async (data: FormData): Promise<string> => {

  return Http.post<string>("/common/upload", data, {
    headers: {
      "Content-Type": 'multipart/form-data'
    }
  })
}