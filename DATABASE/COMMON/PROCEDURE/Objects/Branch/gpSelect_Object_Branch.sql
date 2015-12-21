-- Function: gpSelect_Object_Branch(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Branch (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Branch(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , InvNumber TVarChar, PlaceOf TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , PersonalStoreId Integer, PersonalStoreName TVarChar
             , PersonalBookkeeperId Integer, PersonalBookkeeperName TVarChar
             , IsMedoc boolean, IsPartionDoc boolean
             , isErased boolean)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Branch());
   vbUserId:= lpGetUserBySession (inSession);
   -- ������������ - ����� �� ���������� ������ ���� ����������
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- ���������
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
        
   WHERE Object_Branch.DescId = zc_Object_Branch()
     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll = TRUE)
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Branch(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.15         * add Personal, PersonalStore, PlaceOf
 28.04.15         * add PartionDoc
 17.04.15         * add IsMedoc
 18.03.15         * add InvNumber, PersonalBookkeeper               
 14.12.13                                        * add vbAccessKeyAll
 08.12.13                                        * add Object_RoleAccessKey_View
 10.05.13         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Branch (zfCalc_UserAdmin())