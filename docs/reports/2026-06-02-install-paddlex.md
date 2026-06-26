# 2026-06-02 Install PaddleX on osm45 (docker-prod-2)

To anonymize receipt on Open Prices, we chose to detect personal information using a LVLM (large visual language model), as these models provide very performant and context-aware PII detection. However, LVLMs are still not very good at localizing exactly where the PII is located on the image.
We chose the following approach:

1. Use a LVLM to detect PII (as text) on the image
2. Use a PaddleX model to perform OCR and get each word's bounding box coordinates.
3. Localize the PII on the image using the bounding box coordinates.

Not many open source solutions exist to perform traditional OCR: Tesseract and PaddleOCR.

We chose PaddleOCR, as it provides better performance out of the box than Tesseract.

We need an inference service to run PaddleOCR. The recommended way is to use PaddleX, Baidu inference service.

## Creating the docker image

Baidu provides a [PaddleX docker image](https://paddlepaddle.github.io/PaddleX/latest/en/installation/installation.html#21-get-paddlex-via-docker) for CPU or GPU, available on their own Docker registry.
We first pull it (CPU version here):

```bash
docker pull ccr-2vdh3abv-pub.cnc.bj.baidubce.com/paddlex/paddlex:paddlex3.3.11-paddlepaddle3.2.0-cpu
```

We then need to modify the image to add the PaddleX serving plugin. First, launch the container:

```bash
docker run --name paddlex-install -it ccr-2vdh3abv-pub.cnc.bj.baidubce.com/paddlex/paddlex:paddlex3.3.11-paddlepaddle3.2.0-cpu /bin/bash
```

Then run:

```
paddlex --install serving
```

Exit the container (`exit`), and commit the changes to the image, under the name `openfoodfacts/paddlex-ocr`:

```bash
docker commit paddlex-install openfoodfacts/paddlex-ocr:paddlex3.3.11-paddlepaddle3.2.0-cpu
```

You can then push the image to the Docker registry:

```bash
docker push openfoodfacts/paddlex-ocr:paddlex3.3.11-paddlepaddle3.2.0-cpu
```

You can then pull and run the image:

```bash
docker run -v paddlex-models:/root/.paddlex/official_models --shm-size=8g -it openfoodfacts/paddlex-ocr:paddlex3.3.11-paddlepaddle3.2.0-cpu /bin/bash
```


## Deploying on hetzner-docker-staging (hetzner, staging)

The openfoodfacts-infrastructure repo was cloned locally at `/opt/openfoodfacts-infrastructure`.
In `/home/off`, a `paddlex` symlink was created to `/opt/openfoodfacts-infrastructure/docker/paddlex`.

```bash
cd /home/off && ln -s /opt/openfoodfacts-infrastructure/docker/paddlex paddlex
```

Then, `docker compose up -d` was run to start the service.

A stunnel server was then configured on hetzner-proxy (CT 100) to connect to PaddleX (port 5610).
As Open Prices staging is deployed on ovh-docker-staging, the stunnel client of OVH cluster  was configured
accordingly. 

## Deploying on docker-prod-2 (osm45, prod)

Same as for staging, except that the openfoodfacts-infrastructure repo already existed.

The stunnel server on osm45 (moji) was configured to accept connections on port 5610 (redirect to PaddleX
deployed on docker-prod-2).
As Open Prices production is deployed on scaleway-docker-prod-2, the stunnel client of Scaleway cluster was
configured accordingly.
