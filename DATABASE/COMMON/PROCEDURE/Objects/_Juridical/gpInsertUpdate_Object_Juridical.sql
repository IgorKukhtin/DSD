-- Function: gpInsertUpdate_Object_Juridical()

-- DROP FUNCTION gpInsertUpdate_Object_Juridical();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                  Integer   ,    -- ключ объекта <Юридическое лицо>
    IN inCode                Integer   ,    -- свойство <Код Юридического лица>
    IN inName                TVarChar  ,    -- Название объекта <Юридическое лицо>
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inisCorporate         Boolean   ,    -- Признак наша ли собственность это юридическое лицо
    IN inJuridicalGroupId    Integer   ,    -- Группы юридических лиц
    IN inGoodsPropertyId     Integer   ,    -- Классификаторы свойств товаров
    IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;  
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());
   UserId := inSession;

   -- !!! Если код не установлен, определяем его каи последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! IF COALESCE (inCode, 0) = 0
   -- !!! THEN 
   -- !!!     SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Juridical();
   -- !!! ELSE
   -- !!!     Code_max := inCode;
   -- !!! END IF; 
   IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL; ELSE Code_max := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- !!! проверка уникальность <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Juridical(), inName);
   -- !!! проверка уникальности <Код>
   -- !!! PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Juridical(), inCode, inName);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Juridical_GLNCode(), ioId, inGLNCode);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_JuridicalGroup(), ioId, inJuridicalGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_GoodsProperty(), ioId, inGoodsPropertyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Juridical(Integer, Integer, TVarChar, TVarChar, Boolean, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.05.13                                        * rem lpCheckUnique_Object_ValueData
 12.06.13          *    
 16.06.13                                        * rem lpCheckUnique_Object_ObjectCode
 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Juridical()
