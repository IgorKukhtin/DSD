-- Function: lpInsertFind_Object_PartionGoods (TVarChar, TDateTime)

-- DROP FUNCTION lpInsertFind_Object_PartionGoods (TVarChar, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inName  TVarChar  , -- Название
    IN inDate  TDateTime   -- Дата партии
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
   DECLARE vbDate           TDateTime;
   DECLARE vbPartnerId      Integer;
   DECLARE vbGoodsId        Integer;
BEGIN
   
   IF inName IS NULL
   THEN
       -- Находим 
       SELECT ObjectDate_Date.ObjectId INTO vbPartionGoodsId
       FROM ObjectDate AS ObjectDate_Date
            JOIN Object AS Object_PartionGoods ON  Object_PartionGoods.Id = ObjectDate_Date.ObjectId
                                               AND Object_PartionGoods.ValueData = ''
                                               AND Object_PartionGoods.DescId = zc_Object_PartionGoods()
       WHERE ObjectDate_Date.ValueData = inDate
         AND ObjectDate_Date.DescId = zc_ObjectDate_PartionGoods_Date();
   ELSE 
       -- Находим 
       SELECT Id INTO vbPartionGoodsId FROM Object WHERE ValueData = inName AND DescId = zc_Object_PartionGoods();
   END IF;


   IF COALESCE (vbPartionGoodsId, 0) = 0
   THEN
       IF inName IS NULL
       THEN
           -- сохранили <Объект>
           vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, '');
           -- сохранили
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Date(), vbPartionGoodsId, inDate);
       ELSE 
           -- сохранили <Объект>
           vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inName);
           -- сохранили
           PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Date(), vbPartionGoodsId, vbDate);
           -- сохранили
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Partner(), vbPartionGoodsId, vbPartnerId);
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, vbGoodsId);
       END IF;
   END IF;

   -- Возвращаем значение
   RETURN (vbPartionGoodsId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (TVarChar, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13                                        * сначала Find, потом если надо Insert
 02.07.13          *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inName:= 'Test_PartionGoods', inDate:= '31.01.2013');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inName:= NULL, inDate:= '31.01.2013');