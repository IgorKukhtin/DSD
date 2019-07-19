-- Function: gpUpdate_Object_PartionGoods_Cat_5

DROP FUNCTION IF EXISTS gpUpdate_Object_PartionGoods_Cat_5 (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionGoods_Cat_5(
    IN inPartionGoodsId   Integer,   -- Партия товара
    IN inCat_5            Boolean,   -- Признак категории
   OUT outCat_5           Boolean,   -- Признак категории
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbcontainerid_err Integer;
   DECLARE vbOperDate_str    TVarChar;
BEGIN

     -- Проверка - может быть только одна партия
     IF NOT EXISTS (SELECT 1
             FROM Object
             WHERE Object.ID      = inPartionGoodsId
               AND Object.DescId  = zc_Object_PartionGoods())
     THEN 
         RAISE EXCEPTION 'Ошибка.Партия не найдена.';
     END IF;

     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PartionGoods_Cat_5(), inPartionGoodsId, NOT inCat_5);

     -- Возвращаем значение
     outCat_5 := COALESCE ((SELECT ValueData FROM ObjectBoolean WHERE DescID = zc_ObjectBoolean_PartionGoods_Cat_5() AND ObjectId = inPartionGoodsId), FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_PartionGoods_Cat_5 (inMovementId:= 1, inOperDate:= NULL);
