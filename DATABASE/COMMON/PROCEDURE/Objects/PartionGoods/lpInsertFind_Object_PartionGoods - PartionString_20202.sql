-- Function: lpInsertFind_Object_PartionGoods - PartionString - Спецодежда

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue        TVarChar  , -- *Полное значение партии
    IN inOperDate     TDateTime , -- 
    IN inInfoMoneyId  Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
BEGIN
     -- меняем параметр
     inValue:= COALESCE (TRIM (inValue), '');

     -- проверка
     IF COALESCE (inInfoMoneyId, 0) <> zc_Enum_InfoMoney_20202()
     THEN
         RAISE EXCEPTION 'Ошибка.Не определен товар <%>.', lfGet_Object_ValueData_sh (zc_Enum_InfoMoney_20202());
     END IF;

     -- проверка
     IF inValue = ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Партия>.';
     END IF;


     -- Находим по св-вам: Полное значение партии + НЕТ Подразделения(для цены)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                   ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                  AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                         WHERE Object.ValueData = inValue
                           AND Object.DescId = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId              IS NULL -- т.е. вообще нет этого св-ва
                           AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- т.е. вообще нет этого св-ва
                        );

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inValue);

         IF inOperDate > zc_DateStart()
         THEN
             -- сохранили <Дата партии>
             PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, inOperDate);
         END IF;

     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.21                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= 'Test_PartionGoods');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= NULL);