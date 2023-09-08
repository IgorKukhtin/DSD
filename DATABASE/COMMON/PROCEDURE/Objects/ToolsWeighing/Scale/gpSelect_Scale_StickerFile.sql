-- Function: gpSelect_Scale_StickerFile()

DROP FUNCTION IF EXISTS gpSelect_Scale_StickerFile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_StickerFile(
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- ������ ������������
)
RETURNS TABLE (Id                   Integer
             , Code                 Integer
             , FormName             TVarChar
             , FileName             TVarChar
             , FileValue            Text
             , FileValue2           TBlob

             , FormName_70_70       TVarChar
             , FileName_70_70       TVarChar
             , FileValue_70_70      Text
             , FileValue2_70_70     TBlob
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
            , ObjectForm.ValueData                                     AS FormName
            , (Object_StickerFile.ValueData || '.Sticker') :: TVarChar AS FileName
              -- fr3 � ����
            , ObjectBlob.ValueData :: Text AS FileValue
            , ObjectBlob.ValueData         AS FileValue2

              -- �������� ����� fr3 � ����
            , ObjectForm_70_70.ValueData         AS FormName_70_70
            , CASE WHEN ObjectForm_70_70.ValueData <> '' THEN Object_StickerFile.ValueData || '_70_70.Sticker' ELSE '' END :: TVarChar AS FileName_70_70
              -- fr3 � ����
            , ObjectBlob_70_70.ValueData :: Text AS FileValue_70_70
            , ObjectBlob_70_70.ValueData         AS FileValue2_70_70

       FROM Object AS Object_StickerFile
            LEFT JOIN Object AS ObjectForm
                             ON ObjectForm.ValueData = (Object_StickerFile.ValueData || '.Sticker') :: TVarChar
                            AND ObjectForm.DescId    = zc_Object_Form()
            LEFT JOIN ObjectBlob ON ObjectBlob.ObjectId = ObjectForm.Id
                                AND ObjectBlob.DescId   = zc_objectBlob_Form_Data()
            --
            LEFT JOIN Object AS ObjectForm_70_70
                             ON ObjectForm_70_70.ValueData = (Object_StickerFile.ValueData || '_70_70.Sticker') :: TVarChar
                            AND ObjectForm_70_70.DescId    = zc_Object_Form()
            LEFT JOIN ObjectBlob AS ObjectBlob_70_70
                                ON ObjectBlob_70_70.ObjectId = ObjectForm_70_70.Id
                                AND ObjectBlob_70_70.DescId   = zc_objectBlob_Form_Data()
       WHERE Object_StickerFile.isErased = FALSE
         AND Object_StickerFile.DescId   = zc_Object_StickerFile()
         AND Object_StickerFile.ValueData <> ''
       --AND (Object_StickerFile.ValueData NOT ILIKE '������ + �� Գ���� ������ - ����������'
       --  OR vbUserId = 5
       --    )
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
