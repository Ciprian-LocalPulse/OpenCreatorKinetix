# Security Policy

## Supported Versions

OpenCreatorKinetix is currently in early public research development. Security fixes should target the latest version on the default branch.

| Version | Supported |
| ------- | --------- |
| 0.1.x   | Yes       |

## Reporting a Vulnerability

Please report security issues privately before opening a public issue.

Recommended report contents:

- affected files or workflows
- reproduction steps
- expected impact
- suggested mitigation, if known

## Security Scope

The current project is a local Julia package plus Scheme-shaped protocol files. Important security areas include:

- unsafe protocol parsing behavior
- unexpected file access
- malicious protocol examples
- dependency or CI supply-chain changes
- GitHub Actions workflow changes

## Design Principle

The protocol layer parses a constrained DSL and does not evaluate arbitrary Scheme code. This is intentional. Future changes should preserve deterministic and inspectable loading behavior unless a security review justifies otherwise.
