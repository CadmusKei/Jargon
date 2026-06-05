
Regex is a pattern language for matching text.

## Anchors — where to match

|symbol|meaning|
|---|---|
|`^`|start of line|
|`$`|end of line|

`^ARCH` matches `ARCH` only at the start of a line, not if it appears mid-line.

---

## Wildcards — what to match

|symbol|meaning|
|---|---|
|`.`|any single character|
|`.*`|zero or more of any character|
|`\s`|any whitespace (space or tab)|
|`\s*`|zero or more whitespace characters|
|`\d`|any digit (0-9)|
|`\d*`|zero or more digits|

---

## Quantifiers

The `*` always means "zero or more of whatever came before it":

|pattern|meaning|
|---|---|
|`\d`|one digit|
|`\d*`|zero or more digits|
|`\s`|one whitespace|
|`\s*`|zero or more whitespace|
|`.`|one character|
|`.*`|zero or more characters|

---

## Example — matching a Makefile line

`^ARCH\s*=.*` breaks down as:

- `^ARCH` — line starts with ARCH
- `\s*` — followed by any amount of whitespace
- `=` — followed by an equals sign
- `.*` — followed by anything

So it matches all of these:

```
ARCH=Jargon
ARCH = Jargon
ARCH         = Linux_PII_CBLAS_gm
```