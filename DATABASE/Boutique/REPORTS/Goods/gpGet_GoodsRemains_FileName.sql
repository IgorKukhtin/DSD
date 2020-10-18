-- Function: gpGet_GoodsRemains_FileName(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_GoodsRemains_FileName (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsRemains_FileName(
   OUT outFileName            TVarChar  ,
   OUT outDefaultFileExt      TVarChar  ,
   OUT outEncodingANSI        Boolean   ,
    IN inSession              TVarChar
)
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     SELECT ('GoodsRemains_' || CURRENT_DATE) AS outFileName
          , 'xml'                             AS outDefaultFileExt
          , FALSE                              AS outEncodingANSI
   INTO outFileName, outDefaultFileExt, outEncodingANSI
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.20         *
*/


-- тест
-- SELECT * FROM gpGet_GoodsRemains_FileName (inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
