-- Function: lpInsertFind_Object_PartionGoods (TDateTime)

-- DROP FUNCTION lpInsertFind_Object_PartionGoods (TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inOperDate  TDateTime -- Дата партии
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbOperDate TVarChar;
BEGIN

     -- форматируем в строчку
     vbOperDate:= COALESCE (TO_CHAR (inOperDate, 'DD.MM.YYYY'), '');

     -- Находим 
     vbPartionGoodsId:= (SELECT Id FROM Object WHERE ValueData = vbOperDate AND DescId = zc_Object_PartionGoods());

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Объект>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbOperDate);
         -- сохранили
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, inOperDate);
     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.07.13         *  rename zc_ObjectDate_            
 12.07.13                                        * разделил на 2 проц-ки
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13         *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL);