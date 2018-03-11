-- Function: gpSelect_Scale_StickerFile()

DROP FUNCTION IF EXISTS gpSelect_Scale_StickerFile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Scale_StickerFile(
    IN inBranchCode            Integer,      --
    IN inSession               TVarChar      -- сессия пользователя
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
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       SELECT Object_StickerFile.Id
            , Object_StickerFile.ObjectCode AS Code
              -- название файла fr3 в БАЗЕ
            , (Object_StickerFile.ValueData || '.Sticker') :: TVarChar AS FileName
              -- название файла fr3 в БАЗЕ
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.03.18                                        *
*/

-- тест
-- SELECT * FROM Object where DescId = zc_Object_Form() and ValueData like '%ША%
-- SELECT * FROM gpSelect_Scale_StickerFile (inBranchCode:= 301, inSession:=zfCalc_UserAdmin()) 
