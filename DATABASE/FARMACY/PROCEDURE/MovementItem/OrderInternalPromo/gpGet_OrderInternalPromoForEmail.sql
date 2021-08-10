-- Function: gpGet_Object_City()

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
  DECLARE vbUserMail TVarChar;
  DECLARE vbUserMailSign TVarChar;
  DECLARE vbSubject TVarChar;
  DECLARE vbZakazName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


   -- еще
   SELECT tmp.InvNumber, tmp.Mail
          INTO vbInvNumber, vbMail
   FROM (WITH  tmpContactPerson AS (SELECT * FROM Object_ContactPerson_View)
         -- Результат
         SELECT Movement.InvNumber
              , COALESCE (View_ContactPerson_0.Mail,          View_ContactPerson_1.Mail,          View_ContactPerson_2.Mail,          View_ContactPerson_3.Mail
                         ) AS Mail
         FROM Movement

              -- Потом ищем по Юр.Лицам
              LEFT JOIN tmpContactPerson AS View_ContactPerson_0
                                                  ON View_ContactPerson_0.JuridicalId         = inJuridicalId
                                                 AND View_ContactPerson_0.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_0.RetailId            = 4
                                                 AND View_ContactPerson_0.AreaId              = zc_Area_Basis()
              LEFT JOIN tmpContactPerson AS View_ContactPerson_1
                                                  ON View_ContactPerson_1.JuridicalId         = inJuridicalId
                                                 AND View_ContactPerson_1.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_1.RetailId            = 4
                                                 AND View_ContactPerson_1.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_2
                                                  ON View_ContactPerson_2.JuridicalId         = inJuridicalId
                                                 AND View_ContactPerson_2.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_2.RetailId            IS NULL
                                                 AND View_ContactPerson_2.AreaId              = inJuridicalId
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_1.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_3
                                                  ON View_ContactPerson_3.JuridicalId         = inJuridicalId
                                                 AND View_ContactPerson_3.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_3.RetailId            IS NULL
                                                 AND View_ContactPerson_3.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_1.JuridicalId IS NULL
                                                 AND View_ContactPerson_2.JuridicalId IS NULL
         WHERE Movement.ID = inMovementId
        ) AS tmp;

   
    -- проверка
    IF COALESCE (vbMail, '') = '' THEN
       RAISE EXCEPTION 'У юридического лица нет контактактных лиц с e-mail';
    END IF;

    -- еще
    SELECT ObjectString.valuedata, ObjectBlob_EMailSign.ValueData
           INTO vbUserMail, vbUserMailSign
    FROM ObjectLink AS User_Link_Member
         LEFT JOIN ObjectString ON ObjectString.descid = zc_ObjectString_Member_EMail()
                               AND ObjectString.ObjectId = User_Link_Member.ChildObjectId
         LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign
                              ON ObjectBlob_EMailSign.ObjectId = User_Link_Member.ChildObjectId
                             AND ObjectBlob_EMailSign.DescId =  zc_ObjectBlob_Member_EMailSign()
    WHERE User_Link_Member.ObjectId = vbUserId AND User_Link_Member.DescId = zc_objectlink_user_member();

    vbSubject := 'Заказ #1#';

    -- еще
    vbMail := (vbMail || vbUserMail) :: TVarChar;

    -- Временно для теста
    vbMail := 'artur17111@gmail.com, olegsh1264@gmail.com';
    
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
SELECT * FROM gpGet_OrderInternalPromoForEmail (inMovementId := 23631157 , inJuridicalId := 59611 , inSession:= '377790');