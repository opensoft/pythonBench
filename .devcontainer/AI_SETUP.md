# AI Coding Assistant Setup for DevContainers

This guide explains how to configure your devcontainer to automatically authenticate with AI coding assistants (OpenAI Codex, Anthropic Claude Code, and Google Gemini).

## Overview

When working in a devcontainer, AI coding assistant extensions need access to your authentication credentials. This is accomplished by mounting your local authentication directories into the container.

## Supported AI Assistants

- **OpenAI Codex** - VS Code extension for ChatGPT/GPT-4 code assistance
- **Anthropic Claude Code** - Claude AI integration for VS Code
- **Google Gemini** - Google's Gemini AI coding assistant

## Quick Setup

### 1. Check if You Have Authentication Files

First, verify that you have authenticated with the AI tools on your host machine:

```bash
# Check for Codex authentication
ls ~/.codex/

# Check for Claude authentication
ls ~/.claude/

# Check for Gemini authentication
ls ~/.gemini/
```

If these directories don't exist, you need to authenticate on your host machine first (see "Initial Authentication" section below).

### 2. Create Override File

Copy the example override file to create your personal configuration:

```bash
cd .devcontainer
cp docker-compose.override.example.yml docker-compose.override.yml
```

**Important:** The `docker-compose.override.yml` file is automatically gitignored and will not be committed to the repository.

### 3. Edit Override File

Open `docker-compose.override.yml` and uncomment the volume mounts for the AI tools you use:

```yaml
services:
  app:  # Replace 'app' with your actual service name
    volumes:
      # Uncomment the lines you need:
      - ~/.codex:/home/${USER:-vscode}/.codex:cached
      - ~/.claude:/home/${USER:-vscode}/.claude:cached
      - ~/.gemini:/home/${USER:-vscode}/.gemini:cached
```

**Note:** Make sure to replace `app` with your actual service name from `docker-compose.yml` (e.g., `gateway`, `web`, `dev`, etc.).

### 4. Rebuild Devcontainer

After editing the override file:

1. In VS Code, press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Select: **Dev Containers: Rebuild Container**
3. Wait for the container to rebuild

### 5. Verify Setup

Once the container is running:

1. Open a terminal in VS Code
2. Check that the directories are mounted:

```bash
ls ~/.codex/
ls ~/.claude/
ls ~/.gemini/
```

3. Try using an AI coding assistant extension - it should now work without requiring login

## Initial Authentication

If you haven't authenticated with the AI tools on your host machine yet, follow these steps:

### OpenAI Codex Setup

1. Install the OpenAI Codex CLI on your host:
   ```bash
   npm install -g @openai/codex
   ```

2. Authenticate:
   ```bash
   codex login
   ```

3. Follow the browser authentication flow

### Claude Code Setup

1. Install Claude Code CLI on your host:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. Authenticate:
   ```bash
   claude login
   ```

3. Enter your API key when prompted

### Gemini Setup

1. Install Gemini CLI on your host:
   ```bash
   # Installation method varies - check Google's documentation
   ```

2. Authenticate:
   ```bash
   gemini auth login
   ```

3. Follow the authentication flow

## Troubleshooting

### AI Assistant Still Asks for Login

**Problem:** The AI extension is still prompting for authentication inside the container.

**Solutions:**

1. **Check service name:** Ensure you replaced `app` with your actual service name in the override file
   ```bash
   # Check your service name in docker-compose.yml
   grep "services:" -A 2 .devcontainer/docker-compose.yml
   ```

2. **Verify mounts:** Inside the container, check if directories are mounted:
   ```bash
   ls -la ~/.codex ~/.claude ~/.gemini
   ```

3. **Check permissions:** Ensure directories are readable:
   ```bash
   # On host machine
   ls -la ~/.codex ~/.claude ~/.gemini
   ```

4. **Rebuild container:** Sometimes changes require a full rebuild:
   ```
   Ctrl+Shift+P → Dev Containers: Rebuild Container Without Cache
   ```

### Permission Denied Errors

**Problem:** Container can't read the authentication files.

**Solution:**

The files should be readable. If not, fix permissions on your host:

```bash
chmod -R u+r ~/.codex ~/.claude ~/.gemini
```

### Wrong User Path

**Problem:** Mounts are going to `/root/` instead of `/home/youruser/`

**Solution:**

Check that your devcontainer is running as the correct user:

```bash
# Inside container
echo $USER
id
```

If running as root, update your devcontainer configuration to use the correct user. Check `devcontainer.json`:

```json
{
  "remoteUser": "${localEnv:USER:vscode}"
}
```

### Container Name Mismatch

**Problem:** Override file references wrong service name.

**Solution:**

Find your actual service name:

```bash
# Look at docker-compose.yml
cat .devcontainer/docker-compose.yml | grep "services:" -A 5
```

Common service names: `app`, `web`, `dev`, `service`, `gateway`, `backend`

Update `docker-compose.override.yml` to use the correct service name.

## Security Considerations

### What Gets Mounted

When you mount these directories, you're providing the container with:

- **API Keys:** Authentication tokens for AI services
- **Session Data:** Cached responses and user preferences
- **Configuration:** Settings for the AI tools

### Security Best Practices

1. **Never commit override files:** The `.gitignore` should include:
   ```
   docker-compose.override.yml
   ```

2. **Read-only mounts (optional):** If you want extra security, use `:ro` flag:
   ```yaml
   - ~/.codex:/home/${USER}/.codex:ro
   ```

3. **Revoke access:** If compromised, revoke API keys from the provider's dashboard

4. **Separate development keys:** Consider using separate API keys for devcontainers vs production

## Advanced Configuration

### Multiple Projects, Same Overrides

If you want the same AI setup across all projects, you can:

1. Create a template override file
2. Copy it to each project's `.devcontainer/` folder
3. Adjust the service name as needed

### Custom Mount Locations

If your AI tools store credentials elsewhere:

```yaml
services:
  app:
    volumes:
      - ~/custom/path/to/codex:/home/${USER}/.codex:cached
```

### Team Best Practices

For teams:

1. **Commit the example:** Always commit `docker-compose.override.example.yml`
2. **Document in README:** Add a note about AI setup to your project README
3. **Add to gitignore:** Ensure override files are ignored:
   ```
   .devcontainer/docker-compose.override.yml
   ```

4. **Share setup docs:** Keep this `AI_SETUP.md` updated and committed

## FAQ

**Q: Will this work for all AI coding assistants?**  
A: This pattern works for any AI tool that stores credentials in your home directory.

**Q: Do I need all three (Codex, Claude, Gemini)?**  
A: No, only uncomment the ones you actually use.

**Q: Can I add other personal mounts?**  
A: Yes! The override file is for your personal customizations. Add whatever you need.

**Q: What if I don't want to use override files?**  
A: You can mount these in `devcontainer.json` using the `mounts` property, but the override pattern is cleaner for team projects.

**Q: Does this affect performance?**  
A: No, the `:cached` flag ensures good performance. The mounted directories are small.

## Support

If you encounter issues:

1. Check this documentation
2. Verify your setup using the troubleshooting section
3. Check the AI assistant's official documentation
4. Ask your team members who have it working

## File Checklist

After setup, you should have:

- ✅ `.devcontainer/docker-compose.yml` - Base configuration (committed)
- ✅ `.devcontainer/docker-compose.override.example.yml` - Template (committed)
- ✅ `.devcontainer/docker-compose.override.yml` - Your config (gitignored)
- ✅ `.devcontainer/AI_SETUP.md` - This documentation (committed)
- ✅ `.gitignore` - Contains `docker-compose.override.yml`
