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
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   -- Ищем по коду и inObjectId
   SELECT Object.Id INTO vbGoodsId
     FROM Object 
     JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                    AND ObjectLink.ChildObjectId = inObjectId
                    AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()
     JOIN ObjectString ON ObjectString.ObjectId = Object.Id
                      AND ObjectString.DescId = zc_ObjectString_Goods_Code()
                      AND ObjectString.ValueData = inCode
    WHERE Object.DescId = zc_Object_Goods();   
   -- сохранили <Объект>
   vbGoodsId := lpInsertUpdate_Object(vbGoodsId, zc_Object_Goods(), 0, inName);
   -- Строковый код
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Code(), vbGoodsId, inCode);
   -- сохранили связь с <Главным товаром>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsMain(), vbGoodsId, inGoodsMainId);
   -- сохранили свойство <связи чьи товары>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), vbGoodsId, inObjectId);
  

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
                                           