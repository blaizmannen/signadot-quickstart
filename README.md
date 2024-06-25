## Requirements
- Kind
- kubectl
- helm
- Signadot Chrome Extension (https://chromewebstore.google.com/detail/signadot/aigejiccjejdeiikegdjlofgcjhhnkim?hl=en)

## Deploy local Kubernetes (Kind) cluster
```
make up
```

## Deploy Signadot demo application and Sandbox
```shell
make signadot
```

## Destroy
```
make down
```
