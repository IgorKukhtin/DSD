-- Function: gpInsertUpdate_ObjectHistory_PricePlanItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PricePlanItem (Integer,Integer,Integer,Integer,TDateTime,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PricePlanItem(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент прайс-листа>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inGoodsKindId            Integer,    -- вид Товара
    IN inOperDate               TDateTime,  -- Дата действия прайс-листа
    IN inValue                  TFloat,     -- Значение цены
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PricePlanItem());

    -- 
   ioId := lpInsertUpdate_ObjectHistory_PricePlanItem (ioId := ioId
                                                     , inPriceListId := inPriceListId
                                                     , inGoodsId     := inGoodsId
                                                     , inGoodsKindId := inGoodsKindId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := inValue
                                                     , inUserId      := vbUserId
                                                     );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.26         *
*/