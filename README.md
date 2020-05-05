# azure-ubuntu-jitsi

An Azure template and `cloud-init` setup to deploy [Jitsi Meet][jitsi] on Azure using [this `docker-compose` repository][compose]

## Usage

* Edit the `Makefile` to taste
* Set up your `meet.foobar` domain name to point to `resourcegroup-hostname.region.cloudapp.azure.com`
* `make deploy`

## Roadmap

* [ ] Set up authentication
* [x] Base server template and `cloud-config`

## `Makefile` commands

* `make params` - generates ARM template parameters
* `make deploy` - deploys everything
* `make destroy` - destroys everything
* `make redeployt` - destroys and redeploys
* `make view-deployment` - view deployment progress

## Recommended Sequence

    az login
    make params
    make deploy
    make view-deployment
    # Go to the Azure portal and check the deployment progress
    
    # Clean up after we're done working
    make destroy

## Requirements

* [Python][p]
* The [Azure CLI][az] (`pip install -U azure-cli` will install/update it)
* GNU `make` (you can just read through the `Makefile` and type the commands yourself)

## Notes

For some reason, the tried and tested approach I've been following to deploy the Linux diagnostics extension (3.x) appears to be broken. That is (quite honestly) a pain I could do without at this point, so I removed it.

[d]: http://docker.com
[p]: http://python.org
[az]: https://github.com/Azure/azure-cli
[jitsi]: https://jitsi.org/jitsi-meet/
[compose]: https://github.com/jitsi/docker-jitsi-meet 
