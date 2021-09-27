-- Function: gpGet_Movement_Export_FileName(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_Export_FileName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Export_FileName(
   OUT outFileNamePrefix      TVarChar  ,
   OUT outFileExt             TVarChar  ,
    IN inMovementId           Integer   ,
    IN inSession              TVarChar
)
  RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     SELECT CASE WHEN ObjectLink_PersonalServiceList_Bank.ChildObjectId = 6314382 -- ПАТ "БАНК ВОСТОК" -- 76968
                  AND ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId = zc_Enum_PSLExportKind_iBank()
                      THEN 'Vostok_'
                 WHEN ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId = zc_Enum_PSLExportKind_iBank()
                      THEN 'Raiffeisen_'
                 WHEN ObjectLink_PersonalServiceList_Bank.ChildObjectId = 76970 -- ПАТ "ОТП БАНК"

                      THEN 'OTP_'
                 ELSE ''
            END AS FileNamePrefix
          , CASE WHEN ObjectLink_PersonalServiceList_Bank.ChildObjectId = 6314382 -- ПАТ "БАНК ВОСТОК"
                  AND ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId = zc_Enum_PSLExportKind_iBank()
                      THEN '.txt'
                 WHEN ObjectLink_PersonalServiceList_PSLExportKind.ChildObjectId = zc_Enum_PSLExportKind_iBank()
                      THEN '.txt'
                 WHEN ObjectLink_PersonalServiceList_Bank.ChildObjectId = 76970 -- ПАТ "ОТП БАНК"
                      THEN '.xml'
                 ELSE '.csv'
            END AS FileExt
            INTO outFileNamePrefix, outFileExt
     FROM Movement
           LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                        ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                       AND MovementLinkObject_PersonalServiceList.DescId = zc_MovementLinkObject_PersonalServiceList()
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Bank
                                ON ObjectLink_PersonalServiceList_Bank.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList_Bank.DescId = zc_ObjectLink_PersonalServiceList_Bank()
           LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PSLExportKind
                                ON ObjectLink_PersonalServiceList_PSLExportKind.ObjectId = MovementLinkObject_PersonalServiceList.ObjectId
                               AND ObjectLink_PersonalServiceList_PSLExportKind.DescId = zc_ObjectLink_PersonalServiceList_PSLExportKind ()
     WHERE Movement.Id = inMovementId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.12.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Export_FileName (inMovementId:= 3376510, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
