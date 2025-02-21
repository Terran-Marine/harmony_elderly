import { vpnExtension, VpnExtensionAbility } from '@kit.NetworkKit';
import { Want } from '@kit.AbilityKit';
import { Log } from '@abner/log';

// let context: vpnExtension.VpnExtensionContext;


export default class MyVpnExtAbility extends VpnExtensionAbility {
  private tunIp: string = '10.0.0.5';
  private blockedAppName: string = 'com.gj.elderly';

  onCreate(want: Want) {
    Log.info(`onCreate, want: ${want.abilityName}`)
    let VpnConnection: vpnExtension.VpnConnection = vpnExtension.createVpnConnection(this.context);
    Log.info("vpn createVpnConnection success " + JSON.stringify(VpnConnection));
    this.SetupVpn();
  }

  SetupVpn() {
    class Address {
      address: string;
      family: number;

      constructor(address: string, family: number) {
        this.address = address;
        this.family = family;
      }
    }

    class AddressWithPrefix {
      address: Address;
      prefixLength: number;

      constructor(address: Address, prefixLength: number) {
        this.address = address;
        this.prefixLength = prefixLength;
      }
    }

    class Config {
      addresses: AddressWithPrefix[];
      mtu: number;
      dnsAddresses: string[];
      trustedApplications: string[];
      blockedApplications: string[];

      constructor(
        tunIp: string,
        blockedAppName: string
      ) {
        this.addresses = [
          new AddressWithPrefix(new Address(tunIp, 1), 24)
        ];
        this.mtu = 1400;
        this.dnsAddresses = ["114.114.114.114"];
        this.trustedApplications = [];
        this.blockedApplications = [blockedAppName];
      }
    }

    let config = new Config(this.tunIp, this.blockedAppName);

    try {
      let VpnConnection: vpnExtension.VpnConnection = vpnExtension.createVpnConnection(this.context);
      VpnConnection.create(config).then((data) => {
        Log.info(`[VPN] [create] ${JSON.stringify(data)}`)
      })
    } catch (error) {
      Log.error(`[VPN] [error] ${JSON.stringify(error)}`)
    }
  }
}