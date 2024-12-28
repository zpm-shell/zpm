<h1 align="center">zpm</h1>

<p align="center">
    <a rel="Test" href="https://github.com/wuchuheng/zpm/actions/workflows/test.yaml">
        <img alt="Tests" src="https://github.com/wuchuheng/zpm/actions/workflows/test.yaml/badge.svg" />
    </a>
</p>

`zpm` is a powerful module manager for zsh, designed to streamline and simplify the management of Zsh modules. It provides a user-friendly interface to install, update, and manage your zsh environment modules, enhancing your command-line productivity and experience.


## Features

- Easy installation and removal of Zsh modules
- Automatic updates for installed modules
- Customizable settings for module management
- Compatibility with a wide range of Zsh frameworks and plugins

## Install

```sh
curl -fsSL -o install.sh https://raw.githubusercontent.com/zpm-shell/zpm/0.1.7/install.sh && source install.sh
```

## Usage
After installation, you can manage your Zsh modules using simple commands:
```sh
# To install a new module
zpm install <domain>/username/repository # e.g. zpm install github/zpm-shell/lib-demo

# To remove a module
zpm uninstall <domain>/username/repository # e.g. zpm uninstall github/zpm-shell/lib-demo
```

### For example
#### 1. Initialize the zpm project.

```sh
$ zpm init demo
{
    "name": "demo",
    "version": "1.0.0",
    "description": "A zpm package",
    "main": "lib/main.zsh",
    "scripts": {
        "start": "zpm run lib/main.zsh",
        "test": "echo \"Error: no test specified\" && exit 1"
    },
    "keywords": [],
    "author": "",
    "license": "ISC"
}
Create zpm-package.json success
$ tree .
.
├── lib
│   └── main.zsh
└── zpm-package.json
```

#### 2. Install a lib module.

```sh
zpm install github/zpm-shell/lib-demo
```

#### 3. Use the lib module in zsh script in `lib/main.zsh`
```sh
# !/usr/bin/env zpm

import "github.com/zpm-shell/lib-demo" --as demo # <-- import the lib module.

function main() {
    call demo.main # <-- Use the main function from the lib module.
}

```

#### 4. Run the script
```sh
zpm run lib/main.zsh
```

## Contributing

We welcome contributions to zpm! If you have suggestions for improvements or new features, please open an issue or submit a pull request.

## License
zpm is open-source software licensed under the MIT license.

For more information, please visit zpm documentation.

Remember to replace placeholders like `https://github.com/wuchuheng/zpm.git` with the actual URL of your repository and provide the correct link to your documentation. This `README.md` is meant to serve as a starting point, and you should expand upon each section to give users a comprehensive overview of your project.



