-- Function: lfGet_ObjectCode(integer, integer)

-- DROP FUNCTION lfGet_ObjectCode(integer, integer);

CREATE OR REPLACE FUNCTION lfGet_ObjectCode(
    IN inObjectCode Integer, 
    IN inDescId Integer
)
RETURNS Integer AS
$BODY$
  DECLARE ObjectCode_ret Integer;
BEGIN
     IF COALESCE (inObjectCode, 0) = 0
     THEN 
         SELECT COALESCE (MAX (ObjectCode), 0) + 1 INTO ObjectCode_ret FROM Object WHERE DescId = inDescId;
     ELSE
         ObjectCode_ret:=inObjectCode;
     END IF;
     
     RETURN ObjectCode_ret;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_ObjectCode(integer, integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.13          *                             *

*/

-- тест
-- SELECT * FROM lfGet_ObjectCode( 0, zc_Object_Goods())
