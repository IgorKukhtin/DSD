-- Function: gpInsertUpdate_Object_CardFuel(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_CardFuel (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CardFuel(
 INOUT ioId                Integer   , -- Ключ объекта <Топливные карты>
    IN inCode              Integer   , -- свойство <Код >
    IN inName              TVarChar  , -- свойство <Наименование>
--    IN inLimit             TFloat    , -- Лимит
    IN inPersonalDriverId  Integer   , -- ссылка на сотрудника
    IN inCarId             Integer   , -- ссылка на авто
    IN inPaidKindId        Integer   , -- ссылка на Виды форм оплаты
    IN inJuridicalId       Integer   , -- ссылка на Юр.лица
    IN inGoodsId           Integer   , -- ссылка на Товары
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_CardFuel());
   vbUserId := inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CardFuel());

   -- проверка уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CardFuel(), inName);
   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CardFuel(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CardFuel(), vbCode_calc, inName);

--   -- сохранили свойство <Лимит>
--   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CardFuel_Limit(), ioId, inLimit);

   -- сохранили связь с <сотрудником>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_PersonalDriver(), ioId, inPersonalDriverId);
   
   -- сохранили связь с <авто>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_Car(), ioId, inCarId);

   -- сохранили связь с <Виды форм оплаты >
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_PaidKind(), ioId, inPaidKindId);

   -- сохранили связь с <Юридические лица>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_Juridical(), ioId, inJuridicalId);

   -- сохранили связь с <Товары>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CardFuel_Goods(), ioId, inGoodsId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CardFuel (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.10.13                                        * add inLimit
 14.10.13         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CardFuel(ioId:=148, inCode:=1, inName:='Карта 45 ', inPersonalDriverId :=19490, inCarId:= 65594  , inPaidKindId:=  80 , inJuridicalId :=12454 , inGoodsId :=2447 , inSession:= '2')
