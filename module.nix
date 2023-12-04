self: { config, lib, pkgs, ... }:
let
  cfg = config.services.scribe;
in
{
  options.services.scribe = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable or disable the Scribe service");

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages."${pkgs.system}".default;
      description = lib.mdDoc "Overridable attribute of the scribe package to use.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "scribe";
      description = lib.mdDoc "User to run the Scribe service as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "scribe";
      description = lib.mdDoc "Group to run the Scribe service as.";
    };

    appDomain = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc ''
        The domain that Scribe is being run on. This will appear on the Scribe homepage.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      description = lib.mdDoc "Port for the Scribe service to use.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc ''
        The path to a file containing environment varible to be set in Scribes environment.
        This should be user to set SECRET_KEY_BASE, GITHUB_USERNAME, and GITHUB_PERSONAL_ACCESS_TOKEN. 
        Descriptions of these settings can be found
        [in the official docs](https://sr.ht/~edwardloveall/Scribe/#configuration).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.scribe = {
      description = "Scribe";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        LUCKY_ENV = "production";
        APP_DOMAIN = cfg.appDomain;
        PORT = (toString cfg.port);
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/scribe";
        EnvironmentFile = cfg.environmentFile;
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0007";
        ProtectSystem = "strict";
        ProtectClock = true;
        ProtectKernelLogs = true;
        SystemCallArchitectures = "native";
        ProtectHome = true;
        ProtectProc = "noaccess";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = [
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_ADMIN"
          "~CAP_SETGID"
          "~CAP_SETUID"
          "~CAP_SETPCAP"
          "~CAP_SYS_TIME"
          "~CAP_KILL"
          "~CAP_SYS_PACCT"
          "~CAP_SYS_TTY_CONFIG "
          "~CAP_SYS_CHROOT"
          "~CAP_SYS_BOOT"
          "~CAP_NET_ADMIN"
        ];
      };
    };
    users.users = lib.optionalAttrs (cfg.user == "scribe") {
      "scribe" = {
        group = "scribe";
        isSystemUser = true;
      };
    };
    users.groups = lib.optionalAttrs (cfg.group == "scribe") {
      "scribe" = { };
    };
  };
}
