-- Function: gpInsertUpdate_ObjectHistory_PriceListItem()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_Price (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_Price(
    IN inMovementId                 Integer   ,
    IN inMovementItemId             Integer,
    IN inPriceListId                Integer,    -- Прайс-лист результат
    IN inGoodsId                    Integer,    -- Товар
    IN inOperDate                   TDateTime,  -- Изменение цены с
    IN inOperPrice                  TFloat,     -- вх. цена
    IN inTax                        TFloat,     -- коэфф от входной цены
    IN inSession                    TVarChar    -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
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
                                                     , inUserId      := vbUserId
                                                      );

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), inMovementItemId, (CEIL ((inOperPrice * inTax) / 50) * 50));

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.03.18         *
*/
