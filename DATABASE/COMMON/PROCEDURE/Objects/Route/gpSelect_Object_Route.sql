-- Function: gpSelect_Object_Route (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Route (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Route(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , RouteKindId Integer, RouteKindCode Integer, RouteKindName TVarChar
             , FreightId Integer, FreightCode Integer, FreightName TVarChar
             , isErased Boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Route());
   vbUserId:= lpGetUserBySession (inSession);
   -- ������������ - ����� �� ���������� ������ ���� ����������
   vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- ���������
   RETURN QUERY 
   SELECT
         Object_Route.Id         AS Id 
       , Object_Route.ObjectCode AS Code
       , Object_Route.ValueData  AS Name
              
       , Object_Unit.Id         AS UnitId 
       , Object_Unit.ObjectCode AS UnitCode
       , Object_Unit.ValueData  AS UnitName

       , Object_Branch.Id         AS BranchId 
       , Object_Branch.ObjectCode AS BranchCode
       , Object_Branch.ValueData  AS BranchName

       , Object_RouteKind.Id         AS RouteKindId 
       , Object_RouteKind.ObjectCode AS RouteKindCode
       , Object_RouteKind.ValueData AS RouteKindName

       , Object_Freight.Id         AS FreightId 
       , Object_Freight.ObjectCode AS FreightCode
       , Object_Freight.ValueData  AS FreightName
       
       , Object_Route.isErased   AS isErased
       
   FROM Object AS Object_Route
        LEFT JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON NOT vbAccessKeyAll AND tmpRoleAccessKey.AccessKeyId = Object_Route.AccessKeyId
        
        LEFT JOIN ObjectLink AS ObjectLink_Route_Unit ON ObjectLink_Route_Unit.ObjectId = Object_Route.Id
                                                     AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Route_Unit.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Route_Branch ON ObjectLink_Route_Branch.ObjectId = Object_Route.Id
                                                     AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Route_Branch.ChildObjectId
          
        LEFT JOIN ObjectLink AS ObjectLink_Route_RouteKind ON ObjectLink_Route_RouteKind.ObjectId = Object_Route.Id
                                                          AND ObjectLink_Route_RouteKind.DescId = zc_ObjectLink_Route_RouteKind()
        LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = ObjectLink_Route_RouteKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Route_Freight ON ObjectLink_Route_Freight.ObjectId = Object_Route.Id
                                                        AND ObjectLink_Route_Freight.DescId = zc_ObjectLink_Route_Freight()
        LEFT JOIN Object AS Object_Freight ON Object_Freight.Id = ObjectLink_Route_Freight.ChildObjectId
   
   WHERE Object_Route.DescId = zc_Object_Route()
     AND (tmpRoleAccessKey.AccessKeyId IS NOT NULL OR vbAccessKeyAll)
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Route (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.13                                        * add vbAccessKeyAll
 13.12.13         * add Branch             
 08.12.13                                        * add Object_RoleAccessKey_View
 24.09.13         *  add Unit, RouteKind, Freight
 03.06.13         *
*/
/*
insert into ObjectLink (DescId, ObjectId, ChildObjectId) select zc_ObjectLink_Route_Branch(), Object.Id, (select Id from Object WHERE Object.DescId = zc_Object_Branch() and ObjectCode=1) from Object WHERE Object.DescId = zc_Object_Route() ;
UPDATE Object SET AccessKeyId = Object2.AccessKeyId  from ObjectLink  left join Object as Object2 on Object2.Id = ObjectLink.ChildObjectId  WHERE Object.DescId = zc_Object_Route() and ObjectLink.ObjectId = Object.Id and ObjectLink.DescId = zc_ObjectLink_Route_Branch();
*/
-- ����
-- SELECT * FROM gpSelect_Object_Route (zfCalc_UserAdmin())
