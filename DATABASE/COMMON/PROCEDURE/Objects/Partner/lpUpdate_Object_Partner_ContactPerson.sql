-- Function: lpUpdate_Object_Partner_ContactPerson()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_ContactPerson (Integer
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , Integer);

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_ContactPerson (Integer
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar, TVarChar, TVarChar
                                                             , TVarChar);


CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_ContactPerson(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 

    IN inOrderName           TVarChar  ,    -- заказы
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inDocName             TVarChar  ,    -- первичка
    IN inDocPhone            TVarChar  ,    --
    IN inDocMail             TVarChar  ,    --

    IN inActName             TVarChar  ,    -- Акты
    IN inActPhone            TVarChar  ,    --
    IN inActMail             TVarChar  ,    --
    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbContactPersonId Integer;
   DECLARE vbContactPersonKindId Integer;
BEGIN
 
  -- Контактные лица 
  -- Заявки
   IF inOrderName <> '' THEN
      -- проверка
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CreateOrder();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inOrderPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inOrderMail

                                JOIN ObjectLink AS ObjectLink_ContactPerson_Object
                                                ON ObjectLink_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                               AND ObjectLink_ContactPerson_Object.ChildObjectId = inId

                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inOrderName
                           );
      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inOrderName, inOrderPhone, inOrderMail, '', inId, 0, 0, 0, vbContactPersonKindId, 0, 0, inSession);
      END IF;
      -- обнуление у остальных
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContactPerson_Object(), ObjectLink_ContactPerson_Object.ObjectId, NULL)
      FROM ObjectLink AS ObjectLink_ContactPerson_Object
           INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = ObjectLink_ContactPerson_Object.ObjectId
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
      WHERE ObjectLink_ContactPerson_Object.ChildObjectId = inId
        AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
        AND ObjectLink_ContactPerson_Object.ObjectId <> vbContactPersonId;

   ELSE IF TRIM (inOrderPhone) <> '' OR TRIM (inOrderMail) <> ''
        THEN RAISE EXCEPTION 'Ошибка. не заполнена ячейка <Заказ ФИО>';
        END IF;
   END IF;

 -- Первичка
   IF inDocName <> '' THEN
      -- проверка
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CheckDocument();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inDocPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inDocMail
                                                            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_Object
                                                ON ObjectLink_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                               AND ObjectLink_ContactPerson_Object.ChildObjectId = inId

                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inDocName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inDocName, inDocPhone, inDocMail, '', inId, 0, 0, 0, vbContactPersonKindId, 0, 0, inSession);
      END IF;
      -- обнуление у остальных
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContactPerson_Object(), ObjectLink_ContactPerson_Object.ObjectId, NULL)
      FROM ObjectLink AS ObjectLink_ContactPerson_Object
           INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = ObjectLink_ContactPerson_Object.ObjectId
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
      WHERE ObjectLink_ContactPerson_Object.ChildObjectId = inId
        AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
        AND ObjectLink_ContactPerson_Object.ObjectId <> vbContactPersonId;

   ELSE IF TRIM (inDocPhone) <> '' OR TRIM (inDocMail) <> ''
        THEN RAISE EXCEPTION 'Ошибка. не заполнена ячейка <Первичка ФИО>';
        END IF;
   END IF;

   -- Акты сверки
   IF inActName <> '' THEN
      -- проверка
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_AktSverki();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inActPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inActMail

                                JOIN ObjectLink AS ObjectLink_ContactPerson_Object
                                                ON ObjectLink_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                               AND ObjectLink_ContactPerson_Object.ChildObjectId = inId

                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inActName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inActName, inActPhone, inActMail, '', inId, 0, 0, 0, vbContactPersonKindId, 0, 0, inSession);
      END IF;
      -- обнуление у остальных
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ContactPerson_Object(), ObjectLink_ContactPerson_Object.ObjectId, NULL)
      FROM ObjectLink AS ObjectLink_ContactPerson_Object
           INNER JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                 ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = ObjectLink_ContactPerson_Object.ObjectId
                                AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
      WHERE ObjectLink_ContactPerson_Object.ChildObjectId = inId
        AND ObjectLink_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
        AND ObjectLink_ContactPerson_Object.ObjectId <> vbContactPersonId;

   ELSE IF TRIM (inDocPhone) <> '' OR TRIM (inDocMail) <> ''
        THEN RAISE EXCEPTION 'Ошибка. не заполнена ячейка <Акт сверки ФИО>';
        END IF;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 27.03.15                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Partner_ContactPerson()
