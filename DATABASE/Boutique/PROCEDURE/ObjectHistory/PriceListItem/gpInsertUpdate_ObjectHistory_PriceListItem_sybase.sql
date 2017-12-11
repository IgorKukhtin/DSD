-- Function: gpInsertUpdate_ObjectHistory_PriceListItem_sybase

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItem_sybase (Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItem_sybase(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inPriceListId            Integer,    -- Прайс-лист
    IN inGoodsId                Integer,    -- Товар
    IN inStartDate              TDateTime,  -- Дата действия цены
    IN inEndDate                TDateTime,  -- Дата действия цены
    IN inValue                  TFloat,     -- Цена
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
DECLARE
BEGIN
   -- !!!меняем значение!!!
   IF inIsLast = TRUE
   THEN SELECT tmp.ioId INTO ioId
        FROM gpInsertUpdate_ObjectHistory_PriceListItemLast (ioId          := ioId
                                                           , inPriceListId := inPriceListId
                                                           , inGoodsId     := inGoodsId
                                                           , inOperDate    := inStartDate
                                                           , inValue       := inValue
                                                           , inIsLast      := inIsLast
                                                           , inSession     := inSession
                                                            ) AS tmp;
   ELSE
       -- сохранили протокол
       RAISE EXCEPTION 'inIsLast <%>', inIsLast;
   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.08.15         * lpInsert_ObjectHistoryProtocol
 09.12.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceListItem_sybase (ioId := 0 , inPriceListId := 372 , inGoodsId := 406 , inOperDate := ('20.08.2015')::TDateTime , inValue := 59 , inIsLast := 'False' ,  inSession := '2');
