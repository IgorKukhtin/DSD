-- Function: gpSelect_Scale_StickerFile()

DROP FUNCTION IF EXISTS gpSelect_Scale_StickerFile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_StickerFile(
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- ������ ������������
)
RETURNS TABLE (Id             Integer
             , Code           Integer
             , FileName       TVarChar
             , FileValue      Text
             , FileValue2     TBlob
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
       SELECT Object_StickerFile.Id
            , Object_StickerFile.ObjectCode AS Code
              -- �������� ����� fr3 � ����
            , (Object_StickerFile.ValueData || '.Sticker') :: TVarChar AS FileName
              -- �������� ����� fr3 � ����
            , ObjectBlob.ValueData :: Text AS FileValue
            , ObjectBlob.ValueData         AS FileValue2
       FROM Object AS Object_StickerFile
            LEFT JOIN Object AS ObjectForm
                             ON ObjectForm.ValueData = (Object_StickerFile.ValueData || '.Sticker') :: TVarChar
                            AND ObjectForm.DescId    = zc_Object_Form()
            LEFT JOIN ObjectBlob ON ObjectBlob.ObjectId = ObjectForm.Id
                                AND ObjectBlob.DescId   = zc_objectBlob_Form_Data()
       WHERE Object_StickerFile.isErased = FALSE
         AND Object_StickerFile.DescId   = zc_Object_StickerFile()
         AND Object_StickerFile.ValueData <> ''
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.03.18                                        *
*/

-- ����
-- SELECT * FROM Object where DescId = zc_Object_Form() and ValueData like '%��%
-- SELECT * FROM gpSelect_Scale_StickerFile (inBranchCode:= 301, inSession:=zfCalc_UserAdmin()) 
