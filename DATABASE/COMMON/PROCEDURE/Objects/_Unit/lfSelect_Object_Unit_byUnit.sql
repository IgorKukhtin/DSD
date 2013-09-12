-- Function: lfSelect_Object_Unit_byUnitGroup (Integer)

-- DROP FUNCTION lfSelect_Object_Unit_byUnitGroup (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Unit_byUnit (IN inUnitId Integer)
RETURNS TABLE  (UnitId Integer)  
AS
$BODY$
BEGIN

    RETURN QUERY
    WITH RecurObjectLink (ObjectId, ChildObjectId, Code) AS
    (
    	SELECT sc.ObjectId, sc.ChildObjectId FROM ObjectLink sc 
    	UNION ALL
    	SELECT sc.ObjectId, sc.ChildObjectId FROM ObjectLink sc 
    		INNER JOIN RecurObjectLink rs ON rs.ChildObjectId = sc.ObjectId
    	WHERE sc.DescId = zc_Object_Unit()
    )
     SELECT ObjectLink_0.ObjectId AS UnitId 
     FROM ObjectLink 
        LEFT JOIN RecurObjectLink ON ObjectLink.ChildObjectId = RecurObjectLink.ObjectId  
                                 AND RecurObjectLink.ChildObjectId = inUnitId
     WHERE ObjectLink.DescId = zc_Object_Unit();

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Unit_byUnit (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.13         *  add WITH RecurObjectLink
 09.09.13         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Unit_byUnitGroup (zc_Enum_UnitGroup_20000())
