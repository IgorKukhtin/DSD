-- Function: gpGet_Object_StickerHeader()

DROP FUNCTION IF EXISTS gpGet_Object_StickerHeader(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StickerHeader(
    IN inId          Integer,       -- ���� ������� <��������� ��� ����>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Info Text
             , isDefault Boolean
             ) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_StickerHeader()) AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST ('' as Text)   AS Info
           , CAST (FALSE as Boolean) AS isDefault
       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_StickerHeader.Id         AS Id
           , Object_StickerHeader.ObjectCode AS Code
           , Object_StickerHeader.ValueData  AS Name

           , ObjectBlob_Info.ValueData   ::Text     AS Info
           , COALESCE (ObjectBoolean_Default.ValueData, False) ::Boolean AS isDefault
       FROM OBJECT AS Object_StickerHeader
        LEFT JOIN ObjectBlob AS ObjectBlob_Info
                             ON ObjectBlob_Info.ObjectId = Object_StickerHeader.Id 
                            AND ObjectBlob_Info.DescId = zc_ObjectBlob_StickerHeader_Info()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_StickerHeader.Id 
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_StickerHeader_Default()
       WHERE Object_StickerHeader.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.08.22         *
*/

-- ����
-- SELECT * FROM gpGet_Object_StickerHeader (0, '2')
