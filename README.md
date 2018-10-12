updock
======

What's updock? Docker container upgrades made simple.

## Overview

`updock` handles the heavy lifting of proper docker container upgrades for you,
allowing you to focus on just the parts that matter.

Features:
- Pulling the latest image from the docker trusted registry
- Putting the app in maintenance mode
- Backing up the app
- Rolling back the upgrade in case of failures
- Email notifications
- App templates for no-configuration upgrades of supported apps

## Usage

```shell
updock [--email-sender-name name]
	[--email-sender-address address] [--email-recipients recipients]
	[--verbose] [--timeout seconds] template container
```

## Options

Option | Default | Description
--- | --- | ---
--email-sender-name | | From name for notifications
--email-sender-address | | From address for notifications
--email-recipients | | Email recipients(s) for notifications
--verbose | true | Show verbose output
--timeout| 600 | Timeout for waiting for the app upgrade to complete

