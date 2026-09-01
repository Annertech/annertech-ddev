#!/usr/bin/env python3
#ddev-generated
#annertech-ddev
"""
Prefix-preserving IPv4 pseudonymization for GDPR-safe log forensics.

Used by: commands/host/ai-prompts (Access Log Forensics action).

Usage:
    mask_ips.py <source_log> <masked_output> <mapping_tsv>

Guarantees:
    - IPs sharing a /8, /16 or /24 in the source share the same masked /8,
      /16 or /24 in the output (subnet structure preserved for botnet
      detection / CIDR recommendations).
    - Masked addresses are never assigned into a non-globally-routable
      range: RFC1918 private (10/8, 172.16/12, 192.168/16), loopback
      (127/8), link-local (169.254/16), CGNAT (100.64/10), class E/
      broadcast (240/4), benchmarking (198.18/15) or the documentation
      TEST-NET blocks (192.0.2/24, 198.51.100/24, 203.0.113/24) - a
      masked IP that looks like internal/reserved traffic confuses the
      LLM's report.
    - The pseudonym permutation is random per run and never leaves the host.
    - Mapping TSV is written with chmod 600.
    - IPv6 addresses are left untouched; a warning is printed if any appear.
"""
import ipaddress
import os
import random
import re
import sys

IPV4_RE = re.compile(r'(?<!/)\b(?:\d{1,3}\.){3}\d{1,3}\b')


def _disallowed(level, masked_so_far, candidate):
    """Would `candidate` at tree `level` put the masked address into a
    non-globally-routable range (RFC1918 private, loopback, link-local,
    CGNAT, or an IANA reserved/documentation block)? None of these ranges
    are narrower than /24, so the classification is always settled by
    octet3 at the latest - octet4 never needs to be checked."""
    if level == 0:
        # 0/8, 10/8, 127/8, 240/4 (class E incl. broadcast 255.255.255.255)
        return candidate == 0 or candidate == 10 or candidate == 127 or candidate >= 240
    if level == 1:
        o1 = masked_so_far[0]
        if o1 == 172:
            return 16 <= candidate <= 31  # 172.16.0.0/12
        if o1 == 169:
            return candidate == 254  # 169.254.0.0/16 link-local
        if o1 == 100:
            return 64 <= candidate <= 127  # 100.64.0.0/10 CGNAT
        if o1 == 192:
            return candidate == 168  # 192.168.0.0/16 (192.0.0.0/16 handled at level 2)
        if o1 == 198:
            return 18 <= candidate <= 19  # 198.18.0.0/15 benchmarking
        return False
    if level == 2:
        o1, o2 = masked_so_far[0], masked_so_far[1]
        if o1 == 192 and o2 == 0:
            return candidate in (0, 2)  # 192.0.0.0/24, 192.0.2.0/24 (TEST-NET-1)
        if o1 == 198 and o2 == 51:
            return candidate == 100  # 198.51.100.0/24 (TEST-NET-2)
        if o1 == 203 and o2 == 0:
            return candidate == 113  # 203.0.113.0/24 (TEST-NET-3)
    return False


def make_pseudonymizer():
    tree = {}
    rng = random.Random()

    def pseudonymize(ip_str):
        try:
            ip = ipaddress.ip_address(ip_str)
        except ValueError:
            return ip_str
        if ip.version != 4:
            return ip_str
        octets = [int(p) for p in ip_str.split('.')]
        out = []
        prefix = ()
        for level, o in enumerate(octets):
            node = tree.setdefault(prefix, {})
            if o not in node:
                used = set(node.values())
                available = [
                    v for v in range(256)
                    if v not in used and not _disallowed(level, out, v)
                ]
                if not available:
                    # Every safe value at this tree level is already
                    # assigned to a sibling (e.g. a log spans >237
                    # distinct top-level source ranges). Reuse a safe
                    # value rather than ever falling back to a
                    # private/reserved one - a rare masked-octet
                    # collision is fine, a private-looking IP is not.
                    available = [
                        v for v in range(256) if not _disallowed(level, out, v)
                    ]
                node[o] = rng.choice(available) if available else o
            out.append(node[o])
            prefix = prefix + (o,)
        return '.'.join(str(x) for x in out)

    return pseudonymize


def main(src, dst, mapping_path):
    pseudonymize = make_pseudonymizer()
    mapping = {}
    ipv6_seen = False

    def repl(m):
        orig = m.group(0)
        try:
            ipaddress.ip_address(orig)
        except ValueError:
            return orig
        if orig not in mapping:
            mapping[orig] = pseudonymize(orig)
        return mapping[orig]

    with open(src, 'r', errors='replace') as f_in, open(dst, 'w') as f_out:
        for line in f_in:
            if not ipv6_seen and ':' in line:
                for tok in re.findall(r'[0-9a-fA-F:]{2,}', line):
                    try:
                        if ipaddress.ip_address(tok).version == 6:
                            ipv6_seen = True
                            break
                    except ValueError:
                        pass
            f_out.write(IPV4_RE.sub(repl, line))

    os.makedirs(os.path.dirname(mapping_path) or '.', exist_ok=True)
    with open(mapping_path, 'w') as f_map:
        f_map.write("masked\treal\n")
        for real, masked in sorted(
            mapping.items(),
            key=lambda x: tuple(int(o) for o in x[0].split('.')),
        ):
            f_map.write(f"{masked}\t{real}\n")
    os.chmod(mapping_path, 0o600)

    print(f"Masked {len(mapping)} unique IPv4 addresses.", file=sys.stderr)
    if ipv6_seen:
        print(
            "WARNING: IPv6 addresses detected in log but NOT masked (not yet supported).",
            file=sys.stderr,
        )


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print("Usage: mask_ips.py <source_log> <masked_output> <mapping_tsv>", file=sys.stderr)
        sys.exit(2)
    main(sys.argv[1], sys.argv[2], sys.argv[3])
