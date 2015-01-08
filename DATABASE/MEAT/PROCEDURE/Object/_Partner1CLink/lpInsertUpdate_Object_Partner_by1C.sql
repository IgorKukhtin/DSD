-- Function: lpInsertUpdate_Object_Partner_by1C (Integer, Integer, TVarChar, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Partner_by1C (Integer, Integer, TVarChar, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Partner_by1C(
 INOUT ioId                     Integer,    -- ключ объекта
    IN inCode                   Integer,    -- Код объекта
    IN inName                   TVarChar,   -- Название объекта
    IN inJuridicalId            Integer ,   -- Юридическое лицо
    IN inUserId                 Integer     -- Пользователь
)
  RETURNS Integer
AS
$BODY$
BEGIN
   -- проверка
   IF COALESCE (inName, '') = '' THEN
       RAISE EXCEPTION 'Ошибка.Не установлено <Название>.';
   END IF;

   -- проверка уникальности <Название>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), inName);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, inName);

   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.01.15                                        *
*/
