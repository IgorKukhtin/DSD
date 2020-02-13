-- Function: gpGet_GoodsId_byCode()

DROP FUNCTION IF EXISTS gpGet_GoodsId_byCode (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_GoodsId_byCode (
 INOUT ioGoodsCode           Integer  , -- 
   OUT outGoodsId            Integer  , -- 
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

     -- определяем товар по коду
     outGoodsId := COALESCE ( (SELECT Object.Id FROM Object WHERE Object.ObjectCode = ioGoodsCode AND Object.DescId = zc_Object_Goods()),0) ;
     --проверка
     IF COALESCE (outGoodsId, 0) = 0
     THEN
         ioGoodsCode := 0;
         --RAISE EXCEPTION 'Ошибка.Товар с кодом <%> не найден.', ioGoodsCode; 
     END IF;        
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.20         *
*/

-- тест
-- SELECT * FROM gpGet_GoodsId_byCode (ioGoodsCode:= 102330, inSession:= '5'); -- test