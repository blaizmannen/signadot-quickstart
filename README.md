## Requirements
- Kind
- kubectl
- helm

## Bootstrap
```
make up
```
## Create Sandbox
https://www.signadot.com/docs/tutorials/quickstart/first-sandbox
```
name: negative-eta-fix
spec:
  description: Fix negative ETA in Route Service
  cluster: "@{cluster}"
  forks:
    - forkOf:
        kind: Deployment
        namespace: hotrod
        name: route
      customizations:
        images:
          - image: signadot/hotrod:quickstart-v2-fix
            container: hotrod
```

## Destroy
```
make down
```
