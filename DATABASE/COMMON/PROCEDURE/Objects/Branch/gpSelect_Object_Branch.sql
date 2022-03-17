-- Function: gpSelect_Object_Branch(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Branch (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Branch(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InvNumber TVarChar, PlaceOf TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , PersonalStoreId Integer, PersonalStoreName TVarChar
             , PersonalBookkeeperId Integer, PersonalBookkeeperName TVarChar
             , PersonalBookkeeper_sign TVarChar

             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , Member1Id Integer, Member1Name TVarChar
             , Member2Id Integer, Member2Name TVarChar
             , Member3Id Integer, Member3Name TVarChar
             , Member4Id Integer, Member4Name TVarChar
             , CarId Integer, CarName TVarChar

             , UnitId Integer, UnitName TVarChar
             , UnitReturnId Integer, UnitReturnName TVarChar
             , IsMedoc boolean, IsPartionDoc boolean
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Branch());
   vbUserId:= lpGetUserBySession (inSession);
   -- определяется - может ли пользовать видеть весь справочник
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- Результат
   RETURN QUERY 
   SELECT Object_Branch.Id           AS Id
        , Object_Branch.ObjectCode   AS Code
        , Object_Branch.ValueData    AS NAME
        
        , ObjectString_InvNumber.ValueData  AS InvNumber
        , ObjectString_PlaceOf.ValueData    AS PlaceOf

        , Object_Personal_View.PersonalId    AS PersonalId
        , Object_Personal_View.PersonalName  AS PersonalName 

        , Object_PersonalStore_View.PersonalId    AS PersonalStoreId
        , Object_PersonalStore_View.PersonalName  AS PersonalStoreName

        , Object_PersonalBookkeeper_View.PersonalId    AS PersonalBookkeeperId
        , Object_PersonalBookkeeper_View.PersonalName  AS PersonalBookkeeperName
        
        , ObjectString_PersonalBookkeeper.ValueData ::TVarChar AS PersonalBookkeeper_sign

        , Object_PersonalDriver.Id         AS PersonalDriverId
        , Object_PersonalDriver.ValueData  AS PersonalDriverName 
        , Object_Member1.Id                AS Member1Id
        , Object_Member1.ValueData         AS Member1Name 
        , Object_Member2.Id                AS Member2Id
        , Object_Member2.ValueData         AS Member2Name 
        , Object_Member3.Id                AS Member3Id
        , Object_Member3.ValueData         AS Member3Name 
        , Object_Member4.Id                AS Member4Id
        , Object_Member4.ValueData         AS Member4Name 
        , Object_Car.Id                    AS CarId
        , Object_Car.ValueData             AS CarName

        , Object_Unit.Id         AS UnitId
        , Object_Unit.ValueData  AS UnitName

        , Object_UnitReturn.Id         AS UnitReturnId
        , Object_UnitReturn.ValueData  AS UnitReturnName
       
        , COALESCE (ObjectBoolean_Medoc.ValueData, False)      AS IsMedoc
        , COALESCE (ObjectBoolean_PartionDoc.ValueData, False) AS IsPartionDoc
        , Object_Branch.isErased             AS isErased
        
   FROM Object AS Object_Branch
        LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId
                  ) AS tmpRoleAccessKey ON vbAccessKeyAll = FALSE
                   AND tmpRoleAccessKey.AccessKeyId = Object_Branch.AccessKeyId

        LEFT JOIN ObjectString AS ObjectString_InvNumber
                               ON ObjectString_InvNumber.ObjectId = Object_Branch.Id
                              AND ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()       
        LEFT JOIN ObjectString AS ObjectString_PlaceOf
                               ON ObjectString_PlaceOf.ObjectId = Object_Branch.Id
                              AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()       
        LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                               ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                              AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()   
                              
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Medoc
                                ON ObjectBoolean_Medoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_Medoc.DescId = zc_ObjectBoolean_Branch_Medoc()    
                    
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                ON ObjectBoolean_PartionDoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc() 

        LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                             ON ObjectLink_Branch_Personal.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
        LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_Personal.ChildObjectId     

        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                             ON ObjectLink_Branch_PersonalStore.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
        LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId  

        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                             ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
        LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     

        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalDriver
                             ON ObjectLink_Branch_PersonalDriver.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalDriver.DescId = zc_ObjectLink_Branch_PersonalDriver()
        LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Branch_PersonalDriver.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member1
                             ON ObjectLink_Branch_Member1.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member1.DescId = zc_ObjectLink_Branch_Member1()
        LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = ObjectLink_Branch_Member1.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member2
                             ON ObjectLink_Branch_Member2.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member2.DescId = zc_ObjectLink_Branch_Member2()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_Branch_Member2.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member3
                             ON ObjectLink_Branch_Member3.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member3.DescId = zc_ObjectLink_Branch_Member3()
        LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = ObjectLink_Branch_Member3.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member4
                             ON ObjectLink_Branch_Member4.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member4.DescId = zc_ObjectLink_Branch_Member4()
        LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = ObjectLink_Branch_Member4.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Car
                             ON ObjectLink_Branch_Car.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Car.DescId = zc_ObjectLink_Branch_Car()
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Branch_Car.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Branch_Unit
                             ON ObjectLink_Branch_Unit.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Unit.DescId = zc_ObjectLink_Branch_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Branch_Unit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Branch_UnitReturn
                             ON ObjectLink_Branch_UnitReturn.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_UnitReturn.DescId = zc_ObjectLink_Branch_UnitReturn()
        LEFT JOIN Object AS Object_UnitReturn ON Object_UnitReturn.Id = ObjectLink_Branch_UnitReturn.ChildObjectId

        
   WHERE Object_Branch.DescId = zc_Object_Branch()
--     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll = TRUE)

 UNION ALL

   SELECT Object_Branch.Id           AS Id
        , Object_Branch.ObjectCode   AS Code
        , 'УДАЛИТЬ' :: TVarChar AS Name
        
        , ObjectString_InvNumber.ValueData  AS InvNumber
        , ObjectString_PlaceOf.ValueData    AS PlaceOf

        , Object_Personal_View.PersonalId    AS PersonalId
        , Object_Personal_View.PersonalName  AS PersonalName 

        , Object_PersonalStore_View.PersonalId    AS PersonalStoreId
        , Object_PersonalStore_View.PersonalName  AS PersonalStoreName

        , Object_PersonalBookkeeper_View.PersonalId    AS PersonalBookkeeperId
        , Object_PersonalBookkeeper_View.PersonalName  AS PersonalBookkeeperName
        
        , ObjectString_PersonalBookkeeper.ValueData ::TVarChar AS PersonalBookkeeper_sign

        , Object_PersonalDriver.Id         AS PersonalDriverId
        , Object_PersonalDriver.ValueData  AS PersonalDriverName 
        , Object_Member1.Id                AS Member1Id
        , Object_Member1.ValueData         AS Member1Name 
        , Object_Member2.Id                AS Member2Id
        , Object_Member2.ValueData         AS Member2Name 
        , Object_Member3.Id                AS Member3Id
        , Object_Member3.ValueData         AS Member3Name 
        , Object_Member4.Id                AS Member4Id
        , Object_Member4.ValueData         AS Member4Name 
        , Object_Car.Id                    AS CarId
        , Object_Car.ValueData             AS CarName

        , Object_Unit.Id         AS UnitId
        , Object_Unit.ValueData  AS UnitName

        , Object_UnitReturn.Id         AS UnitReturnId
        , Object_UnitReturn.ValueData  AS UnitReturnName
       
        , COALESCE (ObjectBoolean_Medoc.ValueData, False)      AS IsMedoc
        , COALESCE (ObjectBoolean_PartionDoc.ValueData, False) AS IsPartionDoc
        , Object_Branch.isErased             AS isErased
        
   FROM (SELECT 0 AS x) AS tmp
        LEFT JOIN Object AS Object_Branch ON Object_Branch.DescId = zc_Object_Branch() AND 1=0
        LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId
                  ) AS tmpRoleAccessKey ON vbAccessKeyAll = FALSE
                   AND tmpRoleAccessKey.AccessKeyId = Object_Branch.AccessKeyId

        LEFT JOIN ObjectString AS ObjectString_InvNumber
                               ON ObjectString_InvNumber.ObjectId = Object_Branch.Id
                              AND ObjectString_InvNumber.DescId = zc_objectString_Branch_InvNumber()       
        LEFT JOIN ObjectString AS ObjectString_PlaceOf
                               ON ObjectString_PlaceOf.ObjectId = Object_Branch.Id
                              AND ObjectString_PlaceOf.DescId = zc_objectString_Branch_PlaceOf()       
        LEFT JOIN ObjectString AS ObjectString_PersonalBookkeeper
                               ON ObjectString_PersonalBookkeeper.ObjectId = Object_Branch.Id
                              AND ObjectString_PersonalBookkeeper.DescId = zc_objectString_Branch_PersonalBookkeeper()   
                              
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Medoc
                                ON ObjectBoolean_Medoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_Medoc.DescId = zc_ObjectBoolean_Branch_Medoc()    
                    
        LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                ON ObjectBoolean_PartionDoc.ObjectId = Object_Branch.Id
                               AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc() 

        LEFT JOIN ObjectLink AS ObjectLink_Branch_Personal
                             ON ObjectLink_Branch_Personal.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Personal.DescId = zc_ObjectLink_Branch_Personal()
        LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Branch_Personal.ChildObjectId     

        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                             ON ObjectLink_Branch_PersonalStore.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalStore.DescId = zc_ObjectLink_Branch_PersonalStore()
        LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId  

        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalBookkeeper
                             ON ObjectLink_Branch_PersonalBookkeeper.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalBookkeeper.DescId = zc_ObjectLink_Branch_PersonalBookkeeper()
        LEFT JOIN Object_Personal_View AS Object_PersonalBookkeeper_View ON Object_PersonalBookkeeper_View.PersonalId = ObjectLink_Branch_PersonalBookkeeper.ChildObjectId                     

        LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalDriver
                             ON ObjectLink_Branch_PersonalDriver.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_PersonalDriver.DescId = zc_ObjectLink_Branch_PersonalDriver()
        LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = ObjectLink_Branch_PersonalDriver.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member1
                             ON ObjectLink_Branch_Member1.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member1.DescId = zc_ObjectLink_Branch_Member1()
        LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = ObjectLink_Branch_Member1.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member2
                             ON ObjectLink_Branch_Member2.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member2.DescId = zc_ObjectLink_Branch_Member2()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_Branch_Member2.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member3
                             ON ObjectLink_Branch_Member3.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member3.DescId = zc_ObjectLink_Branch_Member3()
        LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = ObjectLink_Branch_Member3.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Member4
                             ON ObjectLink_Branch_Member4.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Member4.DescId = zc_ObjectLink_Branch_Member4()
        LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = ObjectLink_Branch_Member4.ChildObjectId
        LEFT JOIN ObjectLink AS ObjectLink_Branch_Car
                             ON ObjectLink_Branch_Car.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Car.DescId = zc_ObjectLink_Branch_Car()
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Branch_Car.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Branch_Unit
                             ON ObjectLink_Branch_Unit.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_Unit.DescId = zc_ObjectLink_Branch_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Branch_Unit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Branch_UnitReturn
                             ON ObjectLink_Branch_UnitReturn.ObjectId = Object_Branch.Id
                            AND ObjectLink_Branch_UnitReturn.DescId = zc_ObjectLink_Branch_UnitReturn()
        LEFT JOIN Object AS Object_UnitReturn ON Object_UnitReturn.Id = ObjectLink_Branch_UnitReturn.ChildObjectId
   
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Branch(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.03.21         * PersonalBookkeeper
 21.12.15         * add Unit, UnitReturn
 20.12.15         * add Personal, PersonalStore, PlaceOf
 28.04.15         * add PartionDoc
 17.04.15         * add IsMedoc
 18.03.15         * add InvNumber, PersonalBookkeeper               
 14.12.13                                        * add vbAccessKeyAll
 08.12.13                                        * add Object_RoleAccessKey_View
 10.05.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Branch (zfCalc_UserAdmin())
