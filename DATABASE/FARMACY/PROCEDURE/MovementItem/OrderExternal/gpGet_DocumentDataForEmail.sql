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

  DECLARE vbUnitId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbMail TVarChar;
  DECLARE vbUserMail TVarChar;
  DECLARE vbSubject TVarChar;
  DECLARE vbUserMailSign TBlob;
  DECLARE vbUnitSign TBlob;
  DECLARE vbJuridicalName TVarChar;
  DECLARE vbZakazName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId := lpGetUserBySession (inSession);


   -- еще
   SELECT tmp.Mail, tmp.JuridicalName
          INTO vbMail, vbJuridicalName
   FROM (WITH tmpMovement AS (SELECT MLO_From.ObjectId AS FromId, ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                              FROM MovementLinkObject AS MLO_From
                                   -- !!!только так - определяется <Торговая сеть>!!!
                                   LEFT JOIN MovementLinkObject AS MLO_To
                                                                ON MLO_To.MovementId = MLO_From.MovementId
                                                               AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                        ON ObjectLink_Unit_Juridical.ObjectId = MLO_To.ObjectId
                                                       AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                                   LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                        ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                       AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                              WHERE MLO_From.MovementId = inId
                                AND MLO_From.DescId     = zc_MovementLinkObject_From()
                             )
         SELECT COALESCE (View_ContactPerson.Mail,          View_ContactPerson_two.Mail)          AS Mail
              , COALESCE (View_ContactPerson.JuridicalName, View_ContactPerson_two.JuridicalName) AS JuridicalName
         FROM tmpMovement
              LEFT JOIN Object_ContactPerson_View AS View_ContactPerson
                                                  ON View_ContactPerson.JuridicalId         = tmpMovement.FromId
                                                 AND View_ContactPerson.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson.RetailId            = tmpMovement.RetailId
              LEFT JOIN Object_ContactPerson_View AS View_ContactPerson_two
                                                  ON View_ContactPerson_two.JuridicalId         = tmpMovement.FromId
                                                 AND View_ContactPerson_two.ContactPersonKindId = zc_Enum_ContactPersonKind_ProcessOrder() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson.JuridicalId IS NULL
        ) AS tmp;


   -- еще
   SELECT object_unit_view.juridicalname||' от '||object_unit_view.name, SomeText, MovementLinkObject.ObjectId INTO vbZakazName, vbUnitSign, vbUnitId 
   FROM MovementLinkObject 
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = ObjectId 
                                              AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitEmailSign()
        LEFT JOIN object_unit_view ON object_unit_view.id = MovementLinkObject.ObjectId                                 
 
   WHERE MovementLinkObject.DescId = zc_MovementLinkObject_To()
     AND MovementId = inId;

   -- еще
   SELECT Object_ImportExportLink_View.StringKey INTO vbSubject
   FROM MovementLinkObject 
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = vbUnitId
                                              AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_ClientEmailSubject()
                                              AND Object_ImportExportLink_View.ValueId = ObjectId  
   WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
     AND MovementId = inId;


    -- проверка
    IF COALESCE(vbMail, '') = '' THEN
       RAISE EXCEPTION 'У юридического лица нет контактактных лиц с e-mail';
    END IF;

    -- еще
    SELECT ObjectString.valuedata, ObjectBlob_EMailSign.ValueData INTO vbUserMail, vbUserMailSign
    FROM ObjectLink AS User_Link_Member 
         LEFT JOIN ObjectString ON ObjectString.descid = zc_ObjectString_Member_EMail()
                               AND ObjectString.ObjectId = User_Link_Member.ChildObjectId
         LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign 
                              ON ObjectBlob_EMailSign.ObjectId = User_Link_Member.ChildObjectId
                             AND ObjectBlob_EMailSign.DescId =  zc_ObjectBlob_Member_EMailSign()
    WHERE User_Link_Member.ObjectId = vbUserId AND User_Link_Member.DescId = zc_objectlink_user_member();
 

    -- еще
    IF COALESCE(vbUserMail, '') = '' THEN 
       vbUserMail := '';
    ELSE
       vbUserMail := ', '||vbUserMail;
    END IF;
    
    -- еще
    IF COALESCE(vbSubject, '') = '' THEN 
       vbSubject := ('Заказ '||vbJuridicalName||' от - '||COALESCE(vbZakazName, ''))::TVarChar;
    END IF;
    

    -- еще
    vbMail := (vbMail||vbUserMail)::TVarChar;

       -- Результат
       RETURN QUERY
       WITH tmpComment AS (SELECT MS_Comment.ValueData AS Comment FROM MovementString AS MS_Comment WHERE MS_Comment.MovementId = inId AND MS_Comment.DescId = zc_MovementString_Comment())
       SELECT
         vbSubject, 
         (CASE WHEN (SELECT Comment FROM tmpComment) <> ''
                    THEN 'ПРИМЕЧАНИЕ ВАЖНО : ' || (SELECT Comment FROM tmpComment) || CHR (13) || CHR (13) || CHR (13) || CHR (13) || CHR (13)
               ELSE ''
         END
      || COALESCE (vbUnitSign, '') || '<br>' || COALESCE (vbUserMailSign, '')) :: TBlob AS Body,
         zc_Mail_From(), --'zakaz_family-neboley@mail.ru'::TVarChar, 
         vbMail, 
         zc_Mail_Host(), --'smtp.mail.ru'::TVarChar, 
         zc_Mail_Port(), --465, 
         zc_Mail_User(), --'zakaz_family-neboley@mail.ru'::TVarChar, 
         zc_Mail_Password(); --'fgntrfyt,jktq'::TVarChar;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.03.16                                        *  
 14.01.15                         *  
 24.12.14                         *  
 18.11.14                         *  
*/

-- тест
-- SELECT * FROM gpGet_DocumentDataForEmail (inId:= 2057341, inSession:= '377790');
