-- Function: gpGet_Movement_Email_Send()

-- DROP FUNCTION IF EXISTS gpGet_Movement_XML_Email (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Email_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Email_Send(
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


/*if inMovementId = 27974591 
then 
    vbUserId:= 5;
end if;*/


if vbUserId <> 5 AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка.Нет прав.';
END IF;

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
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Данная функция для Контрагента <%> не предусмотрена.'
                       , lfGet_Object_ValueData (vbPartnerId);
     END IF;

     -- Результат
     RETURN QUERY
     WITH -- Один Покупатель
          tmpPartnerTo AS (SELECT vbPartnerId AS PartnerId)
          -- ВСЕ, кому надо отправить Email
        , tmpExportJuridical AS (SELECT tmp.PartnerId, tmp.EmailKindId, STRING_AGG (tmp.ContactPersonMail, ';') AS ContactPersonMail FROM lpSelect_Object_ExportJuridical_list() AS tmp GROUP BY tmp.PartnerId, tmp.EmailKindId)
          -- Недавній ФОП- формат XLS
        , tmpExport_XLS AS (SELECT DISTINCT tmp.PartnerId, tmp.EmailKindId, '' AS ContactPersonMail FROM lpSelect_Object_ExportJuridical_list() AS tmp WHERE tmp.Id = 7448983 LIMIT 1)
          -- ВСЕ параметры - откуда отправлять, для Одного Покупателя
        , tmpEmail_from AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= COALESCE ((SELECT tmp.EmailKindId
                                                                                                    FROM tmpPartnerTo
                                                                                                         INNER JOIN (SELECT DISTINCT tmpExportJuridical.PartnerId, tmpExportJuridical.EmailKindId FROM tmpExportJuridical) AS tmp ON tmp.PartnerId = tmpPartnerTo.PartnerId
                                                                                                   )
                                                                                                 , (SELECT tmpExport_XLS.EmailKindId FROM tmpExport_XLS)
                                                                                                  )
                                                                       , inSession    := inSession)
                                                                        )
     SELECT CASE WHEN tmp.outExportKindId = zc_Enum_ExportKind_Glad2514900150()
                      THEN tmp.outFileName || '.xml'
                 WHEN tmp.outExportKindId IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110())
                      THEN tmp.outFileName || '.xls'
                 ELSE tmp.outFileName
            END :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , gpGet_Mail.Value                     AS AddressFrom
          -- , tmpExportJuridical.ContactPersonMail :: TVarChar AS AddressTo
          , CASE WHEN vbUserId = 5    AND 1=1 THEN 'ashtu@ua.fm' 
                 WHEN vbUserId = 9457 AND 1=1 THEN 'innafelon@gmail.com' 
               --WHEN tmp.outExportKindId IN (zc_Enum_ExportKind_Logistik41750857(), zc_Enum_ExportKind_Nedavn2244900110()) THEN 'ashtu@ua.fm'
               --WHEN vbUserId = 1329039 AND 1=1 THEN 'ashtu@ua.fm'

                 WHEN tmpExportJuridical.ContactPersonMail <> '' THEN tmpExportJuridical.ContactPersonMail || ';24447183@ukr.net' -- || ';ashtu@ua.fm' 

                 ELSE '24447183@ukr.net' -- || ';ashtu@ua.fm' 
            END :: TVarChar AS AddressTo

          , gpGet_Host.Value                     AS Host
          , gpGet_Port.Value                     AS Port
          , gpGet_User.Value                     AS UserName
          , gpGet_Password.Value                 AS Password

     FROM gpGet_Movement_Email_FileName (inMovementId, inSession) AS tmp
          LEFT JOIN tmpPartnerTo ON tmpPartnerTo.PartnerId > 0
          LEFT JOIN tmpExportJuridical ON tmpExportJuridical.PartnerId = tmpPartnerTo.PartnerId
          LEFT JOIN tmpExport_XLS ON 1=1
          LEFT JOIN tmpEmail_from AS gpGet_Host      ON gpGet_Host.EmailToolsId      = zc_Enum_EmailTools_Host()
          LEFT JOIN tmpEmail_from AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
          LEFT JOIN tmpEmail_from AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
          LEFT JOIN tmpEmail_from AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
          LEFT JOIN tmpEmail_from AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
    ;
/*     SELECT tmp.outFileName                      :: TVarChar AS Subject
          , ''                                   :: TBlob    AS Body
          , 'nikolaev.filial.alan@gmail.com'     :: TVarChar AS AddressFrom
          , 'MIDA@KIVIT.COM.UA'                  :: TVarChar AS AddressTo
          , 'smtp.gmail.com'                     :: TVarChar AS Host
          , 465                                  :: Integer  AS Port
          , 'nikolaev.filial.alan@gmail.com'     :: TVarChar AS UserName
          , 'nikolaevfilialalan'                 :: TVarChar AS Password -- '24447183'

     FROM gpGet_Movement_XML_FileName (inMovementId, inSession) AS tmp;
     SELECT tmp.outFileName          :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , '24447183@ukr.net'       :: TVarChar AS AddressFrom
          , 'ashtu777@ua.fm'         :: TVarChar AS AddressTo
          , 'smtp.ukr.net'           :: TVarChar AS Host
          , 465                      :: Integer  AS Port
          , '24447183@ukr.net'       :: TVarChar AS UserName
          , 'vas6ok'                 :: TVarChar AS Password -- '24447183'

     FROM gpGet_Movement_XML_FileName (inMovementId, inSession) AS tmp;*/
/*
     SELECT tmp.outFileName          :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , 'mail_out_in@alan.dp.ua' :: TVarChar AS AddressFrom
          , 'ashtu@ua.fm' :: TVarChar AS AddressTo
          , 'smtp.alan.dp.ua'        :: TVarChar AS Host
          , 25                       :: Integer  AS Port
          , 'mail_out_in'            :: TVarChar AS UserName
          , 'vas6ok'                 :: TVarChar AS Password
     FROM gpGet_Movement_XML_FileName (inMovementId, inSession) AS tmp;
*/


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.02.16                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Email_Send (inMovementId:= 3376510, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Mida35273055()
-- SELECT * FROM gpGet_Movement_Email_Send (inMovementId:= 3252496, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Vez37171990()
-- SELECT * FROM gpGet_Movement_Email_Send (inMovementId:= 19712391, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Glad2514900150()
-- SELECT * FROM gpGet_Movement_Email_Send (inMovementId:= 19371076, inSession:= zfCalc_UserAdmin()) -- zc_Enum_ExportKind_Logistik41750857()
