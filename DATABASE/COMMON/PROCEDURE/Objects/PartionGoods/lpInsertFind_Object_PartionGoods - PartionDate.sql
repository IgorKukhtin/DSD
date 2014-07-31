-- Function: lpInsertFind_Object_PartionGoods (TDateTime)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate  TDateTime -- Дата партии
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

     -- Находим по св-вам: Полное значение партии + НЕТ Подразделения(для цены)
     vbPartionGoodsId:= (SELECT Object.Id
                         FROM Object
                              INNER JOIN ObjectLink AS ObjectLink_Unit
                                                    ON ObjectLink_Unit.ObjectId = Object.Id
                                                   AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
                         WHERE Object.ValueData = vbOperDate_str
                           AND Object.DescId = zc_Object_PartionGoods()
                           AND ObjectLink_Unit.ObjectId IS NULL
                        );

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate_str);

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
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.14                                        * add zc_ObjectLink_PartionGoods_Unit
 20.07.13                                        * vbOperDate_str
 19.07.13         * rename zc_ObjectDate_            
 12.07.13                                        * разделил на 2 проц-ки
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13         *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL);