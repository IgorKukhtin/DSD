-- Function: lfGet_Object_FloorName (Integer, Integer)

DROP FUNCTION IF EXISTS lfGet_Object_FloorName (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_FloorName (
 inObjectId               Integer    -- начальный эл-нт дерева
)
  RETURNS TVarChar
AS
$BODY$
DECLARE
  vbNameFull TVarChar;  
BEGIN
     vbNameFull:= (SELECT CASE WHEN COALESCE (ObjectLink_parent4.ChildObjectId, 0) = 0 THEN Parent1.ValueData
                              -- WHEN COALESCE (ObjectLink_parent4.ChildObjectId, 0) = 0 THEN Parent2.ValueData
                               ELSE ''
                          END
                   FROM Object
                        LEFT JOIN ObjectLink AS ObjectLink_parent1
                                             ON ObjectLink_parent1.ObjectId = Object.Id
                                            AND ObjectLink_parent1.DescId   = zc_ObjectLink_Unit_Parent()
                        LEFT JOIN Object AS Parent1 ON Parent1.Id = ObjectLink_parent1.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_parent2
                                             ON ObjectLink_parent2.ObjectId = ObjectLink_parent1.ChildObjectId
                                            AND ObjectLink_parent2.DescId   = zc_ObjectLink_Unit_Parent()
                        LEFT JOIN Object AS Parent2 ON Parent2.Id = ObjectLink_parent2.ChildObjectId
                                            
                        LEFT JOIN ObjectLink AS ObjectLink_parent3
                                             ON ObjectLink_parent3.ObjectId = ObjectLink_parent2.ChildObjectId
                                            AND ObjectLink_parent3.DescId   = zc_ObjectLink_Unit_Parent() 

                        LEFT JOIN ObjectLink AS ObjectLink_parent4
                                             ON ObjectLink_parent4.ObjectId = ObjectLink_parent3.ChildObjectId
                                            AND ObjectLink_parent4.DescId   = zc_ObjectLink_Unit_Parent()

                   WHERE Object.Id = inObjectId
                  );
     --
     RETURN (vbNameFull);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.05.22         *                            
*/

-- тест
--     SELECT * FROM lfGet_Object_FloorName (52474) --52778 )
