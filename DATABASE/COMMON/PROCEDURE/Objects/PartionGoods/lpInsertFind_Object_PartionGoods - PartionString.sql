-- Function: lpInsertFind_Object_PartionGoods - PartionString - Основное сырье + Мясное сырье + "выборочно"

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue  TVarChar -- *Полное значение партии
)
RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbPartnerId      Integer;
   DECLARE vbGoodsId        Integer;
BEGIN
     -- меняем параметр
     inValue:= COALESCE (TRIM (inValue), '');

     -- Находим по св-вам: Полное значение партии + НЕТ Подразделения(для цены)
     IF inValue = ''
     THEN
     
         IF 1 < (SELECT COUNT(*)
                 FROM Object 
                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                           ON ObjectLink_Unit.ObjectId = Object.Id
                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                           ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                          AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                      LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                           ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                          AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                 WHERE Object.ValueData  = inValue
                   AND Object.DescId     = zc_Object_PartionGoods()
                   AND ObjectLink_Unit.ObjectId              IS NULL -- т.е. вообще нет этого св-ва
                   AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- т.е. вообще нет этого св-ва
                   AND ObjectLink_PartionCell.ObjectId       IS NULL -- т.е. вообще нет этого св-ва
                )
         THEN
             RAISE EXCEPTION 'ERROR.PartionGoods = <%>', inValue;
         END IF;
                        

     -- !!!это надо убрать после исправления ошибки!!!
     vbPartionGoodsId:= (SELECT Object.Id
                         -- SELECT MIN (Object.Id)
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                   ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                  AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                              LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                   ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                                  AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                         WHERE Object.ValueData  = inValue
                           AND Object.DescId     = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId              IS NULL -- т.е. вообще нет этого св-ва
                           AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- т.е. вообще нет этого св-ва
                           AND ObjectLink_PartionCell.ObjectId       IS NULL -- т.е. вообще нет этого св-ва
                        ); -- 80132
     ELSE
         IF 1 < (SELECT COUNT(*)
                 FROM Object 
                      LEFT JOIN ObjectLink AS ObjectLink_Unit
                                           ON ObjectLink_Unit.ObjectId = Object.Id
                                          AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                           ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                          AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                      LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                           ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                          AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                 WHERE Object.ValueData  = inValue
                   AND Object.DescId     = zc_Object_PartionGoods()
                   AND ObjectLink_Unit.ObjectId              IS NULL -- т.е. вообще нет этого св-ва
                   AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- т.е. вообще нет этого св-ва
                   AND ObjectLink_PartionCell.ObjectId       IS NULL -- т.е. вообще нет этого св-ва
                )
         THEN
             RAISE EXCEPTION 'ERROR.PartionGoods = <%>', inValue;
         END IF;

     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                              LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                   ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                  AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                              LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                   ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                                  AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                         WHERE Object.ValueData  = inValue
                           AND Object.DescId     = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId              IS NULL -- т.е. вообще нет этого св-ва
                           AND ObjectLink_GoodsKindComplete.ObjectId IS NULL -- т.е. вообще нет этого св-ва
                           AND ObjectLink_PartionCell.ObjectId       IS NULL -- т.е. вообще нет этого св-ва
                        );
     END IF;

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inValue);

         -- сохранили <Дата партии>
         vbOperDate:= zfCalc_PartionGoods_OperDate (inValue);
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, vbOperDate);

         -- сохранили <Контрагенты>
         vbPartnerId:= zfCalc_PartionGoods_PartnerCode (inValue);
         IF EXISTS (SELECT 1 FROM Object WHERE Object.ObjectCode = vbPartnerId AND Object.DescId = zc_Object_Partner() HAVING COUNT (*) > 1)
         THEN
             RAISE EXCEPTION 'Ошибка.В партии <%> не установлен код контрагента.', inValue;
         END IF;
         IF EXISTS (SELECT 1 FROM Object WHERE Object.ObjectCode = vbPartnerId AND Object.DescId = zc_Object_Partner() HAVING COUNT (*) > 1)
         THEN
             RAISE EXCEPTION 'Ошибка. Код покупателя <%> установлен у разных контрагентов.<%>', vbPartnerId, inValue;
         END IF;
         vbPartnerId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = vbPartnerId AND Object.DescId = zc_Object_Partner());
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Partner(), vbPartionGoodsId, vbPartnerId);

         -- сохранили <Товар>
         vbGoodsId:= zfCalc_PartionGoods_GoodsCode (inValue);
         -- Проверка
         IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ObjectCode = vbGoodsId AND Object.DescId = zc_Object_Goods())
         THEN
             RAISE EXCEPTION 'Ошибка.Неправильный формат в партии. <%> %', vbGoodsId, inValue;
         END IF;
         --
         vbGoodsId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = vbGoodsId AND Object.DescId = zc_Object_Goods());
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, vbGoodsId);
 
     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.08.14                                        * add !!!это надо убрать после исправления ошибки!!!
 26.07.14                                        * add zc_ObjectLink_PartionGoods_Unit
 20.07.13                                        * vbOperDate
 19.07.13         *  rename zc_ObjectDate_              
 12.07.13                                        * разделил на 2 проц-ки
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13         *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= 'Test_PartionGoods');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= NULL);