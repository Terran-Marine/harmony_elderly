import { preferences } from '@kit.ArkData'

class UserAuthStore {
  context?: Context
  USER_STORE = "USER_STORE"

  //获取仓库
  getStore() {
    return preferences.getPreferencesSync(this.context || getContext(), {
      name: "userStore"
    })
  }

  //设置
  async getUser(token: string) {
    const store = this.getStore()
    await store.put(this.USER_STORE, token)
    await store.flush()
  }

  //获取
  async setUser() {
    const store = this.getStore()
    return await store.get(this.USER_STORE, "")
  }

  //删除
  delUser() {
    const store = this.getStore()
    store.deleteSync(this.USER_STORE)
  }
}

export const UserAuthStoreInstance = new UserAuthStore()