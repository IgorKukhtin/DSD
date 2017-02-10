-- Function: lpInsertFind_Object_PartionGoods - PartionDate - NEW - Доходы + Продукция + Готовая продукция + ПФ/ГП в цехе

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate              TDateTime, -- *Дата партии
    IN inGoodsKindId_complete  Integer    -- *при закладке ПФ(ГП) указывается на какой вид ГП предназначен
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate_str   TVarChar;
BEGIN
     -- меняем параметр
     IF inOperDate = zc_DateEnd()
     THEN
         vbOperDate_str:= '';
         inOperDate:= NULL;
     ELSE
         -- форматируем в строчку
         vbOperDate_str:= COALESCE (TO_CHAR (inOperDate, 'DD.MM.YYYY'), '');
     END IF;

     -- замена если NULL
     inGoodsKindId_complete:=  CASE WHEN inGoodsKindId_complete <> 0 THEN inGoodsKindId_complete ELSE zc_GoodsKind_Basis() END;

     -- Находим по св-вам: Полное значение партии + Вид товара(готовая продукция)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                              INNER JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                    ON ObjectLink_GoodsKindComplete.ObjectId = Object.Id
                                                   AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                                                   AND ObjectLink_GoodsKindComplete.ChildObjectId = inGoodsKindId_complete
                         WHERE Object.ValueData = vbOperDate_str
                           AND Object.DescId = zc_Object_PartionGoods()
                        );

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate_str);

         -- сохранили <Вид товара(готовая продукция)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_GoodsKindComplete(), vbPartionGoodsId, inGoodsKindId_complete);

         IF vbOperDate_str <> ''
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
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TDateTime, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.15                                        * add inGoodsKindId_complete
 03.08.14                                        * add !!!это надо убрать после исправления ошибки!!!
 26.07.14                                        * add zc_ObjectLink_PartionGoods_Unit
 20.07.13                                        * vbOperDate_str
 19.07.13         * rename zc_ObjectDate_            
 12.07.13                                        * разделил на 2 проц-ки
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13         *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013', inGoodsKindId_complete:= zc_GoodsKind_Basis());
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL, inGoodsKindId_complete:= zc_GoodsKind_Basis());