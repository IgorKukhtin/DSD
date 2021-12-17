 -- Function: gpGet_Pretension_DataForEmail()

DROP FUNCTION IF EXISTS gpGet_Pretension_DataForEmail(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Pretension_DataForEmail(
    IN inId          Integer,       -- ключ объекта <Претензия>
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
  DECLARE vbSubject TVarChar;
  DECLARE vbUserMailSign TBlob;
  DECLARE vbUnitData TBlob;
  DECLARE vbUnitSign TBlob;
  DECLARE vbJuridicalId_unit Integer;
  DECLARE vbJuridicalName TVarChar;
  DECLARE vbZakazName TVarChar;
  DECLARE vbFromId Integer;
  DECLARE vbStatusId Integer;
  DECLARE vbUserName TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Pretension_Meneger());

   IF COALESCE(inId, 0) = 0 THEN
       RAISE EXCEPTION 'Ошибка.Документ не сохранен.';   
   END IF;

   -- параметры документа
   SELECT
       Movement.StatusId
   INTO
       vbStatusId
   FROM Movement
   WHERE Movement.Id = inId;
   
   -- Создаем проведенных документов
   IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_UnComplete()
   THEN
       RAISE EXCEPTION 'Ошибка.Отправка претензии поставщику в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);   
   END IF;
   
   IF NOT EXISTS(SELECT MI_PretensionFile.Id
             FROM Movement AS Movement_Pretension
                  INNER JOIN MovementItem AS MI_PretensionFile
                                          ON MI_PretensionFile.MovementId = Movement_Pretension.Id
                                         AND MI_PretensionFile.DescId     = zc_MI_Child()

                  INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                ON MIBoolean_Checked.MovementItemId = MI_PretensionFile.Id
                                               AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                               AND MIBoolean_Checked.ValueData = TRUE

             WHERE Movement_Pretension.Id = inId)
   THEN
       RAISE EXCEPTION 'Ошибка.Не сохранен файл акта.%Выполните пункт меню <Формирование Акта по претензии и подключение его к файлам>.', CHR(13)||CHR(13);   
   END IF;

   -- еще
   SELECT tmp.Mail, tmp.JuridicalId_unit, tmp.JuridicalName, tmp.ToId, tmp.InvNumber
          INTO vbMail, vbJuridicalId_unit, vbJuridicalName, vbFromId, vbInvNumber
   FROM (WITH -- Документ Заявка Внешняя (т.е. Поставщику)
              tmpMovement AS (SELECT MLO_To.ObjectId                            AS ToId
                                   , MLO_From.ObjectId                              AS FromId
                                   , ObjectLink_Juridical_Retail.ChildObjectId    AS RetailId
                                   , ObjectLink_Unit_Juridical.ChildObjectId      AS JuridicalId_unit
                                   , ObjectLink_Unit_Area.ChildObjectId           AS AreaId
                                   , Movement.InvNumber                           AS InvNumber
                              FROM MovementLinkObject AS MLO_To
                                   -- !!!только так - определяется <Торговая сеть>!!!
                                   LEFT JOIN MovementLinkObject AS MLO_From
                                                                ON MLO_From.MovementId = MLO_To.MovementId
                                                               AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                        ON ObjectLink_Unit_Area.ObjectId = MLO_From.ObjectId
                                                       AND ObjectLink_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                        ON ObjectLink_Unit_Juridical.ObjectId = MLO_From.ObjectId
                                                       AND ObjectLink_Unit_Juridical.DescId   = zc_ObjectLink_Unit_Juridical()
                                   LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                        ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                       AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                   LEFT JOIN Movement AS Movement
                                                      ON Movement.Id = MLO_To.MovementId
                              WHERE MLO_To.MovementId = inId
                                AND MLO_To.DescId     = zc_MovementLinkObject_To()
                             )
            , tmpContactPerson AS (SELECT * FROM Object_ContactPerson_View)
         -- Результат
         SELECT tmpMovement.JuridicalId_unit
              , tmpMovement.ToId
              , tmpMovement.InvNumber
              , COALESCE (View_ContactPerson_Unit_0.Mail,          View_ContactPerson_Unit_1.Mail,          View_ContactPerson_Unit_2.Mail,          View_ContactPerson_Unit_3.Mail
                        , View_ContactPerson_0.Mail,          View_ContactPerson_1.Mail,          View_ContactPerson_2.Mail,          View_ContactPerson_3.Mail
                         ) AS Mail
              , COALESCE (View_ContactPerson_Unit_0.JuridicalName,          View_ContactPerson_Unit_1.JuridicalName,          View_ContactPerson_Unit_2.JuridicalName,          View_ContactPerson_Unit_3.JuridicalName
                        , View_ContactPerson_0.JuridicalName,          View_ContactPerson_1.JuridicalName,          View_ContactPerson_2.JuridicalName,          View_ContactPerson_3.JuridicalName
                         ) AS JuridicalName
         FROM tmpMovement

              -- Потом ищем по Юр.Лицам + Подразделение
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Unit_0
                                                  ON View_ContactPerson_Unit_0.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_Unit_0.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Unit_0.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_Unit_0.AreaId              = tmpMovement.AreaId
                                                 AND View_ContactPerson_Unit_0.UnitId              = tmpMovement.FromId
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Unit_1
                                                  ON View_ContactPerson_Unit_1.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_Unit_1.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Unit_1.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_Unit_1.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_Unit_1.UnitId              = tmpMovement.FromId
                                                 AND View_ContactPerson_Unit_0.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Unit_2
                                                  ON View_ContactPerson_Unit_2.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_Unit_2.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Unit_2.RetailId            IS NULL
                                                 AND View_ContactPerson_Unit_2.AreaId              = tmpMovement.AreaId
                                                 AND View_ContactPerson_Unit_2.UnitId              = tmpMovement.FromId
                                                 AND View_ContactPerson_Unit_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_Unit_1.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_Unit_3
                                                  ON View_ContactPerson_Unit_3.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_Unit_3.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_Unit_3.RetailId            IS NULL
                                                 AND View_ContactPerson_Unit_3.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_Unit_3.UnitId              = tmpMovement.FromId
                                                 AND View_ContactPerson_Unit_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_Unit_1.JuridicalId IS NULL
                                                 AND View_ContactPerson_Unit_2.JuridicalId IS NULL

              -- Потом ищем по Юр.Лицам
              LEFT JOIN tmpContactPerson AS View_ContactPerson_0
                                                  ON View_ContactPerson_0.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_0.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_0.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_0.AreaId              = tmpMovement.AreaId
                                                 AND View_ContactPerson_0.UnitId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_1
                                                  ON View_ContactPerson_1.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_1.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_1.RetailId            = tmpMovement.RetailId
                                                 AND View_ContactPerson_1.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_1.UnitId IS NULL
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_2
                                                  ON View_ContactPerson_2.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_2.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_2.RetailId            IS NULL
                                                 AND View_ContactPerson_2.AreaId              = tmpMovement.AreaId
                                                 AND View_ContactPerson_2.UnitId IS NULL
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_1.JuridicalId IS NULL
              LEFT JOIN tmpContactPerson AS View_ContactPerson_3
                                                  ON View_ContactPerson_3.JuridicalId         = tmpMovement.ToId
                                                 AND View_ContactPerson_3.ContactPersonKindId = zc_Enum_ContactPersonKind_Pretension() -- хотя не понятно чем отличается от zc_Enum_ContactPersonKind_CreateOrder
                                                 AND View_ContactPerson_3.RetailId            IS NULL
                                                 AND View_ContactPerson_3.AreaId              = zc_Area_Basis()
                                                 AND View_ContactPerson_3.UnitId IS NULL
                                                 AND View_ContactPerson_0.JuridicalId IS NULL
                                                 AND View_ContactPerson_1.JuridicalId IS NULL
                                                 AND View_ContactPerson_2.JuridicalId IS NULL
        ) AS tmp;
   
   -- еще
   SELECT Object_Unit_view.JuridicalName
       || ' от ' || Object_Unit_view.Name AS ZakazName
        , ''/*SomeText*/                        AS UnitSign
        , MovementLinkObject.ObjectId     AS UnitId
          INTO vbZakazName
             , vbUnitSign
             , vbUnitId
   FROM MovementLinkObject
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = ObjectId
                                              AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_UnitEmailSign()
        LEFT JOIN Object_Unit_view ON Object_Unit_view.id = MovementLinkObject.ObjectId

   WHERE MovementLinkObject.DescId = zc_MovementLinkObject_From()
     AND MovementId = inId;

   -- еще
   SELECT Movement.InvNumber, Object_ImportExportLink_View.StringKey
          INTO vbInvNumber, vbSubject
   FROM MovementLinkObject
        LEFT JOIN Movement ON Movement.Id = MovementLinkObject.MovementId
        LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = vbUnitId
                                              AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_ClientEmailSubject()
                                              AND Object_ImportExportLink_View.ValueId = ObjectId
   WHERE MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
     AND MovementLinkObject.MovementId = inId;
       
   IF COALESCE(vbSubject, '') = '' THEN
     SELECT Movement.InvNumber, Object_ImportExportLink_View.StringKey
            INTO vbInvNumber, vbSubject
     FROM MovementLinkObject
          LEFT JOIN Movement ON Movement.Id = MovementLinkObject.MovementId
          LEFT JOIN Object_ImportExportLink_View ON Object_ImportExportLink_View.MainId = vbUnitId
                                                AND Object_ImportExportLink_View.LinkTypeId = zc_Enum_ImportExportLinkType_ClientEmailSubject()
                                                AND Object_ImportExportLink_View.ValueId = ObjectId
     WHERE MovementLinkObject.DescId = zc_MovementLinkObject_To()
       AND MovementLinkObject.MovementId = inId;
   END IF;

    -- проверка
    IF inSession = '3'
    THEN
       vbMail := 'olegsh1264@gmail.com';
    ELSEIF COALESCE (vbMail, '') = '' THEN
       RAISE EXCEPTION 'У юридического лица нет контактактных лиц с e-mail';
    END IF;


    -- еще
    SELECT ObjectString.valuedata
         , ObjectBlob_EMailSign.ValueData||COALESCE(', '||ObjectString.valuedata, '')
         , COALESCE(Object_MemberUser.ValueData, '')||
           COALESCE(', тел. '||ObjectString_Member_Phone.ValueData, '')||
           COALESCE(', E-Mail '||ObjectString.ValueData, '')            AS UserName
    INTO vbUserMail, vbUserMailSign, vbUserName
    FROM ObjectLink AS User_Link_Member
         LEFT JOIN Object AS Object_MemberUser ON Object_MemberUser.Id = User_Link_Member.ChildObjectId
         LEFT JOIN ObjectString ON ObjectString.descid = zc_ObjectString_Member_EMail()
                               AND ObjectString.ObjectId = User_Link_Member.ChildObjectId
         LEFT JOIN ObjectString AS ObjectString_Member_Phone
                                ON ObjectString_Member_Phone.ObjectId = User_Link_Member.ChildObjectId
                               AND ObjectString_Member_Phone.DescId = zc_ObjectString_Member_Phone()
         LEFT JOIN ObjectBlob AS ObjectBlob_EMailSign
                              ON ObjectBlob_EMailSign.ObjectId = User_Link_Member.ChildObjectId
                             AND ObjectBlob_EMailSign.DescId =  zc_ObjectBlob_Member_EMailSign()
    WHERE User_Link_Member.ObjectId = vbUserId 
      AND User_Link_Member.DescId = zc_objectlink_user_member()
      AND vbUserId <> 3;


    -- еще
    IF COALESCE(vbUserMail, '') = '' THEN
       vbUserMail := '';       
    ELSE
       vbUserMail := ','||vbUserMail;
    END IF;

    -- еще
    IF COALESCE(vbSubject, '') = '' THEN
       vbSubject := ('Претензия ' || vbJuridicalName || ' от - ' || COALESCE (vbZakazName, '')) :: TVarChar;

    END IF;

    -- еще
    vbMail := (vbMail || vbUserMail) :: TVarChar;
    
    SELECT CASE WHEN COALESCE(ObjectString_Unit_Address.ValueData, '') <> '' THEN 'Адрес аптеки: '||ObjectString_Unit_Address.ValueData||CHR (13) ELSE '' END ||
           CASE WHEN COALESCE(ObjectString_Unit_Phone.ValueData, '') <> '' THEN 'Телефоны аптеки: '||ObjectString_Unit_Phone.ValueData||CHR (13) ELSE '' END ||
           COALESCE('Время работы: '||
            (CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00'
                  THEN 'Пн-Пт '||LEFT ((ObjectDate_MondayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_MondayEnd.ValueData::Time)::TVarChar,5)||'; '
                  ELSE ''
             END||'' ||
             CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00'
                  THEN 'Сб '||LEFT ((ObjectDate_SaturdayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SaturdayEnd.ValueData::Time)::TVarChar,5)||'; '
                  ELSE ''
             END||''||
             CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00'
                  THEN 'Вс '||LEFT ((ObjectDate_SundayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SundayEnd.ValueData::Time)::TVarChar,5)
                  ELSE ''
             END), '')||
             CASE WHEN COALESCE(ObjectString_Unit_PharmacyManager.ValueData, '') <> '' THEN CHR (13)||'ФИО Зав. аптекой: '||ObjectString_Unit_PharmacyManager.ValueData ELSE '' END
    INTO vbUnitData
    FROM Object AS Object_Unit

            LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                   ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                                   ON ObjectString_Unit_Phone.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()
            LEFT JOIN ObjectString AS ObjectString_Unit_PharmacyManager
                                   ON ObjectString_Unit_PharmacyManager.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_PharmacyManager.DescId = zc_ObjectString_Unit_PharmacyManager()

            LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                                 ON ObjectDate_MondayStart.ObjectId = Object_Unit.Id
                                AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
            LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                                 ON ObjectDate_MondayEnd.ObjectId = Object_Unit.Id
                                AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                                 ON ObjectDate_SaturdayStart.ObjectId = Object_Unit.Id
                                AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
            LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                                 ON ObjectDate_SaturdayEnd.ObjectId = Object_Unit.Id
                                AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                                 ON ObjectDate_SundayStart.ObjectId = Object_Unit.Id
                                AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
            LEFT JOIN ObjectDate AS ObjectDate_SundayEnd 
                                 ON ObjectDate_SundayEnd.ObjectId = Object_Unit.Id
                                AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()
            LEFT JOIN ObjectDate AS ObjectDate_FirstCheck
                                 ON ObjectDate_FirstCheck.ObjectId = Object_Unit.Id
                                AND ObjectDate_FirstCheck.DescId = zc_ObjectDate_Unit_FirstCheck()
                                
    WHERE Object_Unit.Id = vbUnitId;

    -- Результат
    RETURN QUERY
       WITH tmpEmail_all AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailId:= 0, inIsShowAll:= FALSE, inSession:= inSession) AS tmp WHERE tmp.EmailKindId = zc_Enum_EmailKind_OutPretension())
          , tmpEmail_jur AS (SELECT * FROM tmpEmail_all WHERE JuridicalId = vbJuridicalId_unit)
          , tmpEmail AS (SELECT * FROM tmpEmail_jur UNION ALL SELECT * FROM tmpEmail_all WHERE COALESCE (JuridicalId, 0) = 0 AND NOT EXISTS (SELECT 1 FROM tmpEmail_jur))
       SELECT
         -- Тема
         REPLACE (vbSubject, '#1#', '#' || vbInvNumber || '#') :: TVarChar AS Subject

         -- Body 
       , ('<b>ВНИМАНИЕ !!! Ящик  '||gpGet_User.Value||'  работает в авторежиме.  Не отсылайте на него ответ. Он не будет прочитан. Ящик для переписки указан ниже в контактах менеджера.</b>'|| CHR (13) || CHR (13) ||
         'Добрый день.'|| CHR (13) ||
         'Информация по претензии во вложении.'|| CHR (13)|| CHR (13) ||
         'Ждем ответа от Вас.'|| CHR (13)|| CHR (13) ||
         'По вопросам подачи претензии, просьба обращаться к '|| COALESCE (vbUserName, '')|| CHR (13) || CHR (13) ||
         'P.S. Ниже данные точки, по которой подаётся данная претензия'|| CHR (13) || CHR (13) ||       
         CASE WHEN COALESCE (vbUnitData, '') <> '' THEN vbUnitData|| CHR (13) || CHR (13) ELSE '' END ||
         COALESCE (vbUnitSign, '') || '<br>' || COALESCE ('<b>'||vbUserMailSign||'</b>', '')) :: TBlob AS Body

         -- Body
       , gpGet_Mail.Value            AS AddressFrom     --*** zc_Mail_From() --'zakaz_family-neboley@mail.ru'::TVarChar,
       , vbMail                      AS AddressTo
       , gpGet_Host.Value            AS Host          --*** zc_Mail_Host(), --'smtp.mail.ru'::TVarChar,
       , gpGet_Port.Value :: Integer AS Port          --*** zc_Mail_Port(), --465,
       , gpGet_User.Value            AS UserName      --*** zc_Mail_User(), --'zakaz_family-neboley@mail.ru'::TVarChar,
       , gpGet_Password.Value        AS Password      --*** zc_Mail_Password() --'fgntrfyt,jktq'::TVarChar;

       FROM tmpEmail AS gpGet_Host
            LEFT JOIN tmpEmail AS gpGet_Port      ON gpGet_Port.EmailToolsId      = zc_Enum_EmailTools_Port()
            LEFT JOIN tmpEmail AS gpGet_Mail      ON gpGet_Mail.EmailToolsId      = zc_Enum_EmailTools_Mail()
            LEFT JOIN tmpEmail AS gpGet_User      ON gpGet_User.EmailToolsId      = zc_Enum_EmailTools_User()
            LEFT JOIN tmpEmail AS gpGet_Password  ON gpGet_Password.EmailToolsId  = zc_Enum_EmailTools_Password()
     WHERE gpGet_Host.EmailToolsId = zc_Enum_EmailTools_Host()
    ;

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
-- 
--
SELECT * From gpGet_Pretension_DataForEmail (inId:= 26120242     , inSession:= '183242');