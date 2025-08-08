-- Function: gpGet_Movement_VN_scv_FileName(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_VN_scv_FileName (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_VN_scv_FileName (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_VN_scv_FileName(
   OUT outFileName            TVarChar  ,
    IN inStartDate            TDateTime , --
    IN inEndDate              TDateTime , --
    IN inSession              TVarChar
)
  RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     SELECT tmp.outFileName
            INTO outFileName
     FROM
         (SELECT   'VN_'|| zfConvert_DateToString (inStartDate)||'_'||zfConvert_DateToString(inEndDate)||' '
                 ||(zfConvert_DateToString (CURRENT_TIMESTAMP)
                 || ' ' || CASE WHEN EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) < 10 THEN '0' ELSE '' END || EXTRACT (HOUR   FROM CURRENT_TIMESTAMP) :: TVarChar
                 || '_' || CASE WHEN EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) < 10 THEN '0' ELSE '' END || EXTRACT (MINUTE FROM CURRENT_TIMESTAMP) :: TVarChar
                    ) ::TVarChar
                 ||' '
                 ||(SELECT zfConvert_FIO(ValueData, 1, TRUE) FROM Object WHERE Id = vbUserId) ::TVarChar AS outFileName
     
               , 'csv' AS outDefaultFileExt
          ) AS tmp
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.25         *
*/


-- тест
-- SELECT * FROM gpGet_Movement_VN_scv_FileName (inStartDate := '01.02.2025', inEndDate:= '03.02.2025', inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
