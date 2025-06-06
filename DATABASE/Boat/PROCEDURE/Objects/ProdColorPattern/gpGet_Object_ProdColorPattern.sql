-- Function: gpGet_Object_ProdColorPattern()

DROP FUNCTION IF EXISTS gpGet_Object_ProdColorPattern (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_ProdColorPattern (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdColorPattern(
    IN inId              Integer ,
    IN inColorPatternId  Integer ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , ProdColorGroupId Integer, ProdColorGroupName TVarChar
             , ColorPatternId Integer, ColorPatternName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_ProdColorPattern())   AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Comment
           , 0  :: Integer            AS ProdColorGroupId
           , '' :: TVarChar           AS ProdColorGroupName
           , Object_ColorPattern.Id        :: Integer  AS ColorPatternId
           , Object_ColorPattern.ValueData :: TVarChar AS ColorPatternName
           , 0  :: Integer            AS GoodsId
           , '' :: TVarChar           AS GoodsName
           , 0  :: Integer            AS ProdOptionsId
           , '' :: TVarChar           AS ProdOptionsName
       FROM Object AS Object_ColorPattern
       WHERE Object_ColorPattern.Id = inColorPatternId
         AND Object_ColorPattern.DescId = zc_Object_ColorPattern()
       ;
   ELSE
     RETURN QUERY

     SELECT 
           Object_ProdColorPattern.Id         AS Id 
       --, ROW_NUMBER() OVER (PARTITION BY Object_ProdColorGroup.Id ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorPattern.ObjectCode ASC) :: Integer AS Code
         , Object_ProdColorPattern.ObjectCode AS Code
         , Object_ProdColorPattern.ValueData  AS Name

         , ObjectString_Comment.ValueData     ::TVarChar AS Comment

         , Object_ProdColorGroup.Id           ::Integer  AS ProdColorGroupId
         , Object_ProdColorGroup.ValueData    ::TVarChar AS ProdColorGroupName

         , Object_ColorPattern.Id             ::Integer  AS ColorPatternId
         , Object_ColorPattern.ValueData      ::TVarChar AS ColorPatternName

         , Object_Goods.Id                    ::Integer  AS GoodsId
         , Object_Goods.ValueData             ::TVarChar AS GoodsName

         , Object_ProdOptions.Id              ::Integer  AS ProdOptionsId
         , Object_ProdOptions.ValueData       ::TVarChar AS ProdOptionsName
     FROM Object AS Object_ProdColorPattern
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                               ON ObjectLink_ProdOptions.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdColorPattern_ProdOptions()
          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId

     WHERE Object_ProdColorPattern.DescId = zc_Object_ProdColorPattern()
      AND Object_ProdColorPattern.Id = inId
     ;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.12.20         * zc_ObjectLink_ProdColorPattern_Goods
 15.10.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_ProdColorPattern (0,1, zfCalc_UserAdmin())