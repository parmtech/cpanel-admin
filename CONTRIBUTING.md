# Contributing

Thanks for helping build cPanel Admin (Unofficial).

## Before starting
1. Read README.md, docs/PRODUCT_SPEC.md, docs/ROADMAP.md, docs/ARCHITECTURE.md, SECURITY.md, and HANDOFF.md.
2. Check current issues and handoff before choosing work.
3. State the issue/milestone you are continuing; avoid simultaneous edits to the same files.
4. Never request or include real hosting credentials in issues or pull requests.

## Project rules
- Follow product scope and security requirements.
- Use official cPanel UAPI documentation; avoid deprecated cPanel API 2 unless an explicit documented compatibility exception is accepted.
- Keep UI separate from networking and secrets.
- Add tests for behavior and security-sensitive parsing.
- Document manual test setup without publishing tokens or customer data.
- Update roadmap and HANDOFF.md in the same pull request when status changes.
- Keep pull requests focused; include impact and validation notes.

## Pull request checklist
- [ ] Linked issue/milestone and acceptance criteria.
- [ ] Relevant tests/static analysis run; exact results listed.
- [ ] No secrets or server/customer data.
- [ ] Errors are useful and redacted.
- [ ] Accessibility and loading/empty/error states considered.
- [ ] Documentation and handoff updated.
