-- Function: gpGet_Movement_XML_Email()

DROP FUNCTION IF EXISTS gpGet_Movement_XML_Email (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_XML_Email(
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port Integer, UserName TVarChar, Password TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF NOT EXISTS (SELECT 1
                    FROM MovementLinkObject AS MovementLinkObject_To
                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                              ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                              AND ObjectLink_Juridical_Retail.ChildObjectId = 518060 -- МИДА -- !!!ВРЕМЕННО!!!
                    WHERE MovementLinkObject_To.MovementId = inMovementId
                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To())
     THEN
         RAISE EXCEPTION 'Ошибка.Данная функция предусмотрена только для торговой сети <%>.', lfGet_Object_ValueData (518060);
     END IF;

     -- Результат
     RETURN QUERY
     SELECT tmp.outFileName          :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , '24447183@ukr.net'       :: TVarChar AS AddressFrom
          , 'ashtu777@ua.fm'            :: TVarChar AS AddressTo
          , 'smtp.ukr.net'           :: TVarChar AS Host
          , 465                      :: Integer  AS Port
          , '24447183@ukr.net'       :: TVarChar AS UserName
          , 'vas6ok'                 :: TVarChar AS Password -- '24447183'

     FROM gpGet_Movement_XML_FileName (inMovementId, inSession) AS tmp;
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
/*
     RETURN QUERY
     SELECT tmp.outFileName          :: TVarChar AS Subject
          , ''                       :: TBlob    AS Body
          , 'ashtu777@gmail.com'     :: TVarChar AS AddressFrom
          , 'ashtu@ua.fm'            :: TVarChar AS AddressTo
          , 'smtp.gmail.com'         :: TVarChar AS Host
          , 465                      :: Integer  AS Port
          , 'ashtu777@gmail.com'     :: TVarChar AS UserName
          , 'Fktrc123'               :: TVarChar AS Password
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
-- SELECT * FROM gpGet_Movement_XML_Email (inMovementId:= 3229861, inSession:= zfCalc_UserAdmin())
