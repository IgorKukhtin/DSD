-- Function: gpInsertUpdate_Object_Juridical (Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Юридические лица> 
    IN inName                     TVarChar  ,    -- Название объекта <Юридические лица>
    IN inIsCorporate              Boolean   ,    -- Признак главное юридическое лицо (наша ли собственность это юр.лицо)
    IN inFullName                 TVarChar  ,    -- Юр. лицо полное название
    IN inAddress                  TVarChar  ,    -- Юридический адрес
    IN inOKPO                     TVarChar  ,    -- ОКПО
    IN inINN                      TVarChar  ,    -- ИНН
    IN inJuridicalGroupId         Integer   ,    -- ключ объекта <Группы юридических лиц> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (vbCode_max, 0) = 0 THEN vbCode_max := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (vbCode_max, zc_Object_Juridical()); 
   
   -- проверка прав уникальности для свойства <Наименование >
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);

   -- проверка уникальность <Наименование> для !!!одной!! <Группы юридических лиц>
   IF TRIM (inName) <> '' AND COALESCE (inJuridicalGroupId, 0) <> 0 
   THEN
       IF EXISTS (SELECT Object.Id
                  FROM Object
                       JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                       ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object.Id
                                      AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
                                      AND ObjectLink_Juridical_JuridicalGroup.ChildObjectId = inJuridicalGroupId
                                   
                  WHERE TRIM (Object.ValueData) = TRIM (inName)
                   AND Object.Id <> COALESCE (ioId, 0))
       THEN
           RAISE EXCEPTION 'Ошибка. Группы юридических лиц <%> уже установлена у <%>.', TRIM (inName), lfGet_Object_ValueData (inJuridicalGroupId);
       END IF;
   END IF;


   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Juridical(), vbCode_max, inName);

   -- сохранили Признак главное юридическое лицо (наша ли собственность это юр.лицо)
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   -- сохранили Юр. лицо полное название
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_FullName(), ioId, inFullName);
   -- сохранили Юридический адрес
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_Address(), ioId, inAddress);
   -- сохранили ОКПО
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_OKPO(), ioId, inOKPO);
   -- сохранили ИНН
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Juridical_INN(), ioId, inINN);


   -- сохранили связь с <Группы юридических лиц>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
20.02.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Juridical()
