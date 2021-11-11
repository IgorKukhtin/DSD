-- Function: gpGet_CheckBonus_check()

DROP FUNCTION IF EXISTS gpGet_CheckBonus_check (Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_CheckBonus_check(
    IN inisDetail          Boolean   , -- детализация  выводим группу тов, произ площадку, Goods_Business, GoodsTag, GoodsGroupAnalyst
    IN inisGoods           Boolean   , -- выводим товар + вид товара
    IN inGoodsGroup        TVarChar  ,
   OUT outRez              TVarChar  ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
BEGIN

  IF COALESCE (inisDetail, FALSE) = TRUE OR COALESCE (inisGoods, FALSE) = TRUE OR COALESCE (inGoodsGroup,'') <> ''
  THEN
    RAISE EXCEPTION 'Ошибка. Запуск процедуры создания документов запрещен. Включена детализация.';
  END IF;
  outRez := 'Ok';

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.21         *
*/

-- тест
--