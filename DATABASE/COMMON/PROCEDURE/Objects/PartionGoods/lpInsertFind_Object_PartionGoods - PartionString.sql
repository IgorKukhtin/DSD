-- Function: lpInsertFind_Object_PartionGoods (TVarChar)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue  TVarChar -- Полное значение партии
)
RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbPartnerId      Integer;
   DECLARE vbGoodsId        Integer;
BEGIN
     -- меняем параметр
     inValue:= COALESCE (inValue, '');

     -- Находим по св-вам: Полное значение партии + НЕТ Подразделения(для цены)
     IF inValue = ''
     THEN
     -- !!!это надо убрать после исправления ошибки!!!
     vbPartionGoodsId:= (SELECT MIN (Object.Id)
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                         WHERE Object.ValueData = inValue
                           AND Object.DescId = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId IS NULL
                        );
     ELSE
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object 
                              LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                   ON ObjectLink_Unit.ObjectId = Object.Id
                                                  AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                         WHERE Object.ValueData = inValue
                           AND Object.DescId = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId IS NULL
                        );
     END IF;

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inValue);
         -- сохранили <Дата партии>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, vbOperDate);
         -- сохранили <Контрагенты>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Partner(), vbPartionGoodsId, vbPartnerId);
         -- сохранили <Товар>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, vbGoodsId);
     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TVarChar) OWNER TO postgres;


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