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
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbId Integer;
   DECLARE text_var1 text;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   vbUserId := inSession;
   
   IF COALESCE(ioId, 0) = 0 THEN
     -- Ищем по коду и inObjectId
     SELECT Object_Goods_View.Id INTO vbGoodsId
       FROM Object_Goods_View 
      WHERE Object_Goods_View.ObjectId = inObjectId
        AND Object_Goods_View.GoodsCode = inCode;   
    ELSE
      vbGoodsId := ioId;
    END IF;
   
    ioId := lpInsertUpdate_Object_Goods(vbGoodsId, inCode, inName, 0, 0, 0, inObjectId, vbUserId);

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

      -- Сохранили в плоскую таблицй
     BEGIN

       PERFORM lpInsertUpdate_Object_Goods_Link (vbGoodsId, inGoodsMainId, inObjectId, vbUserId); 
     EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
          PERFORM gpInsertUpdate_Object_GoodsLink('lpInsertUpdate_Object_Goods_Link', text_var1::TVarChar, vbUserId);
     END;

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

	LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLink(Integer, TVarChar, TVarChar, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.19                                                      *
 19.07.14                        *

*/                                          

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
