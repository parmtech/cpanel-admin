# cPanel UAPI Capability Matrix

**Status:** Initial research; not implementation verification  
**Checked:** 2026-11-02  
**Rule:** Recheck official docs and target-server permissions before coding. An endpoint documented in cPanel's current API specification may still be disabled or unavailable on a particular hosting account.

| Product need | UAPI candidate | Current evidence | MVP decision |
|---|---|---|---|
| Server/account identity | Variables module; confirm exact function and returned fields before implementation | Official UAPI recommends Variables functions for cPanel account/server information | P3 candidate; validate live schema |
| File list | Fileman::list_files | Listed in official UAPI Fileman specification as a sorted file/directory listing | P4 read-only first |
| File metadata | Fileman::get_file_information | Listed in official Fileman specification | P4 candidate |
| Upload | Fileman::upload_files | Official cPanel tutorial documents the UAPI endpoint and multipart upload flow | P4 candidate; implement multipart and test on disposable account |
| Read/download | Fileman::get_file_content is documented for file content; full binary download behavior is not yet validated | UAPI Fileman spec lists get_file_content; mobile large/binary transfer behavior needs endpoint-level verification | Do not promise general download until tested |
| Move/copy/delete/trash | Fileman::move_file, copy_file, delete_file, empty_trash | Listed in official Fileman specification | Later P4; destructive operations require explicit confirmation |
| Domains | DomainInfo::list_domains (verify current UAPI schema) | Official replacement guidance points to this UAPI function for account domains | Post-MVP candidate |
| Disk usage | No UAPI equivalent confirmed for legacy DiskUsage::fetchdiskusage | cPanel's API 2 page explicitly says no equivalent UAPI function exists | Do not build dashboard disk quota using deprecated API 2 in MVP |
| Broad “all cPanel features” | Depends on UAPI module, API role, provider config, and account permissions | cPanel says UAPI accesses/modifies account data; disabled server roles may disable API calls | Capability-aware UI; never promise universal parity |

## Important implementation boundary

- Prefer UAPI. cPanel marks API 2 deprecated and recommends UAPI.
- Do not add API 2 only to fill a dashboard card. If a valuable feature has no UAPI equivalent, document the gap and ask for a product/security review before choosing another approach.
- This inventory records documentation research, not live tests against a real server.
- Never test using the owner's production token as a default. Use mocks or an explicitly configured disposable account.

## Official references

- [UAPI introduction](https://api.docs.cpanel.net/cpanel/introduction)
- [UAPI Fileman specification](https://api.docs.cpanel.net/specifications/cpanel.openapi/fileman/save_file_content)
- [UAPI upload tutorial](https://api.docs.cpanel.net/guides/quickstart-development-guide/tutorial-use-uapis-fileman-upload-files-function-in-custom-code)
- [API 2 DiskUsage function and no-UAPI-equivalent notice](https://api.docs.cpanel.net/cpanel-api-2/cpanel-api-2-modules-diskusage/cpanel-api-2-functions-diskusage-fetchdiskusage)
- [API 2 deprecation and UAPI guidance](https://api.docs.cpanel.net/cpanel-api-2/cpanel-api-2-modules-fileman)
- [cPanel variables guide](https://api.docs.cpanel.net/guides/guide-to-cpanel-variables)
