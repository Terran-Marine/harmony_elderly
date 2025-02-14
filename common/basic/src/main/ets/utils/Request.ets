import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { promptAction } from '@kit.ArkUI'
import { Log } from '@abner/log'


// 创建axios实例
const instance = axios.create({
  baseURL: "https://zhyl-harmony.itheima.net",
  timeout: 3000
})

// 请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  Log.info(`请求参数${JSON.stringify(config)}`)
  return config
}, (error: AxiosError) => {
  Log.error(`接口请求异常${error.message}`)
  return Promise.reject(error)
})

// 相应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {

  switch (response.data.code) {
    case 200:
      Log.info(`响应结果${response.data}`)
      return response.data

    case 401:
      promptAction.showToast({ message: '登录失效' })
      Log.error(JSON.stringify(response.data.msg))
      //todo token过期处理
      break

    default:
      AlertDialog.show({
        message: response.data.msg
      })
      break
  }
  return response
}, (error: AxiosError) => {
  Log.error(`接口相应异常${error.message}`)
  switch (JSON.parse(JSON.stringify(error)).status) {
    case 401:
      promptAction.showToast({ message: '登录超时' })
      //todo token过期处理
      break

    default:
      AlertDialog.show({
        message: error.message
      })
      break
  }


  return Promise.reject(error)
})

export class Http {
  static get<T>(url: string, params?: object) {
    return instance.get<null, T>(url, { params })
  }

  static post<T>(url: string, params?: object) {
    return instance.post<null, T>(url, params)
  }

  static put<T>(url: string, params?: object) {
    return instance.put<null, T>(url, params)
  }

  static delete<T>(url: string, params?: object) {
    return instance.delete<null, T>(url, params)
  }
}