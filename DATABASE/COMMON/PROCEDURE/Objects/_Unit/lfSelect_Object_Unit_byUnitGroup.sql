-- Function: lfSelect_Object_Unit_byUnitGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Unit_byUnitGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Unit_byUnitGroup (IN inUnitGroupId Integer)
RETURNS TABLE  (UnitId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY
     SELECT ObjectLink_0.ObjectId AS UnitId 
     FROM ObjectLink AS ObjectLink_0
          LEFT JOIN ObjectLink AS ObjectLink_1 ON ObjectLink_0.ChildObjectId = ObjectLink_1.ObjectId  
          LEFT JOIN ObjectLink AS ObjectLink_2 ON ObjectLink_1.ChildObjectId = ObjectLink_2.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_3 ON ObjectLink_2.ChildObjectId = ObjectLink_3.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_4 ON ObjectLink_3.ChildObjectId = ObjectLink_4.ObjectId
          LEFT JOIN ObjectLink AS ObjectLink_5 ON ObjectLink_4.ChildObjectId = ObjectLink_5.ObjectId
     WHERE ObjectLink_0.DescId = zc_ObjectLink_Unit_UnitGroup() 
       AND ((ObjectLink_0.ChildObjectId = inUnitGroupId)
         OR (ObjectLink_1.ChildObjectId = inUnitGroupId)
         OR (ObjectLink_2.ChildObjectId = inUnitGroupId)
         OR (ObjectLink_3.ChildObjectId = inUnitGroupId)
         OR (ObjectLink_4.ChildObjectId = inUnitGroupId)
           ) ;

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Unit_byUnitGroup (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.13         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Unit_byUnitGroup (zc_Enum_UnitGroup_20000())
