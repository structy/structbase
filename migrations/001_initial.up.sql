-- update date time on update_at field
CREATE OR REPLACE FUNCTION update_datetime()
RETURNS TRIGGER AS $$
BEGIN
        NEW.last_update = now();
        RETURN NEW;
END;
$$ language 'plpgsql';

-- uuid generator
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE OR REPLACE FUNCTION UUID() RETURNS uuid AS $$
BEGIN
        RETURN uuid_generate_v4();
END;
$$ LANGUAGE plpgsql;

-- audit trigger
CREATE OR REPLACE FUNCTION update_audit()
RETURNS TRIGGER AS $$
BEGIN
        INSERT INTO audits
        (uuid, key, node, version, object)
        VALUES
        (OLD.uuid, NEW.key, NEW.node, UUID(), OLD.object);
        RETURN NEW;
END;
$$ language 'plpgsql';

-- objects table
CREATE TABLE objects
(
        uuid character varying(250) DEFAULT UUID() NOT NULL,
        key character varying(150) NOT NULL,
        node character varying(150) NOT NULL,
        object jsonb DEFAULT '{}',
        created_at timestamp without time zone NOT NULL DEFAULT now(),
        last_update timestamp without time zone NOT NULL DEFAULT now(),
	PRIMARY KEY (uuid),
        CONSTRAINT unique_objects UNIQUE (key, node)
);
CREATE TRIGGER update_objects
BEFORE UPDATE ON objects
FOR EACH ROW EXECUTE PROCEDURE update_datetime();
CREATE TRIGGER update_audits
BEFORE UPDATE ON objects
FOR EACH ROW EXECUTE PROCEDURE update_audit();

-- audit table
CREATE TABLE audits
(
        uuid character varying(250) NOT NULL,
        key character varying(150) NOT NULL,
        node character varying(150) NOT NULL,
        version character varying(250) NOT NULL,
        object jsonb NOT NULL,
        created_at timestamp without time zone NOT NULL DEFAULT now(),
        last_update timestamp without time zone NOT NULL DEFAULT now(),
	PRIMARY KEY (uuid),
        CONSTRAINT unique_audits UNIQUE (key, node, version)
);
