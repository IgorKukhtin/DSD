-- Function: lfSelect_Object_Unit_byGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Unit_byGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Unit_byGroup (IN inUnitId Integer)
RETURNS TABLE (UnitId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
     
     WITH RECURSIVE RecurObjectLink (ObjectId) AS
       (SELECT inUnitId
       UNION
        SELECT ObjectLink.ObjectId
        FROM ObjectLink
             INNER JOIN RecurObjectLink ON RecurObjectLink.ObjectId = ObjectLink.ChildObjectId
        WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Parent()
       ) 
     SELECT ObjectId AS UnitId FROM RecurObjectLink;
     
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lfSelect_Object_Unit_byGroup (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.05.13                                        * вроде работает правильно)))             
*/

-- тест
-- SELECT * FROM lfSelect_Object_Unit_byGroup (8465) AS lfSelect_Object_Unit_byGroup JOIN Object_Unit_View ON Object_Unit_View.Id = lfSelect_Object_Unit_byGroup.UnitId ORDER BY 4
-- SELECT * FROM lfSelect_Object_Unit_byGroup (8453) AS lfSelect_Object_Unit_byGroup JOIN Object_Unit_View ON Object_Unit_View.Id = lfSelect_Object_Unit_byGroup.UnitId ORDER BY 4

