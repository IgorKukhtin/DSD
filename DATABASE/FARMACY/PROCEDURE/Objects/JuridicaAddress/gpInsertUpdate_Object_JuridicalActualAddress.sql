-- Function: gpInsertUpdate_Object_JuridicalActualAddress (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalActualAddress (Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalActualAddress(
 INOUT ioId                Integer   ,    -- ключ объекта <>
    IN inCode              Integer   ,    -- Код объекта <>
    IN inJuridicalId       Integer   ,    -- юр.лицо
    IN inAddressId         Integer   ,    -- Адрес
    IN inComment           TVarChar  ,    -- примечание
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalActualAddress());
   vbUserId := inSession; 

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_JuridicalActualAddress()); 
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalActualAddress(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_JuridicalActualAddress(), vbCode_calc, inComment);

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalActualAddress_Juridical(), ioId, inJuridicalId);
    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalActualAddress_Address(), ioId, inAddressId);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.05.18        *
*/

-- тест
--