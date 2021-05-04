# Cloudfront

This repo will create a cloudfront distribution that serves a private S3 bucket's content.

The region should be somewhere far away so you can see the difference between loading the image
the first time (i.e. without Cloudfront edge location caching) vs the second time (on another device or browser), which
should be significantly faster.

You should also notice that you are only able to view the image via Cloudfront, and unable to reach the source image in
from the S3 bucket.

# Deploy

To deploy this ensure you have aws credentials setup, and then should be a simple

```shell
terraform init
terraform apply
```

