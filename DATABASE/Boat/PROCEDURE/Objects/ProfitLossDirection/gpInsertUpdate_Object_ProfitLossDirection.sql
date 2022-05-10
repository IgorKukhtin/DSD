-- Function: gpInsertUpdate_Object_ProfitLossDirection(Integer, Integer, TVarChar, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_ProfitLossDirection (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLossDirection(
 INOUT ioId             Integer,       -- Ключ объекта <Аналитики статей отчета о прибылях и убытках - направление>
    IN inCode           Integer,       -- свойство <Код>
    IN inName           TVarChar,      -- свойство <Наименование>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_calc Integer;   
 
BEGIN
    -- !!! это временно !!!
   -- ioId := (SELECT Id FROM Object WHERE ObjectCode=inCode AND DescId =zc_Object_ProfitLossDirection());

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ProfitLossDirection());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его как последний+1
   Code_calc:=lfGet_ObjectCode (inCode, zc_Object_AccountGroup()); 

   -- !!! проверка уникальности для свойства <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ProfitLossDirection(), inName);

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ProfitLossDirection(), Code_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProfitLossDirection(), Code_calc, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ProfitLossDirection (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.14                                        * rem !!! это временно !!!
 08.09.13                                        * !!! это временно !!!
 21.06.13          *   Code_calc      
 19.06.13                                        * rem lpCheckUnique_Object_ValueData
 18.06.13          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProfitLossDirection()
