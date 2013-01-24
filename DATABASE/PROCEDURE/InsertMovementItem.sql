
CREATE OR REPLACE FUNCTION "InsertMovementitem"()
  RETURNS boolean AS
$BODY$DECLARE
	k INTEGER := 0;
BEGIN
	WHILE (k < 30000000) LOOP
		k := k + 1;
  insert into  movementitem(amount, containerid, operdate)
  values(random()*10000, 1+round(random()*1000000), current_date() - round(random()*100) );
	END LOOP;

  return true;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


-- Table: movementitem

-- DROP TABLE movementitem;

CREATE TABLE movementitem
(
  id integer NOT NULL DEFAULT nextval('"movementitem_Id_seq"'::regclass),
  amount tfloat,
  containerid integer,
  operdate date,
  CONSTRAINT mvid PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE movementitem
  OWNER TO postgres;

-- Index: mvall

-- DROP INDEX mvall;

CREATE INDEX mvall
  ON movementitem
  USING btree
  (containerid, operdate, amount);

