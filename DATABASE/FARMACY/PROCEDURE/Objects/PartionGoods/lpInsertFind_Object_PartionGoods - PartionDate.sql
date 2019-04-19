-- Function: lpInsertFind_Object_PartionGoods - PartionDate

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inMovementId     Integer,   -- 
    IN inOperDate       TDateTime  -- Дата партии - ExpirationDate
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate_str   TVarChar;
BEGIN
     -- меняем параметр
     IF COALESCE (inOperDate, zc_DateEnd()) = zc_DateEnd()
     THEN
         vbOperDate_str:= '';
         inOperDate:= NULL;
     ELSE
         -- форматируем в строчку
         vbOperDate_str:= COALESCE (TO_CHAR (inOperDate, 'DD.MM.YYYY'), '');
     END IF;


     -- Находим по св-вам: Полное значение партии + Вид товара(готовая продукция)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                         WHERE Object.ObjectCode = inMovementId
                           AND Object.ValueData  = vbOperDate_str
                           AND Object.DescId     = zc_Object_PartionGoods()
                        );

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), inMovementId, vbOperDate_str);

         -- сохранили
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, inOperDate);

     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (Integer, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.19                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inMovementId:= 1, inOperDate:= NULL);
