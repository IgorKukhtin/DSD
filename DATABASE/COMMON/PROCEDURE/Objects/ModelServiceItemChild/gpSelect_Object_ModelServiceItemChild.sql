-- Function: gpSelect_Object_ModelServiceItemChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ModelServiceItemChild(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ModelServiceItemChild(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Comment TVarChar
             , FromId Integer, FromName TVarChar                
             , ToId Integer, ToName TVarChar  
             , ModelServiceItemMasterId Integer, ModelServiceItemMasterName TVarChar                
             , isErased boolean
             ) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ModelServiceItemChild());

   RETURN QUERY 
     SELECT 
           Object_ModelServiceItemChild.Id    AS Id
 
         , ObjectString_Comment.ValueData      AS Comment
                                                        
         , Object_From.Id          AS FromId
         , CASE WHEN Object_From.DescId = zc_Object_Goods() THEN '(' || Object_From.ObjectCode :: TvarChar || ') ' || Object_From.ValueData ELSE Object_From.ValueData END :: TVarChar AS FromName

         , Object_To.Id         AS ToId
         , CASE WHEN Object_From.DescId = zc_Object_Goods() THEN '(' || Object_To.ObjectCode :: TvarChar || ') ' || Object_To.ValueData ELSE Object_To.ValueData END :: TVarChar AS ToName

         , Object_ModelServiceItemMaster.Id         AS ModelServiceItemMasterId
         , Object_ModelServiceItemMaster.ValueData  AS ModelServiceItemMasterName

         , Object_ModelServiceItemChild.isErased AS isErased
         
     FROM OBJECT AS Object_ModelServiceItemChild
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                               ON ObjectLink_ModelServiceItemChild_From.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_From.DescId = zc_ObjectLink_ModelServiceItemChild_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_ModelServiceItemChild_From.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                               ON ObjectLink_ModelServiceItemChild_To.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_To.DescId = zc_ObjectLink_ModelServiceItemChild_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_ModelServiceItemChild_To.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ModelServiceItemMaster
                               ON ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.DescId = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()
          LEFT JOIN Object AS Object_ModelServiceItemMaster ON Object_ModelServiceItemMaster.Id = ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ModelServiceItemChild.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_ModelServiceItemChild_Comment()

     WHERE Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild();
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.10.13         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_ModelServiceItemChild ('2')
