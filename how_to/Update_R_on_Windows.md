## Updating on Windows

Updating on Windows is apparently tricky, a package called installr, which is only for Windows can be used to ease the process.
The following commands were taken from here, which goes into more details.
First Install the installr package if you don’t have it

```
# installing/loading the package:
if(!require(installr)) {
  install.packages("installr");
  require(installr)
} #load / install+load installr
```

Now call `updateR()` function to call update
This will start the updating process of your R installation. It will check for newer versions, and if one is available, will guide you through the decisions you’d need to make.

## using the package:

```
updateR()
```