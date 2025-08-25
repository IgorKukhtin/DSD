
DROP FUNCTION IF EXISTS gpGet_MemberBirthDay_FileName (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MemberBirthDay_FileName(
   OUT outFileName            TVarChar  ,
   OUT outFileNamePrefix      TVarChar  ,
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
     SELECT 
            '' ::TVarChar AS outFileNamePrefix

          , ('Список_іменинників_'
           ||(zfConvert_DateToString (CURRENT_TIMESTAMP)
           || ' ' || CASE WHEN EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) < 10 THEN '0' ELSE '' END || EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) :: TVarChar
           || '_' || CASE WHEN EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) < 10 THEN '0' ELSE '' END || EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) :: TVarChar
              ))      ::TVarChar  AS outFileName

          ,  '.xls'  ::TVarChar AS outDefaultFileExt

          ,  FALSE     ::Boolean   AS outEncodingANSI
   INTO outFileNamePrefix, outFileName, outDefaultFileExt, outEncodingANSI
     ; 
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.25         *
*/


-- тест
-- SELECT * FROM gpGet_MemberBirthDay_FileName (inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()

