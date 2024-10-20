-- Function: gpSelect_Object_GoodsDocument(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsDocument(
    IN inGoodsId      Integer, 
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , FileName TVarChar
             , DocTagId Integer, DocTagName TVarChar
             , Comment TVarChar
             ) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsCondition());

   RETURN QUERY 
     SELECT Object_GoodsDocument.Id        AS Id
          , Object_GoodsDocument.ValueData AS FileName
          , Object_DocTag.Id               AS DocTagId
          , Object_DocTag.ValueData        AS DocTagName
          , ObjectString_Comment.ValueData AS Comment
     FROM Object AS Object_GoodsDocument
          JOIN ObjectLink AS ObjectLink_GoodsDocument_Goods
                          ON ObjectLink_GoodsDocument_Goods.ObjectId = Object_GoodsDocument.Id
                         AND ObjectLink_GoodsDocument_Goods.DescId = zc_ObjectLink_GoodsDocument_Goods()
                         AND ObjectLink_GoodsDocument_Goods.ChildObjectId = inGoodsId
           
          LEFT JOIN ObjectLink AS ObjectLink_DocTag
                               ON ObjectLink_DocTag.ObjectId = Object_GoodsDocument.Id
                              AND ObjectLink_DocTag.DescId = zc_ObjectLink_GoodsDocument_DocTag()
          LEFT JOIN Object AS Object_DocTag ON Object_DocTag.Id = ObjectLink_DocTag.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_GoodsDocument.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_GoodsDocument_Comment()  
     WHERE Object_GoodsDocument.DescId = zc_Object_GoodsDocument(); 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.04.21         *
 19.11.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsCondition ('2')