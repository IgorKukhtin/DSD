-- Function: "InsertObject"()

-- DROP FUNCTION "InsertObject"();

CREATE OR REPLACE FUNCTION "InsertObject"()
  RETURNS boolean AS
$BODY$DECLARE
	k INTEGER := 0;
	
BEGIN
  insert into objectdesc(Id, Code)
  values(1, 'test1');
  insert into objectdesc(Id, Code)
  values(2, 'test2');
	WHILE (k < 1000000) LOOP
		k := k + 1;
  insert into Object (ValueData, ObjectCode, DescId)
  values(k,k, 1);
  insert into Object (ValueData, ObjectCode, DescId)
  values(k,k, 2);
	END LOOP;

  return true;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "InsertObject"()
  OWNER TO postgres;
