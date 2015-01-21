-- Function: gpSELECT_Object_RoleUNION()

DROP FUNCTION IF EXISTS gpSELECT_Object_RoleUnion (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSELECT_Object_RoleUnion (
    IN inValue       Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, process_enumname TVarChar
             , descName TVarChar, roleid Integer, roleName TVarChar
              ) AS
$BODY$
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT tmpAll.Id
        , tmpAll.Code
        , tmpAll.NAME
        , CAST (COALESCE (tmpAll.process_enumname, '') AS TVarChar) process_enumname
        , Objectdesc.itemName   AS descName
        , tmpAll.RoleId
        , Object_Role.ValueData AS roleName 
   FROM (
         SELECT tmp.Id, tmp.Code, tmp.Name, object.Descid AS DeckId, '' AS process_enumname
              , CASe when inValue = 1  THEN  tmp.roleid ELSE 0 END AS  roleid
         FROM gpSELECT_Object_RoleAction(inSession) AS tmp 
             join object on object.Id =  tmp.roleactionid
       UNION  
        SELECT tmp.Id, tmp.Code, tmp.Name, object.Descid AS DeckId, tmp.process_enumname
             , CASe when inValue = 1 THEN  tmp.roleid ELSE 0 END AS  roleid 
        FROM gpSELECT_Object_RoleProcess(inSession)  AS tmp
            join object on object.Id =  tmp.roleprocessid
       UNION 
        SELECT tmp.Id, tmp.Code, tmp.Name, object.Descid AS DeckId, '' AS process_enumname
             , CASe when inValue = 1 THEN  tmp.roleid ELSE 0 END AS  roleid
        FROM gpSELECT_Object_RoleUser(inSession) AS tmp
            join object on object.Id =  tmp.userroleid 
       UNION 
        SELECT tmp.Id, tmp.Code, tmp.Name, object.Descid AS DeckId, tmp.process_enumname 
             , CASe when inValue = 1 THEN  tmp.roleid ELSE 0 END AS  roleid   
        FROM gpSELECT_Object_RoleProcessAccess(inSession)  AS tmp
            join object on object.Id =  tmp.roleprocessid      
     ) AS tmpAll
     JOIN Objectdesc on Objectdesc.Id = tmpAll.DeckId
     LEFT JOIN Object AS Object_Role  on Object_Role.Id = tmpAll.RoleId
   GROUP BY tmpAll.Id, tmpAll.Code, tmpAll.Name, tmpAll.process_enumname, Objectdesc.itemName ,tmpAll.RoleId,Object_Role.ValueData
   ORDER BY 2;
  

END;
$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.15         *

*/

-- тест
--SELECT * FROM gpSELECT_Object_RoleUNION( 0 ,  '5')
