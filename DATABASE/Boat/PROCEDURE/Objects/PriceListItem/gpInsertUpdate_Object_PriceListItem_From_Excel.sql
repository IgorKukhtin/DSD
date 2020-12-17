-- Function: gpInsertUpdate_Object_PriceListItem_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceListItem_From_Excel (TDateTime, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceListItem_From_Excel(
    IN inOperDate        TDateTime,
    IN inPriceListId     Integer  , -- прайс лист
    IN inGoodsId         Integer  , --  Товар
    IN inPriceValue      TFloat   , -- Цена
    IN inSession         TVarChar   -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE(inPriceListId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не выберан Прайс-лист.';
    END IF;
    
    /*
    -- поиск товара по коду
    vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);

    IF COALESCE (vbGoodsId, 0) = 0
    THEN
       -- RAISE EXCEPTION 'Ошибка.Значение код товара = <%> не найден.', inGoodsCode;
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Значение код товара = <%> не найден.' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_PriceListItem_From_Excel' :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := inGoodsCode :: TVarChar
                                             );
    END IF;
    */

    IF inPriceValue < 0
    THEN
       -- RAISE EXCEPTION 'Ошибка. Цена = <%> не может быть меньше нуля.', inPriceValue;
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка. Цена = <%> не может быть меньше нуля.' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_PriceListItem_From_Excel' :: TVarChar
                                             , inUserId        := vbUserId
                                             , inParam1        := inPriceValue :: TVarChar
                                             );
    END IF;

    --
    PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                      , inPriceListId := inPriceListId
                                                      , inGoodsId     := inGoodsId
                                                      , inOperDate    := inOperDate
                                                      , inValue       := inPriceValue
                                                      , inUserId      := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.11.20         *
*/

-- тест
