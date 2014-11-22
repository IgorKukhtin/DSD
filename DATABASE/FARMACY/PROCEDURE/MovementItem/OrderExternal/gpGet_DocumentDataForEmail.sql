-- Function: gpGet_Object_City()

DROP FUNCTION IF EXISTS gpGet_DocumentDataForEmail(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_DocumentDataForEmail(
    IN inId          Integer,       -- ключ объекта <Города>
    IN inSession     TVarChar       -- сессия пользователя
)

RETURNS TABLE (Subject TVarChar, Body TVarChar, AddressFrom TVarChar, AddressTo TVarChar
             , Host TVarChar, Port Integer, UserName TVarChar, Password TVarChar
) AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMail TVarChar;
  DECLARE vbUserMail TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);

   SELECT mail INTO vbMail FROM 
          MovementLinkObject 
  
     JOIN Object_ContactPerson_View ON Object_ContactPerson_View.JuridicalId = ObjectId 

    WHERE DescId = zc_MovementLinkObject_From()
      AND MovementId = inId;

    IF COALESCE(vbMail, '') = '' THEN
       RAISE EXCEPTION 'У юридического лица нет контактактных лиц с e-mail';
    END IF;

    SELECT ObjectString.valuedata INTO vbUserMail 
      FROM ObjectLink AS User_Link_Member 
                    JOIN ObjectString ON ObjectString.descid = zc_ObjectString_Member_EMail()
                     AND ObjectString.ObjectId = User_Link_Member.ChildObjectId
     WHERE User_Link_Member.ObjectId = vbUserId AND User_Link_Member.DescId = zc_objectlink_user_member();
 
    IF COALESCE(vbUserMail, '') = '' THEN 
       vbUserMail := '';
    ELSE
       vbUserMail := ', '||vbUserMail;
    END IF;

    vbMail := (vbMail||vbUserMail)::TVarChar;

       RETURN QUERY
       SELECT
         'А вот и заголовок'::TVarChar, 'Это супер письмо!!!'::TVarChar, 'test@dsd.biz.ua'::TVarChar
       , vbMail, 'dsd.biz.ua'::TVarChar, 25
       , 'test@dsd.biz.ua'::TVarChar, 'testtest'::TVarChar;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_DocumentDataForEmail(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.11.14                         *  

*/

-- тест
-- SELECT * FROM gpGet_Object_City (0, '2')