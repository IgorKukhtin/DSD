-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_DocumentDataForEmail(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_DocumentDataForEmail(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS TABLE (Subject TVarChar, Body TBlob, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port Integer, UserName TVarChar, Password TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMail TVarChar;
  DECLARE vbUserMail TVarChar;
  DECLARE vbUserMailSign TBlob;
  DECLARE vbUnitSign TBlob;
  DECLARE vbZakazName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);

   SELECT mail INTO vbMail FROM 
          MovementLinkObject 
  
     JOIN Object_ContactPerson_View ON Object_ContactPerson_View.JuridicalId = ObjectId 

    WHERE DescId = zc_MovementLinkObject_From()
      AND MovementId = inId;

   SELECT object_unit_view.juridicalname||' от '||object_unit_view.name, SomeText INTO vbZakazName, vbUnitSign 
      FROM 
          MovementLinkObject 
    LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = ObjectId 
                                     AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitEmailSign()
    LEFT JOIN object_unit_view ON object_unit_view.id = MovementLinkObject.ObjectId                                 
    

    WHERE MovementLinkObject.DescId = zc_MovementLinkObject_To()
      AND MovementId = inId;

    IF COALESCE(vbMail, '') = '' THEN
       RAISE EXCEPTION 'У юридического лица нет контактактных лиц с e-mail';
    END IF;

    SELECT ObjectString.valuedata, ObjectBlob_EMailSign.ValueData INTO vbUserMail, vbUserMailSign
      FROM ObjectLink AS User_Link_Member 
               LEFT JOIN ObjectString ON ObjectString.descid = zc_ObjectString_Member_EMail()
                     AND ObjectString.ObjectId = User_Link_Member.ChildObjectId
             LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign 
                                  ON ObjectBlob_EMailSign.ObjectId = User_Link_Member.ChildObjectId
                                 AND ObjectBlob_EMailSign.DescId =  zc_ObjectBlob_Member_EMailSign()
     WHERE User_Link_Member.ObjectId = vbUserId AND User_Link_Member.DescId = zc_objectlink_user_member();
 
    IF COALESCE(vbUserMail, '') = '' THEN 
       vbUserMail := '';
    ELSE
       vbUserMail := ', '||vbUserMail;
    END IF;

    vbMail := (vbMail||vbUserMail)::TVarChar;

       RETURN QUERY
       SELECT
         ('Заказ - '||COALESCE(vbZakazName, ''))::TVarChar, (COALESCE(vbUnitSign, '')||'<br>'||COALESCE(vbUserMailSign, ''))::TBlob, 'zakaz_family-neboley@mail.ru'::TVarChar
       , vbMail, 'smtp.mail.ru'::TVarChar, 465
       , 'zakaz_family-neboley@mail.ru'::TVarChar, 'fgntrfyt,jktq'::TVarChar;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_DocumentDataForEmail(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 24.12.14                         *  
 18.11.14                         *  

*/

-- тест
--             
select * FROM  gpGet_DocumentDataForEmail(inId := 9941,  inSession := '377790');