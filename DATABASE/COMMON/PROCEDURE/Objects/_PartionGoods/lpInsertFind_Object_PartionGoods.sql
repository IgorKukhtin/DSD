-- Function: lpInsertFind_Object_PartionGoods()

-- DROP FUNCTION lpInsertFind_Object_PartionGoods();

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
 INOUT ioId                  Integer   , -- ключ объекта <Партии товаров>
    IN inCode                Integer   , -- Код объекта 
    IN inName                TVarChar  , -- Название объекта 
    IN inDate                TDateTime , -- Дата партии
    IN inPartnerId           Integer   , -- ссылка на Контрагентов
    IN inGoodsId             Integer     -- ссылка на Товары
)
  RETURNS Integer AS
$BODY$
BEGIN
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PartionGoods(), 0, inName);

   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Date(), ioId, inDate);

   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Partner(), ioId, inPartnerId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), ioId, inGoodsId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (Integer, Integer, TVarChar, TDateTime, Integer, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.07.13          *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (ioId:= 1111, inCode:=2 , inName:= 'Test_PartionGoods', inDate:= '31.01.2013', inPartnerId:= 4, inGoodsId:=2)