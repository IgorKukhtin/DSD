-- Function: gpInsertUpdate_Object_Bank(Integer,Integer,TVarChar,TVarChar,Integer,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Bank(Integer,Integer,TVarChar,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Bank(
 INOUT ioId	                 Integer,       -- ключ объекта < Банк>
    IN inCode                Integer,       -- Код объекта <Банк>
    IN inName                TVarChar,      -- Название объекта <Банк>
    IN inMFO                 TVarChar,      -- МФО
    IN inJuridicalId         Integer,       -- Юр. лицо
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Bank());
   
   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Bank());
   
   -- проверка прав уникальности для свойства <Наименование Банка>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Bank(), inName);
   -- проверка прав уникальности для свойства <Код Банка>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Bank(), vbCode_calc);
   -- проверка прав уникальности для свойства <МФО>
   PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Bank_MFO(), inMFO);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Bank(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Bank_MFO(), ioId, inMFO);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Bank_Juridical(), ioId, inJuridicalId);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Bank (Integer,Integer,TVarChar,TVarChar,Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.05.14                                        * add lpCheckRight
 04.07.13          * vbCode_calc             
 10.06.13          *
 05.06.13          
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Bank ()
                            