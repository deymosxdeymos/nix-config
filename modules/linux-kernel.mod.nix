{
  flake.nixosModules.linux-kernel =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Credits (via ncc):
      # - https://github.com/NotAShelf/nyx/blob/main/modules/core/common/system/security/kernel.nix
      boot.kernel.sysctl = {
        # The Magic SysRq key allows low-level commands from the console; disable it.
        "kernel.sysrq" = 0;

        # Hide kernel pointers even for processes with CAP_SYSLOG.
        "kernel.kptr_restrict" = 2;

        # Disable bpf() JIT (to eliminate spray attacks).
        "net.core.bpf_jit_enable" = false;

        # Disable ftrace debugging.
        "kernel.ftrace_enabled" = false;

        # Avoid kernel memory address exposures via dmesg.
        "kernel.dmesg_restrict" = 1;

        # Prevent unintentional fifo writes.
        "fs.protected_fifos" = 2;

        # Prevent unintended writes to already-created files.
        "fs.protected_regular" = 2;

        # Disable SUID binary core dumps.
        "fs.suid_dumpable" = 0;

        # Disallow profiling at all levels without CAP_SYS_ADMIN.
        "kernel.perf_event_paranoid" = 3;

        # Require CAP_BPF to use bpf.
        "kernel.unprivileged_bpf_disabled" = 1;
      };

      # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
      boot.kernelParams = [
        # Make stack-based attacks on the kernel harder.
        "randomize_kstack_offset=on"

        # vsyscalls have been legacy since 2016; break really old binaries.
        "vsyscall=none"

        # Reduce most of the exposure of a heap attack to a single cache.
        "slab_nomerge"

        # Enable buddy allocator free poisoning.
        "page_poison=1"

        # Reduce predictability of page allocations.
        "page_alloc.shuffle=1"

        # Disable sysrq keys.
        "sysrq_always_enabled=0"

        # Ignore atime updates except alongside ctime/mtime updates.
        "rootflags=noatime"

        # Prevent the kernel from blanking plymouth out of the fb.
        "fbcon=nodefer"

        # NOTE: the following two are the strongest hardening options but are the
        # ones most likely to break things on this laptop, so they're opt-in:
        #   - `module.sig_enforce=1` refuses to load unsigned modules, which
        #     breaks DKMS / out-of-tree drivers (VirtualBox, some Wi-Fi, etc.).
        #   - `lockdown=confidentiality` blocks a lot of kernel introspection and
        #     can interfere with fwupd firmware flashing and suspend on some HW.
        # Uncomment once you've confirmed nothing you rely on needs them.
        # "module.sig_enforce=1"
        # "lockdown=confidentiality"

        # Linux security modules. selinux/tomoyo are listed but inactive without
        # a loaded policy; apparmor is the practical one on NixOS.
        "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
      ];

      boot.blacklistedKernelModules = [
        # Obscure network protocols.
        "af_802154" # IEEE 802.15.4
        "appletalk" # Appletalk
        "atm" # ATM
        "ax25" # Amateur X.25
        "can" # Controller Area Network
        "dccp" # Datagram Congestion Control Protocol
        "decnet" # DECnet
        "econet" # Econet
        "ipx" # Internetwork Packet Exchange
        "n-hdlc" # High-level Data Link Control
        "netrom" # NetRom
        "p8022" # IEEE 802.3
        "p8023" # Novell raw IEEE 802.3
        "psnap" # Subnetwork Access Protocol
        "rds" # Reliable Datagram Sockets
        "rose" # ROSE
        "sctp" # Stream Control Transmission Protocol
        "tipc" # Transparent Inter-Process Communication
        "x25" # X.25

        # Old or rare or insufficiently audited filesystems.
        "adfs"
        "affs"
        "befs"
        "bfs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "f2fs"
        "freevxfs"
        "gfs2"
        "hfs"
        "hfsplus"
        "hpfs"
        "jffs2"
        "jfs"
        "minix"
        "nilfs2"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
        "udf"
        "vivid" # Virtual Video Test Driver.

        # NOTE: these are blacklisted by ncc but commonly needed on a laptop, so
        # they're left enabled here. Uncomment any you're sure you don't use:
        #   - "cifs" / "ksmbd"  -> mounting SMB / Windows shares
        #   - "nfs" / "nfsv3" / "nfsv4" -> mounting NFS shares
        #   - "firewire-core" / "thunderbolt" -> TB docks, USB4, eGPU, some
        #     external displays. Blacklisting these also mitigates DMA attacks.
      ];
    };
}
