{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/digital-ocean-config.nix"
  ];

  # do not use DHCP, as DigitalOcean provisions IPs using cloud-init
  networking.useDHCP = lib.mkForce false;

  # Disables all modules that do not work with NixOS
  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      datasource_list = [
        "ConfigDrive"
        "Digitalocean"
      ];
      datasource.ConfigDrive = { };
      datasource.Digitalocean = { };
      # Based on https://github.com/canonical/cloud-init/blob/main/config/cloud.cfg.tmpl
      cloud_init_modules = [
        "seed_random"
        "bootcmd"
        "write_files"
        "growpart"
        "resizefs"
        "set_hostname"
        "update_hostname"
        # Not support on NixOS
        #"update_etc_hosts"
        # throws error
        #"users-groups"
        # tries to edit /etc/ssh/sshd_config
        #"ssh"
        "set_password"
      ];
      cloud_config_modules = [
        "ssh-import-id"
        "keyboard"
        # doesn't work with nixos
        #"locale"
        "runcmd"
        "disable_ec2_metadata"
      ];
      ## The modules that run in the 'final' stage
      cloud_final_modules = [
        "write_files_deferred"
        "puppet"
        "chef"
        "ansible"
        "mcollective"
        "salt_minion"
        "reset_rmc"
        # install dotty agent fails
        #"scripts_vendor"
        "scripts_per_once"
        "scripts_per_boot"
        # /var/lib/cloud/scripts/per-instance/machine_id.sh has broken shebang
        #"scripts_per_instance"
        "scripts_user"
        "ssh_authkey_fingerprints"
        "keys_to_console"
        "install_hotplug"
        "phone_home"
        "final_message"
      ];
    };
  };
}
