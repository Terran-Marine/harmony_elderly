export interface LoginParamsModel {
  /**
   * 华为应用id
   */
  clientId: null | string;

  /**
   * 华为应用秘钥
   */
  clientSecret: null | string;

  /**
   * 华为账号授权码
   */
  code: string;
}