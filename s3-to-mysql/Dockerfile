FROM amazon/aws-glue-libs:glue_libs_4.0.0_image_01

USER root

RUN python3 -m pip install pandas sqlalchemy boto3 pymysql

RUN mkdir -p /usr/local/lib/glue_jars && \
    curl -o /usr/local/lib/glue_jars/mysql-connector-java-8.0.26.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.26/mysql-connector-java-8.0.26.jar

COPY /index.py /index.py

ENV SPARK_CLASSPATH=/usr/local/lib/glue_jars/*

WORKDIR /

USER glue_user

ENTRYPOINT ["python3", "/index.py"]
