# Build the Python container
FROM python:3.12.0a1-alpine3.16@sha256:3bc30a0e9dacf2a70d670a0cdee35cd97c896a987b92b7b0b333df7e300b1a42 as python
WORKDIR /app


FROM python as builder
ADD yaw yaw
COPY requirements.txt requirements.txt 
COPY setup.py setup.py
COPY README.md README.md
COPY LICENSE LICENSE
RUN pip install -r requirements.txt && \
	pip install .
# build_time_pseudo_code_goes_here


FROM python as release
COPY --from=builder /app .
# run_time_pseudo_code_goes_here
# production_hardening_pseudo_code_goes_here
ENTRYPOINT [ "yaw", "start" ]
EXPOSE 8000/tcp
