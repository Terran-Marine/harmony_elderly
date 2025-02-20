import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { promptAction, router } from '@kit.ArkUI'
import { Log } from '@abner/log'
import { RouterConfig, UserAuthStoreInstance } from '../../../../Index'


// 创建axios实例
const instance = axios.create({
  baseURL: "https://zhyl-harmony.itheima.net",
  timeout: 3000
})

// 请求拦截器
instance.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  Log.info(`请求参数${JSON.stringify(config)}`)
  UserAuthStoreInstance.context = getContext()
  config.headers.Authorization = await UserAuthStoreInstance.getUser() ?? ""

  return config
}, (error: AxiosError) => {
  Log.error(`接口请求异常${error.message}`)
  return Promise.reject(error)
})

// 相应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  Log.info(`响应结果${JSON.stringify(response, null, 2)}`)
  switch (response.data.code) {
    case 200:

      return response.data

    case 401:
      promptAction.showToast({ message: '登录失效' })
      Log.error(JSON.stringify(response.data.msg))
      //todo token过期处理

      UserAuthStoreInstance.delUser()
      router.replaceUrl({ url: RouterConfig.LOGIN_URL })

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

  static post<T>(url: string, params?: object, config?: AxiosRequestConfig) {
    return instance.post<null, T>(url, params, config)
  }

  static put<T>(url: string, params?: object, config?: AxiosRequestConfig) {
    return instance.put<null, T>(url, params, config)
  }

  static delete<T>(url: string, config?: AxiosRequestConfig) {
    return instance.delete<null, T>(url, config)
  }
}