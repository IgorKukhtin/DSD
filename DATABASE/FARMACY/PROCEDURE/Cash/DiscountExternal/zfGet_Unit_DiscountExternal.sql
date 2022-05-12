-- Function: zfGet_Unit_DiscountExternal

DROP FUNCTION IF EXISTS zfGet_Unit_DiscountExternal (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION zfGet_Unit_DiscountExternal (inDiscountExternalID  Integer,
                                                         inUnitId              Integer,
                                                         inUserId              Integer)
RETURNS Integer
AS
$BODY$
BEGIN

  IF EXISTS(SELECT *
            FROM Object AS Object_DiscountExternal

                 INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                       ON ObjectLink_DiscountExternal.ChildObjectId = Object_DiscountExternal.Id
                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                 INNER JOIN ObjectLink AS ObjectLink_Unit
                                       ON ObjectLink_Unit.ObjectId = ObjectLink_DiscountExternal.ObjectId
                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                      AND ObjectLink_Unit.ChildObjectId = inUnitId

            WHERE Object_DiscountExternal.DescId = zc_Object_DiscountExternal()
              AND Object_DiscountExternal.Id = inDiscountExternalID
              AND Object_DiscountExternal.isErased = False)
  THEN
    IF inUserId = 3 AND False
    THEN
      Return inDiscountExternalID;  
    ELSE
      Return 0;
    END IF;    
  ELSE
    Return 0;
  END IF;


END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfGet_Unit_DiscountExternal (Integer, Integer, Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.06.20                                                       *
*/

-- тест
--

-- тест select * from zfGet_Unit_DiscountExternal(inDiscountExternalID := 13216391 , inUnitId := 13711869 , inUserID := 3);