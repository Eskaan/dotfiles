{ lib, pkgs, settings, ... }:

{
  imports = [
    ../../system/hardware-configuration.nix
    ../base.nix

    ../../system/bin/niot.nix

    ../../system/shell/sh.nix
    ../../system/shell/cli.nix
    ../../system/app/hardware-monitoring.nix
    
    ../../system/app/sshd.nix
    ../../system/app/firewall.nix
    ../../system/app/monitoring.nix

    ../../system/app/nginx.nix
    ../../system/app/minecraft.nix
  ];

  users.mutableUsers = false;
  users.users.eskaan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "minecraft" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1T14GbpTsDZU2RJR0ES1oy6xI1xnUZvQKoCeLt8I1mEgVJyTxvUeMrqYI3OGKWFfh/M7SK8Z7gNJ4YLL1U0qrOPeFk1MU/p9tgZaR4x09D3dwxrpcu+RLxurWnSOACU32aY/YK0Ao6pHeIfc1vOLHg+mz8mA695cfvbrIdTewo4SoYOOJBTan416Fy9BapqEe5Zjk7gva137DQ1g6M1nyVoJpcVAHk1/luwmvEfseamOVv5utNMcq2edms0cqMhe2J8KGhHOwxRYyYmrX/t1ApNHaPti0yMw3cO37BR47Hk+GCiMlKF0kSjptaLDaogvb8G9g+w3cp+a1FLxYTBma+wyZ759bS0V4tKCEkJbR84rBxVy1wUukidqrFCWzhKj6oFSuGtSjnqNa0JDyEuQPv90L4NPKYgCRsudIyf7QuNAc2m6bTfq5K84b8p86w8Nq6UbdY+wyxgSnKszro9id6JODBF3OkDJqQ3pkhXChz82rxtXAN1rcbg9MU4exPHA/x0Perpq9lPQLNXfZPzfCC1s7DPf7tO/twtXnzGBvmyUVan10IYDfNwstXkGzMZOcEVnm2xK88ZbyuceTsI2many/cH36m6mhF4OEQoYB8FL09K7XCrGyO5R01HdVRSIswmFy5DAQRhhXmEABa71z1CJI+jmvyUuZ5ULN8zSuQQ== eskaan"
    ];
    hashedPassword = "$y$j9T$5E6UVJk4GH6KeajVqt2QI1$QWRZP7RYlOYAm5p6rVagPbsbcXhSKcfXx5ltni0.Eu.";
  };

  environment.systemPackages = with pkgs; [
    # Base / essentials
    neovim
    wget
    curl
    git
  ];


  # First installed version for legacy reasons (do not change).
  system.stateVersion = "23.11";
}

