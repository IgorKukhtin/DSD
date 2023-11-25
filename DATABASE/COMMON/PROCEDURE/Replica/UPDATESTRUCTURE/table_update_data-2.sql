DO $$
    BEGIN
        -- 1
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data') AND Column_Name ILIKE ('Amount'))) THEN
            ALTER TABLE _replica.table_update_data ADD COLUMN Amount TFloat;
        END IF;

        -- 3
        IF NOT (EXISTS(Select Column_Name From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data_two') AND Column_Name ILIKE ('Amount'))) THEN
            ALTER TABLE _replica.table_update_data_two ADD COLUMN Amount TFloat;
        END IF;

    END;
$$;

-- Table: _replica.table_update_data

-- DROP TABLE _replica.table_update_data;

DO $$
    BEGIN

    -- ONE
    IF NOT (EXISTS (SELECT 1 From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data')))
    THEN

        CREATE TABLE _replica.table_update_data
        (
          id bigserial NOT NULL,
          schema_name text,
          table_name text,
          pk_keys text,
          pk_values text,
          upd_cols text,
          operation text,
          transaction_id bigint,
          user_name text,
          last_modified timestamp without time zone DEFAULT timezone('utc'::text, CLOCK_TIMESTAMP()),
          parentid bigint,
          movementid bigint,
          Amount TFloat,
          CONSTRAINT table_update_data_pkey PRIMARY KEY (id)
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE _replica.table_update_data
          OWNER TO admin;

        -- Index: _replica.idx_table_update_data_last_modified
        -- DROP INDEX _replica.idx_table_update_data_last_modified;
        CREATE INDEX idx_table_update_data_last_modified
          ON _replica.table_update_data
          USING btree
          (last_modified);

        -- Index: _replica.idx_table_update_data_transaction_id
        -- DROP INDEX _replica.idx_table_update_data_transaction_id;
        CREATE INDEX idx_table_update_data_transaction_id
          ON _replica.table_update_data
          USING btree
          (transaction_id);

    END IF;


    -- TWO
    IF NOT (EXISTS (SELECT 1 From INFORMATION_SCHEMA.COLUMNS Where Table_Name ILIKE ('table_update_data_two')))
    THEN

        CREATE TABLE _replica.table_update_data_two
        (
          id bigserial NOT NULL,
          schema_name text,
          table_name text,
          pk_keys text,
          pk_values text,
          upd_cols text,
          operation text,
          transaction_id bigint,
          user_name text,
          last_modified timestamp without time zone DEFAULT timezone('utc'::text, CLOCK_TIMESTAMP()),
          parentid bigint,
          movementid bigint,
          Amount TFloat,
          CONSTRAINT table_update_data_two_pkey PRIMARY KEY (id)
        )
        WITH (
          OIDS=FALSE
        );
        ALTER TABLE _replica.table_update_data_two
          OWNER TO admin;

        -- Index: _replica.idx_table_update_data_two_last_modified
        -- DROP INDEX _replica.idx_table_update_data_two_last_modified;
        CREATE INDEX idx_table_update_data_two_last_modified
          ON _replica.table_update_data_two
          USING btree
          (last_modified);

        -- Index: _replica.idx_table_update_data_two_transaction_id
        -- DROP INDEX _replica.idx_table_update_data_two_transaction_id;
        CREATE INDEX idx_table_update_data_two_transaction_id
          ON _replica.table_update_data_two
          USING btree
          (transaction_id);

    END IF;

    END;
$$;
