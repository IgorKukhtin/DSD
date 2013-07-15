-- Function: lpInsertFind_Object_PartionGoods (TVarChar)

-- DROP FUNCTION lpInsertFind_Object_PartionGoods (TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inValue  TVarChar -- Полное значение партии
)
RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbDate           TDateTime;
   DECLARE vbPartnerId      Integer;
   DECLARE vbGoodsId        Integer;
   DECLARE vbValue          TVarChar;
BEGIN
   
     -- обрабатываем NULL
     vbValue:= COALESCE (inValue, '');

     -- Находим 
     vbPartionGoodsId:= (SELECT Id FROM Object WHERE ValueData = vbValue AND DescId = zc_Object_PartionGoods());

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Объект>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, vbValue);
         -- сохранили
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Date(), vbPartionGoodsId, vbDate);
         -- сохранили
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Partner(), vbPartionGoodsId, vbPartnerId);
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, vbGoodsId);
     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.13                                        * разделил на 2 проц-ки
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13          *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= 'Test_PartionGoods');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inValue:= NULL);