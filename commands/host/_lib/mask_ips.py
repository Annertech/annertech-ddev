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
    - The pseudonym permutation is random per run and never leaves the host.
    - Mapping TSV is written with chmod 600.
    - IPv6 addresses are left untouched; a warning is printed if any appear.
"""
import ipaddress
import os
import random
import re
import sys

IPV4_RE = re.compile(r'\b(?:\d{1,3}\.){3}\d{1,3}\b')


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
        for o in octets:
            node = tree.setdefault(prefix, {})
            if o not in node:
                used = set(node.values())
                available = [v for v in range(256) if v not in used]
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
