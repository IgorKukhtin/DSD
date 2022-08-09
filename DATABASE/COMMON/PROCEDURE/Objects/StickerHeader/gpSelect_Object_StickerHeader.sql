-- Function: gpSelect_Object_StickerHeader()

DROP FUNCTION IF EXISTS gpSelect_Object_StickerHeader( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StickerHeader(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Info Text, isDefault Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpGetUserBySession (inSession);

      -- ���������
      RETURN QUERY
       SELECT 
             Object_StickerHeader.Id         AS Id
           , Object_StickerHeader.ObjectCode AS Code
           , Object_StickerHeader.ValueData  AS Name

           , ObjectBlob_Info.ValueData   ::Text AS Info
           , COALESCE (ObjectBoolean_Default.ValueData, False) ::Boolean AS isDefault
           , Object_StickerHeader.isErased   AS isErased
       FROM Object AS Object_StickerHeader
        LEFT JOIN ObjectBlob AS ObjectBlob_Info
                             ON ObjectBlob_Info.ObjectId = Object_StickerHeader.Id 
                            AND ObjectBlob_Info.DescId = zc_ObjectBlob_StickerHeader_Info()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_StickerHeader.Id 
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_StickerHeader_Default()
       WHERE Object_StickerHeader.DescId = zc_Object_StickerHeader()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.08.22         *
*/

-- ����
--  SELECT * FROM gpSelect_Object_StickerHeader ( zfCalc_UserAdmin())


