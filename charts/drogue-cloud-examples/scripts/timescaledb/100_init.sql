CREATE TABLE temperatures (
    time TIMESTAMP WITH TIME ZONE NOT NULL,

    device_id VARCHAR(64) NOT NULL,

    temperature DOUBLE PRECISION NOT NULL,
    humidity DOUBLE PRECISION,
    battery DOUBLE PRECISION,

    lon NUMERIC,
    lat NUMERIC
);

SELECT create_hypertable('temperatures', 'time', 'device_id', 2);
