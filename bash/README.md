Backup of miscellaneous dotfiles I've accumulated for use in bash over the years.
I'll be cleaning these up, removing unused items, and restructuring them to work properly with the automation.

Structure of `.bash_secrets`:

```sh
export NPM_TOKEN=<token>
```

Starship prompt custom modules

```toml
[custom.git_email]
command = "git config user.email"
format = "by [$output]($style) "
shell = ["bash", "--noprofile", "--norc"]
style = "bright-yellow bold"
when = "git rev-parse --git-dir 2> /dev/null"

[custom.kubernetes]
command = "kubectl config current-context"
shell = ["bash", "--noprofile", "--norc"]
style = "cyan bold"
symbol = "☸ "
when = "env | grep -c KUBE"

[custom.sudo]
command = "echo -n '!'"
description = "valid sudo timestamp marker"
format = "[$symbol$output]($style) "
shell = ["bash", "--noprofile", "--norc"]
style = "bold fg:bright-red"
when = "sudo -vn &>/dev/null"
```
