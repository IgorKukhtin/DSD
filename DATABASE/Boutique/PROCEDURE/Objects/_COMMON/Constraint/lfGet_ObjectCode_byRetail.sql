-- Function: lfGet_ObjectCode_byRetail (Integer, Integer, Integer)

-- DROP FUNCTION lfGet_ObjectCode_byRetail (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lfGet_ObjectCode_byRetail(
    IN inRetailId   Integer, 
    IN inObjectCode Integer, 
    IN inDescId     Integer
)
RETURNS Integer
AS
$BODY$
  DECLARE vbObjectCode Integer;
BEGIN
     IF COALESCE (inObjectCode, 0) = 0
     THEN 
         SELECT COALESCE (MAX (Object.ObjectCode), 0) + 1
                INTO vbObjectCode
         FROM ObjectLink
              INNER JOIN Object ON Object.Id = ObjectLink.ObjectId AND Object.DescId = inDescId
         WHERE ObjectLink.ChildObjectId = inRetailId
           AND ObjectLink.DescId = zc_ObjectLink_Goods_Object();
     ELSE
         vbObjectCode:= inObjectCode;
     END IF;
     
     RETURN (vbObjectCode);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfGet_ObjectCode_byRetail (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.16                                        *
*/

-- тест
-- SELECT * FROM lfGet_ObjectCode_byRetail ((SELECT MAX (Id) FROM Object WHERE DescId = zc_Object_Retail() LIMIT 1), 0, zc_Object_Goods())
