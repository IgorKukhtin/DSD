-- Function: gpSelect_Object_ModelService(TVarChar)

DROP FUNCTION IF EXISTS  gpSelect_Object_ModelService(TVarChar);
DROP FUNCTION IF EXISTS  gpSelect_Object_ModelService(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ModelService(
    IN inIsShowAll   Boolean,       --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Comment TVarChar
             , UnitId Integer, UnitName TVarChar
             , ModelServiceKindId Integer, ModelServiceKindName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ModelService);

     RETURN QUERY 
       SELECT 
             Object_ModelService.Id          AS Id
           , Object_ModelService.ObjectCode  AS Code
           , Object_ModelService.ValueData   AS Name
           
           , ObjectString_Comment.ValueData  AS Comment
           
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ValueData   AS UnitName

           , Object_ModelServiceKind.Id          AS ModelServiceKindId
           , Object_ModelServiceKind.ValueData   AS ModelServiceKindName
           
           , Object_ModelService.isErased AS isErased
           
       FROM Object AS Object_ModelService
       
            LEFT JOIN ObjectString AS ObjectString_Comment ON ObjectString_Comment.ObjectId = Object_ModelService.Id 
                                                          AND ObjectString_Comment.DescId = zc_ObjectString_ModelService_Comment()
     
            LEFT JOIN ObjectLink AS ObjectLink_ModelService_Unit ON ObjectLink_ModelService_Unit.ObjectId = Object_ModelService.Id
                                                                AND ObjectLink_ModelService_Unit.DescId = zc_ObjectLink_ModelService_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_ModelService_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ModelService_ModelServiceKind ON ObjectLink_ModelService_ModelServiceKind.ObjectId = Object_ModelService.Id
                                                                            AND ObjectLink_ModelService_ModelServiceKind.DescId = zc_ObjectLink_ModelService_ModelServiceKind()
            LEFT JOIN Object AS Object_ModelServiceKind ON Object_ModelServiceKind.Id = ObjectLink_ModelService_ModelServiceKind.ChildObjectId

       WHERE Object_ModelService.DescId = zc_Object_ModelService()
         AND (Object_ModelService.isErased = False OR inIsShowAll = True)
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , '�������' :: TVarChar AS Name
            , ''        :: TVarChar AS Comment
            , 0         :: Integer  AS UnitId
            , ''        :: TVarChar AS UnitName
            , 0         :: Integer  AS ModelServiceKindId
            , ''        :: TVarChar AS ModelServiceKindName
            , FALSE                 AS isErased
       ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.06.17         *
 19.10.13         * 

*/

-- ����
-- SELECT * FROM gpSelect_Object_ModelService (inIsShowAll:=False, inSession:= zfCalc_UserAdmin())
