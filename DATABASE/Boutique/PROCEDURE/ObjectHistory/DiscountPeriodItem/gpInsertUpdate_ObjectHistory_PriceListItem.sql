-- Function: gpInsertUpdate_ObjectHistory_DiscountPeriodItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_DiscountPeriodItem (Integer,Integer,Integer,TDateTime,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_DiscountPeriodItem(
 INOUT ioId                     Integer,    -- ключ объекта <Элемент>
    IN inUnitId                 Integer,    -- 
    IN inGoodsId                Integer,    -- Товар
    IN inOperDate               TDateTime,  -- Дата действия 
    IN inValue                  TFloat,     -- Значение % cкидка
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS integer AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_DiscountPeriodItem());

    -- 
   ioId := lpInsertUpdate_ObjectHistory_DiscountPeriodItem (ioId := ioId
                                                     , inUnitId := inUnitId
                                                     , inGoodsId     := inGoodsId
                                                     , inOperDate    := inOperDate
                                                     , inValue       := inValue
                                                     , inUserId      := vbUserId
                                                     );
 

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.08.15         * lpInsertUpdate_ObjectHistory_DiscountPeriodItem
 18.04.14                                        * add zc_Enum_Process_InsertUpdate_ObjectHistory_DiscountPeriodItem
 06.06.13                        *
*/
