-- Function: gpInsertUpdate_Object_PriceListItem_From_Excel (Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceListItem_From_Excel (TDateTime, Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceListItem_From_Excel(
    IN inOperDate        TDateTime,
    IN inPriceListId     Integer  , -- прайс лист
    IN inGoodsCode       Integer  , -- Code Товар
    IN inGoodsKindName   TVarChar , -- Вид Товара
    IN inPriceValue      TFloat   ,  -- Цена
    IN inSession         TVarChar -- сессия пользователя
)
RETURNS VOID AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsId Integer;
    DECLARE vbGoodsKindId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());


    IF COALESCE(inPriceListId,0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Сначала выберите Прайс лист';
    END IF;
    
    --поиск товара по коду
    vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode);

    -- поиск вида товара
    vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsKind() AND Object.ValueData = inGoodsKindName);

    
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION 'Ошибка. В базе данных не найден товар с кодом <%>', inGoodsCode;
    END IF;

    IF (COALESCE(vbGoodsKindId,0) = 0)
    THEN
        RAISE EXCEPTION 'Ошибка. В базе данных не найден вид товара <%>', inGoodsKindName;
    END IF;

 
    IF inPriceValue is not null AND (inPriceValue < 0)
    THEN
        RAISE EXCEPTION 'Ошибка. Цена <%> Не может быть меньше нуля.', inPriceValue;
    END IF;
   
    -- 
    PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId := 0
                                                      , inPriceListId := inPriceListId
                                                      , inGoodsId     := vbGoodsId
                                                      , inGoodsKindId := vbGoodsKindId
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 24.03.20         *
*/

-- тест
