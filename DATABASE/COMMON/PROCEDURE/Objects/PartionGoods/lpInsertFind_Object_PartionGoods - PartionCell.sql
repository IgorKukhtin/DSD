-- Function: lpInsertFind_Object_PartionGoods - PartionDate + PartionCell - Доходы + Продукция + Готовая продукция

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate              TDateTime , -- *Дата партии
    IN inGoodsKindId_complete  Integer   , -- виртуальный параметр, т.к. иначе параметры пересекаются с другой проц
    IN inPartionCellId         Integer     --
)
RETURNS Integer
AS
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

     -- замена
     --inPartionCellId:= 0;


     IF inPartionCellId > 0
     THEN
         -- Находим по св-вам: Полное значение партии + PartionCell
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink AS ObjectLink_PartionCell
                                                        ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                                       AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                                                       AND ObjectLink_PartionCell.ChildObjectId = inPartionCellId
                             WHERE Object.ValueData = vbOperDate_str
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     ELSE
         -- Находим по св-вам: Полное значение партии + пустой PartionCell
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink AS ObjectLink_PartionCell
                                                        ON ObjectLink_PartionCell.ObjectId      = Object.Id
                                                       AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()
                                                       AND ObjectLink_PartionCell.ChildObjectId IS NULL
                             WHERE Object.ValueData = vbOperDate_str
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     END IF;

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate_str);

         -- сохранили <PartionCell>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionCell(), vbPartionGoodsId, CASE WHEN inPartionCellId > 0 THEN inPartionCellId ELSE NULL END);

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

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.24                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2024', inPartionCellId:= 5);
