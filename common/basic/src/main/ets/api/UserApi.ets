import { LoginParamsModel } from '../model/User';
import { Http } from '../utils/Request';


/**
 * 登录接口
 * */
export const loginApi = (data: LoginParamsModel): Promise<string> => {
  return Http.post("/employee/login", data)
}