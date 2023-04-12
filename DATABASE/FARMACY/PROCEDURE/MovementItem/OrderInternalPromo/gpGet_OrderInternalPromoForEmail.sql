-- Function: gpGet_OrderInternalPromoForEmail()

DROP FUNCTION IF EXISTS gpGet_OrderInternalPromoForEmail(integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OrderInternalPromoForEmail(
    IN inMovementId  Integer,       -- ключ объекта <Города>
    IN inJuridicalId Integer      , -- Поставщик
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port Integer, UserName TVarChar, Password TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbInvNumber TVarChar;
  DECLARE vbMail TVarChar;
  DECLARE vbSubject TVarChar;
  DECLARE vbZakazName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


   -- еще
   SELECT Movement.InvNumber
   INTO vbInvNumber
   FROM Movement
   WHERE Movement.ID = inMovementId;

   -- Юр. лица надо добавлять и в gpSelect_MovementItem_OrderInternalPromo_ExportJuridical
    
   vbMail := CASE WHEN inJuridicalId = 59611  THEN 'VPikush@optimapharm.ua'                                -- СП "Оптима-Фарм, ЛТД"
                  WHEN inJuridicalId = 59610 THEN 'centr2_cc@badm.biz'                                     -- БаДМ
                  WHEN inJuridicalId = 59612 THEN 'volitskayairina@ventaltd.com.ua'                        -- Вента
                  WHEN inJuridicalId = 183353 THEN 'n.ivanova@fitolek.com'                                 -- Фито-лек
                  WHEN inJuridicalId = 410822 THEN 'zakaz@ametrin.com.ua'                                  -- Аметрин 
                  WHEN inJuridicalId = 183319 THEN 'elhovskiy.a@dolphi.com.ua'                             -- Долфи Украина
                  WHEN inJuridicalId = 183332 THEN 'Ihor.Loboda@uf.ua'                                     -- Медцентр М.Т.К.
                  WHEN inJuridicalId = 18926945 THEN 'bpa@konex.com.ua'                                    -- Конекс
                  ELSE '' END;          
   
    -- проверка
    IF COALESCE (vbMail, '') = '' THEN
       RAISE EXCEPTION 'У юридического лица нет контактактных лиц с e-mail';
    END IF;


    vbSubject := 'Заказ #1#';

    -- еще
    vbMail := (vbMail || ',artur17111@gmail.com' || ',alexandra.p2009@gmail.com' || ',semya.neboley@gmail.com,novokr@neboley.dp.ua,kirova@neboley.dp.ua') :: TVarChar;

    -- Временно для теста
    IF vbUserId = 3
    THEN
      vbMail := 'olegsh1264@gmail.com,palladino27@gmail.com';
    END IF;
    
    -- Результат
    RETURN QUERY
       WITH tmpComment AS (SELECT MS_Comment.ValueData AS Comment FROM MovementString AS MS_Comment WHERE MS_Comment.MovementId = inMovementId AND MS_Comment.DescId = zc_MovementString_Comment())
          , tmpEmail AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.EmailKindId = zc_Enum_EmailKind_OutOrder())
       SELECT
         -- Тема
         REPLACE (vbSubject, '#1#', '#' || vbInvNumber || '#') :: TVarChar AS Subject

         -- Body
       , ' ' :: TBlob AS Body

         -- Body
       , zc_Mail_From()              AS AddressFrom   
       , vbMail                      AS AddressTo
       
       , zc_Mail_Host():: TVarChar AS Host
       , zc_Mail_Port():: Integer AS Port
       , zc_Mail_User():: TVarChar AS UserName
       , zc_Mail_Password():: TVarChar AS Password
       
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.08.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpGet_OrderInternalPromoForEmail (inMovementId := 24671713  , inJuridicalId := 410822 , inSession:= '3');