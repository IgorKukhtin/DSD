-- Function: gpGet_ReportGoods_Params()

DROP FUNCTION IF EXISTS gpGet_ReportGoods_Params (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_ReportGoods_Params (
    IN inGoodsCode           Integer  , -- 
   OUT outGoodsId            Integer  , -- 
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
BEGIN

     -- определяем товар по коду
     outGoodsId := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
     --проверка
     IF COALESCE (outGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар с кодом <%> не найден.', inGoodsCode; 
     END IF;        
      
 --    outPartionId :=(SELECT DISTINCT
 --       FROM Object_PartionGoods 
 --      WHERE Object_PartionGoods.GoodsId = outGoodsId

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.18         *
*/

-- тест
-- SELECT * FROM gpGet_ReportGoods_Params (inGoodsCode:= 102330, inSession:= '5'); -- test