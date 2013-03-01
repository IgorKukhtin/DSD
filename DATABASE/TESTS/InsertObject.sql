-- Function: "InsertObject"()

-- DROP FUNCTION "InsertObject"();

CREATE OR REPLACE FUNCTION "InsertObject"()
  RETURNS boolean AS
$BODY$DECLARE
	k INTEGER := 0;
	
BEGIN
  -- Вставка товаров
  -- Вставка подразделений

	WHILE (k < 100) LOOP
	   k := k + 1;
           insert into Object (ValueData, ObjectCode, DescId)
           values('Подразделение '||k::varchar, k, zc_Object_Unit());
	END LOOP;
        
        k := 0;
	WHILE (k < 100000) LOOP
	   k := k + 1;
           insert into Object (ValueData, ObjectCode, DescId)
           values('Замечательный товар '||k::varchar ,k, zc_Object_Good());
	END LOOP;

  return true;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "InsertObject"()
  OWNER TO postgres;
