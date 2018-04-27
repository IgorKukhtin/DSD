-- Function: lfSelect_Object_UnitParent_byUnit (Integer)
-- Список подразделений родителей выбранного
-- DROP FUNCTION lfSelect_Object_UnitParent_byUnit (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_UnitParent_byUnit (IN inUnitId Integer)
RETURNS TABLE (UnitId Integer, Level Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные
     RETURN QUERY
     
    WITH RECURSIVE RecurObjectLink (ObjectId, GroupId, Level) AS
    (
        SELECT ObjectLink.ObjectId, ObjectLink.ChildObjectId AS GroupId, 0 as Level
    	FROM ObjectLink
        WHERE ObjectLink.ObjectId = inUnitId
	      AND ObjectLink.DescId = zc_ObjectLink_Unit_Parent()
       UNION
    	SELECT ObjectLink.ObjectId, ObjectLink.ChildObjectId AS GroupId, RecurObjectLink.Level+1
    	FROM ObjectLink
    	    inner join RecurObjectLink ON RecurObjectLink.GroupId = ObjectLink.ObjectId
    	                              AND ObjectLink.DescId = zc_ObjectLink_Unit_Parent()
    )

 SELECT Object.Id AS UnitId, RecurObjectLink.Level
    FROM Object 
        INNER JOIN RecurObjectLink ON RecurObjectLink.ObjectId=Object.id 
                                  AND Object.DescId = zc_Object_Unit();
     
 END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.07.16         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_UnitParent_byUnit (8465) AS lfSelect_Object_UnitParent_byUnit JOIN Object_Unit_View ON Object_Unit_View.Id = lfSelect_Object_UnitParent_byUnit.UnitId ORDER BY 4
-- SELECT * FROM lfSelect_Object_UnitParent_byUnit (8453) AS lfSelect_Object_UnitParent_byUnit JOIN Object_Unit_View ON Object_Unit_View.Id = lfSelect_Object_UnitParent_byUnit.UnitId ORDER BY 4
-- SELECT * FROM lfSelect_Object_UnitParent_byUnit (8382) AS lfSelect_Object_UnitParent_byUnit JOIN Object_Unit_View ON Object_Unit_View.Id = lfSelect_Object_UnitParent_byUnit.UnitId ORDER BY 4

