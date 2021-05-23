-- Function: gpInsertUpdate_Object_TicketFuel(Integer, Integer, TVarChar, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TicketFuel (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TicketFuel(
 INOUT ioId         Integer   , -- Ключ объекта <Талоны на топливо>
    IN inCode       Integer   , -- свойство <Код >
    IN inName       TVarChar  , -- свойство <Наименование>
    IN inGoodsId    Integer   , -- ссылка на Товары
    
    IN inSession    TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TicketFuel());
   vbUserId:= lpGetUserBySession (inSession);


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_TicketFuel());

   -- проверка уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_TicketFuel(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TicketFuel(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TicketFuel(), vbCode_calc, inName);

   -- сохранили связь с <Товары>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TicketFuel_Goods(), ioId, inGoodsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_TicketFuel (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.10.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TicketFuel()
