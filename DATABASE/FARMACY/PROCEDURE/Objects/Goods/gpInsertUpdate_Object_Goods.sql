-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserName TVarChar;
   DECLARE vbObjectId Integer;
   DECLARE vbCode Integer;
   DECLARE vbMainGoodsId Integer;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   vbUserId := lpGetUserBySession (inSession);
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   IF COALESCE(vbObjectId, 0) = 0 THEN
      SELECT ValueData INTO vbUserName FROM Object WHERE Id = vbUserId;
      RAISE EXCEPTION 'У пользователя "%" не установлена торговая сеть', vbUserName;
   END IF;

   -- !!! проверка уникальности <Код>
   IF COALESCE(inMeasureId, 0) = 0 THEN
      RAISE EXCEPTION 'Единица измерения должна быть определена';
   END IF; 

   -- !!! проверка уникальности <Код>
   IF COALESCE(inNDSKindId, 0) = 0 THEN
      RAISE EXCEPTION 'Тип НДС должен быть определен';
   END IF; 

   vbCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId), inCode::integer);
   
   ioId := lpInsertUpdate_Object_Goods(ioId, inCode, inName, inGoodsGroupId, inMeasureId, inNDSKindId, vbObjectId, vbUserId);

   -- Кусок ниже реализован временно пока работает одна сеть

   -- Добавляем данные в общий справочник

   SELECT Object_Goods_Main_View.Id INTO vbMainGoodsId
     FROM Object_Goods_Main_View 
    WHERE Object_Goods_Main_View.GoodsCode = vbCode; 

   --
   vbMainGoodsId := lpInsertUpdate_Object_Goods(vbMainGoodsId, inCode, inName, inGoodsGroupId, inMeasureId, inNDSKindId, NULL, vbUserId);

   PERFORM gpInsertUpdate_Object_LinkGoods_Load(inCode, inCode, vbObjectId, inSession);

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
