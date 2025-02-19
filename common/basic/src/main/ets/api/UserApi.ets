import { LoginParamsModel, UserInfoModel } from '../model/User';
import { Http } from '../utils/Request';


/**
 * 登录接口
 * */
export const loginApi = (data: LoginParamsModel): Promise<string> => {
  return Http.post("/employee/login", data)
}


/**
 * 获取用户信息
 * */
export const getUserInfoApi = (): Promise<UserInfoModel> => {
  return Http.get<UserInfoModel>("/employee/user")
}