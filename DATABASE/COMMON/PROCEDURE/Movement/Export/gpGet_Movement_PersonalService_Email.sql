-- Function: gpGet_Movement_PersonalService_Email()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalService_Email (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalService_Email(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port TVarChar, UserName TVarChar, Password TVarChar
              )
AS
$BODY$
   DECLARE vbUserId   Integer;

   DECLARE vbPartnerId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


/*
     -- определяется <Контрагент>
     vbPartnerId:= (SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_From.ObjectId END
                    FROM Movement
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                    WHERE Movement.Id = inMovementId
                   );

     -- проверка
     IF 0 = COALESCE((WITH tmpExportJuridical AS (SELECT DISTINCT tmp.PartnerId FROM lpSelect_Object_ExportJuridical_list() AS tmp)
                      SELECT 1
                      FROM tmpExportJuridical
                      WHERE tmpExportJuridical.PartnerId = vbPartnerId)
                   , 0)
     THEN
         RAISE EXCEPTION 'Ошибка.Данная функция для Контрагента <%> не предусмотрена.'
                       , lfGet_Object_ValueData (vbPartnerId);
     END IF;
*/

     -- Результат
     RETURN QUERY
     WITH
        --данные из установок экспорта
          tmpExportJuridical AS (SELECT ObjectLink_EmailKind.ChildObjectId                  AS EmailKindId
                                      , STRING_AGG (ObjectString_ContactPersonMail.ValueData, ';') AS ContactPersonMail
                                 FROM Object AS Object_ExportJuridical
                                 -- Если есть кому отправлять
                                 INNER JOIN ObjectLink AS ObjectLink_ExportJuridical_ContactPerson 
                                                       ON ObjectLink_ExportJuridical_ContactPerson.ObjectId = Object_ExportJuridical.Id
                                                      AND ObjectLink_ExportJuridical_ContactPerson.DescId = zc_ObjectLink_ExportJuridical_ContactPerson()
                                 INNER JOIN ObjectString AS ObjectString_ContactPersonMail
                                                         ON ObjectString_ContactPersonMail.ObjectId = ObjectLink_ExportJuridical_ContactPerson.ChildObjectId
                                                        AND ObjectString_ContactPersonMail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                        AND ObjectString_ContactPersonMail.ValueData <> ''
                                 -- Если есть откуда отправлять
                                 INNER JOIN ObjectLink AS ObjectLink_EmailKind
                                                       ON ObjectLink_EmailKind.ObjectId = Object_ExportJuridical.Id
                                                      AND ObjectLink_EmailKind.DescId = zc_ObjectLink_ExportJuridical_EmailKind()
                                                      AND ObjectLink_EmailKind.ChildObjectId > 0
                                 -- Если есть формат выгрузки
                                 INNER JOIN ObjectLink AS ObjectLink_ExportJuridical_ExportKind
                                                       ON ObjectLink_ExportJuridical_ExportKind.ObjectId = Object_ExportJuridical.Id
                                                      AND ObjectLink_ExportJuridical_ExportKind.DescId = zc_ObjectLink_ExportJuridical_ExportKind()
                                                      AND ObjectLink_ExportJuridical_ExportKind.ChildObjectId = zc_Enum_ExportKind_PersonalService()

                            WHERE Object_ExportJuridical.DescId = zc_Object_ExportJuridical()
                              AND Object_ExportJuridical.isErased = FALSE
                            GROUP BY ObjectLink_EmailKind.ChildObjectId
                              )
          -- ВСЕ параметры - откуда отправлять, для Одного Покупателя
        , tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= (SELECT DISTINCT tmp.EmailKindId
                                                                                     FROM tmpExportJuridical AS tmp
                                                                                     )
                                                                  , inSession    := inSession)
                                                                   )
     SELECT (tmp.outFileName || '.csv') :: TVarChar AS Subject
          , ''                        :: TBlob    AS Body
          , gpGet_Mail.Value                      AS AddressFrom
          , CASE WHEN vbUserId = 5 AND 1=1 THEN 'ashtu@ua.fm'
                 ELSE tmpExportJuridical.ContactPersonMail || ';ashtu@ua.fm'
            END :: TVarChar AS AddressTo
          , gpGet_Host.Value                     AS Host
          , gpGet_Port.Value                     AS Port
          , gpGet_User.Value                     AS UserName
          , gpGet_Password.Value                 AS Password

     FROM gpGet_PersonalService_FileNameCSV (inMovementId, inSession) AS tmp
          LEFT JOIN tmpExportJuridical ON 1 = 1
          LEFT JOIN tmpEmail AS gpGet_Host      ON gpGet_Host.EmailToolsId      = zc_Enum_EmailTools_Host()
          LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.02.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalService_Email (inMovementId:= 21011498, inSession:= zfCalc_UserAdmin()) -- 
