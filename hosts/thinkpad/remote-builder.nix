{
  # REMOTE BUILDER — offload thinkpad's 2-core builds to osaka over Tailscale.
  # thinkpad's nix-daemon (root) reaches osaka with the primary user's key,
  # which is already authorised there as root. `builders-use-substitutes` is set
  # globally in nix.mod.nix, so osaka pulls sources straight from the cache.
  nix.distributedBuilds = true;

  nix.buildMachines = [
    {
      hostName = "osaka";
      sshUser = "root";
      sshKey = "/home/cfactoryai/.ssh/id_ed25519";
      systems = [ "x86_64-linux" ];
      maxJobs = 2;
      speedFactor = 2;
      supportedFeatures = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
      protocol = "ssh-ng";
    }
  ];

  # Trust osaka's host key so the daemon can connect non-interactively.
  programs.ssh.knownHosts.osaka = {
    hostNames = [
      "osaka"
      "100.89.134.10"
    ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBMrRmnmQtXtBfAnw/NGBy0artvsiS7316kRFwgWBl5E root@osaka";
  };
}
