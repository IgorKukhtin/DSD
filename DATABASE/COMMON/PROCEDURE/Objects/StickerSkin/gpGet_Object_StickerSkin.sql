-- Function: gpGet_Object_StickerSkin (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_StickerSkin (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerSkin(
    IN inId          Integer,       -- ���� ������� <����������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StickerSkin());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_StickerSkin()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS Comment

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_StickerSkin.Id          AS Id
           , Object_StickerSkin.ObjectCode  AS Code
           , Object_StickerSkin.ValueData   AS Name
           
           , ObjectString_Comment.ValueData AS Comment
           
           , Object_StickerSkin.isErased    AS isErased
           
       FROM Object AS Object_StickerSkin
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_StickerSkin.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_StickerSkin_Comment()

       WHERE Object_StickerSkin.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.17         *
*/

-- ����
-- SELECT * FROM gpGet_Object_StickerSkin (2, '')
