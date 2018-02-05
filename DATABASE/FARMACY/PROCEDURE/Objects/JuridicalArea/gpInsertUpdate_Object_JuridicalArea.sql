-- Function: gpInsertUpdate_Object_JuridicalArea (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalArea (Integer,Integer,TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalArea (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalArea (Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalArea (Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_JuridicalArea (Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_JuridicalArea(
 INOUT ioId                Integer   ,    -- ключ объекта <>
    IN inCode              Integer   ,    -- Код объекта <>
    IN inJuridicalId       Integer   ,    -- юр.лицо
    IN inAreaId            Integer   ,    -- РЕгион
    IN inComment           TVarChar  ,    -- примечание
    IN inEMail             TVarChar  ,    -- E-Mail
    IN inisDefault         Boolean   ,    -- по умолчанию
    IN inisGoodsCode       Boolean   ,    -- Уникальный код поставщика
    IN inisOnly            Boolean   ,    -- Только для 1-ого региона
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_JuridicalArea());
   vbUserId := inSession; 

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_JuridicalArea()); 
   
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_JuridicalArea(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_JuridicalArea(), vbCode_calc, inComment);

    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalArea_Juridical(), ioId, inJuridicalId);
    -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalArea_Area(), ioId, inAreaId);
   
   -- сохранили E-Mail
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_JuridicalArea_EMail(), ioId, inEMail);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalArea_Default(), ioId, inisDefault);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalArea_GoodsCode(), ioId, inisGoodsCode);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalArea_Only(), ioId, inisOnly);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.18         *
 20.10.17         *
 25.09.17         *  
*/

-- тест
--