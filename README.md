# modelcars

## Setup

To build a modelcar for Llama-3.1-8b-instruct you can use these builds as reference.
This is how you can use them.

First create a new OCP project for your modelcars:
```
oc new-project modelcars
```

Then create an ImageStream that corresponds to the image we will be building:
```
oc create imagestream llama-3.1-8b
```

If you are attempting to download a gated or private model from HuggingFace, you'll need
a token to authenticate before you can download the model. This is the case for the Llama
models, so create a secret to store this token:
```
cat hf-login-secret-yaml | envsubst | oc apply -f -
```

Then you can create the provided Build and BuildRun for Llama-3.1-8b:
```
oc apply -f llama-3.1-8b/build.yaml
oc apply -f llama-3.1-8b/buildrun.yaml
```

This _should_ suffice to build a modelcar image in the internal OpenShift registry under
`modelcars/llama-3.1-8b:latest`.
