-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_OH_PriceListItemTax(Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_OH_PriceListItemTax(
    IN inPriceListId                Integer,    -- Прайс-лист результат
    IN inGoodsId                    Integer,    -- Товар
    IN inOperDate                   TDateTime,  -- Изменение цены с
    IN inOperPrice                 TFloat,     -- вх. цена
    IN inTax                        TFloat,     -- коэфф от входной цены
    IN inSession                    TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

   -- Проверка
   IF COALESCE (inPriceListId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не определено значение <Прайс-лист>.';
   END IF;

   -- Проверка
   IF inOperDate < DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
   THEN
       RAISE EXCEPTION 'Ошибка.Значение <Изменение цены с> не может быть раньше чем <%>.', DATE (DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH');
   END IF;


   -- (т.е. вх цена 100у.е. ввели коэф = 50, новая цена должна быть 5000грн, и так для каждого товра который на остатке в маг или на долге у покупателя по этому маг)

   -- Изменение цен (для товара цена = вх.цена * коєф.)
   PERFORM lpInsertUpdate_ObjectHistory_PriceListItem (ioId          := 0
                                                     , inPriceListId := inPriceListId
                                                     , inGoodsId     := inGoodsId
                                                     , inOperDate    := inOperDate
                                                                        -- округление без копеек и до +/-50 гривен, т.е. последние цифры или 50 или сотни
                                                     , inValue       := (CEIL ((inOperPrice * inTax) / 50) * 50) :: TFloat
                                                  -- , inValue       := CAST ((inOperPrice * inTax) AS NUMERIC (16, 0)) :: TFloat
                                                     , inUserId      := vbUserId
                                                      );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.03.18         *
*/
