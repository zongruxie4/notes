# opencode

When you add a provider’s API keys with the `/connect` command, they are stored in _~/.local/share/opencode/auth.json_.

Global configuration is in

- _~/.config/opencode/opencode.json_ on Unix
- _$env:USERPROFILE/.config/opencode/opencode.json_ on Windows

Create this manually, see this example for [configuring OpenAI models when using ZDR](https://github.com/sst/opencode/issues/2966#issuecomment-3368453578):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "openai": {
      "models": {
        "gpt-5.1-codex-max": {
          "options": {
            "store": false,
            "reasoningEffort": "high",
            "textVerbosity": "medium",
            "reasoningSummary": "auto",
            "include": ["reasoning.encrypted_content"]
          },
          "gpt-5.2-codex": {
            "options": {
              "store": false,
              "reasoningEffort": "high",
              "textVerbosity": "medium",
              "reasoningSummary": "auto",
              "include": ["reasoning.encrypted_content"]
            }
          }
        }
      }
    }
  }
}
```
