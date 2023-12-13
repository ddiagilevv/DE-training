FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

WORKDIR /postgres-to-s3

ENTRYPOINT ["python3", "/index.py"]

RUN python3 -m pip install sqlalchemy

COPY /index.py /index.py
