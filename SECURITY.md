# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of the Chaukas specification and generated libraries seriously. If you discover a security vulnerability, please follow these steps:

### Please Do Not

- **Do not** open a public GitHub issue for security vulnerabilities
- **Do not** disclose the vulnerability publicly until it has been addressed

### Reporting Process

1. **Email**: Send details to **2153483+ranesidd@users.noreply.github.com**
2. **Subject Line**: Use "[SECURITY] " prefix in your email subject
3. **Include**:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Potential impact
   - Affected versions
   - Any suggested fixes (optional)

### What to Expect

- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within 48 hours
- **Assessment**: We will assess the vulnerability and determine its impact and severity
- **Updates**: We will keep you informed of our progress as we work on a fix
- **Resolution**: Once fixed, we will:
  - Release a patch version
  - Publish a security advisory
  - Credit you for the discovery (unless you prefer to remain anonymous)

### Security Considerations

This repository contains:
- **Protocol Buffer specifications**: Vulnerabilities in schema design could affect all implementations
- **Generated code**: Issues in code generation could introduce vulnerabilities in downstream projects
- **Python packages**: Dependency vulnerabilities or packaging issues
- **Go modules**: Dependency vulnerabilities or module issues

Common security concerns to report:
- Schema design flaws that could lead to data validation issues
- Code generation bugs that produce unsafe code
- Dependency vulnerabilities in Python/Go packages
- Build/packaging issues that could lead to supply chain attacks
- Documentation that encourages insecure practices

## Security Best Practices

When using the Chaukas specification:

1. **Validate Input**: Always validate event data before ingesting
2. **Use TLS**: Always use TLS/SSL for gRPC connections in production
3. **Authentication**: Implement proper authentication for your gRPC services
4. **Rate Limiting**: Implement rate limiting for event ingestion endpoints
5. **Access Control**: Restrict access to sensitive event data based on tenant/project IDs
6. **Keep Updated**: Regularly update to the latest version to receive security patches
7. **Review Dependencies**: Regularly audit your dependencies for known vulnerabilities

## Disclosure Policy

We follow responsible disclosure principles:
- Security issues will be patched as quickly as possible
- A security advisory will be published after a fix is released
- We will coordinate with security researchers on disclosure timing
- Credit will be given to reporters who discover vulnerabilities

## Questions?

If you have questions about this security policy, please contact:
2153483+ranesidd@users.noreply.github.com
