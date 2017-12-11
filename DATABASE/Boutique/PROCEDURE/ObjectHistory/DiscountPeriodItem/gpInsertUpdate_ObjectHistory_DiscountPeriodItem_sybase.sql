-- Function: gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase (Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент ИСТОРИИ>
    IN inUnitId                 Integer,    -- Подразделение
    IN inGoodsId                Integer,    -- Товар
    IN inStartDate              TDateTime,  -- Дата действия % скидки
    IN inEndDate                TDateTime,  -- Дата действия % скидки
    IN inValue                  TFloat,     -- % скидки
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
        FROM gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (ioId          := ioId
                                                                , inUnitId      := inUnitId
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
 28.04.17         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase (ioId := 0 , inUnitId := 311 , inGoodsId := 271 , inOperDate := ('08.05.2017')::TDateTime , inValue := 0 , inIsLast := 'False' ,  inSession := '2');
