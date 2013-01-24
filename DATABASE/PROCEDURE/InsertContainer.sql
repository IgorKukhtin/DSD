-- Function: "InsertContainer"()

-- DROP FUNCTION "InsertContainer"();

CREATE OR REPLACE FUNCTION "InsertContainer"()
  RETURNS boolean AS
$BODY$DECLARE
	k INTEGER := 0;
	
BEGIN
  insert into Containerdesc(Id, Code)
  values(1, 'test1');
	WHILE (k < 1000000) LOOP
		k := k + 1;
  insert into container (descid, amount)
  values(1, 0);
  insert into containerlinkobject (containerid, objectId)
  values(k , k);
  insert into containerlinkobject (containerid, objectId)
  values(k , k+1);
	END LOOP;

  return true;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "InsertContainer"()
  OWNER TO postgres;
