-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLink(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsMainId         Integer   ,    -- Ссылка на главный товар
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть

    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbId Integer;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   IF COALESCE(ioId, 0) = 0 THEN
     -- Ищем по коду и inObjectId
     SELECT Object_Goods_View.Id INTO vbGoodsId
       FROM Object_Goods_View 
      WHERE Object_Goods_View.ObjectId = inObjectId
        AND Object_Goods_View.GoodsCode = inCode;   
    ELSE
      vbGoodsId := ioId;
    END IF;
   
    ioId := lpInsertUpdate_Object_Goods(vbGoodsId, inCode, inName, 0, 0, 0, inObjectId, UserId);

    SELECT Id INTO vbId 
       FROM Object_LinkGoods_View
      WHERE Object_LinkGoods_View.GoodsMainId = inGoodsMainId 
        AND Object_LinkGoods_View.GoodsId = vbGoodsId;

     IF COALESCE(vbId, 0) = 0 THEN
                 PERFORM gpInsertUpdate_Object_LinkGoods(
                                   ioId := 0                     ,  
                                   inGoodsMainId := inGoodsMainId, -- Главный товар
                                   inGoodsId  := vbGoodsId       , -- Товар для замены
                                   inSession  := inSession         -- сессия пользователя
                                   );
     END IF;    

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.07.14                        *

*/                                          

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
                                           