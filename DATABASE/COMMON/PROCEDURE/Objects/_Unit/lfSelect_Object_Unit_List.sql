-- Function: lfSelect_Object_Unit_List (Integer)

-- DROP FUNCTION lfSelect_Object_Unit_List (Integer);

CREATE OR REPLACE FUNCTION lfSelect_Object_Unit_List (IN inUnitId Integer)
RETURNS TABLE  (LocationId Integer)  
AS
$BODY$
BEGIN

    RETURN QUERY
    
    WITH RECURSIVE RecurObjectLink (ObjectId, GroupId) AS
    (
        SELECT ObjectLink.ObjectId, ObjectLink.ChildObjectId AS GroupId
    	FROM ObjectLink
        WHERE ObjectLink.ChildObjectId=inUnitId OR ObjectLink.ObjectId=inUnitId 
	      AND ObjectLink.DescId = zc_ObjectLink_Unit_Parent()
       UNION
    	SELECT ObjectLink.ObjectId, ObjectLink.ChildObjectId AS GroupId
    	FROM ObjectLink
    	    inner join RecurObjectLink ON RecurObjectLink.ObjectId = ObjectLink.ChildObjectId
    	                              AND ObjectLink.DescId = zc_ObjectLink_Unit_Parent()
    	
    )

    SELECT Object.Id AS LocationId  
    FROM Object 
        INNER JOIN RecurObjectLink ON RecurObjectLink.ObjectId=Object.id 
                                  AND Object.DescId = zc_Object_Unit();
    
    
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_Object_Unit_List (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.13         *  Правильная рекурсия
 12.09.13         *  add WITH RecurObjectLink
 09.09.13         *
*/

-- тест
-- SELECT * FROM lfSelect_Object_Unit_List (zc_Enum_UnitGroup_20000())
