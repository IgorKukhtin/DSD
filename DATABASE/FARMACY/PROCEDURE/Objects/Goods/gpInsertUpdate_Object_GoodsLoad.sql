-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLoad(Integer, TVarChar, Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLoad(Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLoad(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inMainCode            INTEGER   ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inObjectId            Integer   ,    -- Торговая сеть
    IN inMeasureName         TVarChar  ,    -- ссылка на единицу измерения
    IN inNDS                 TFloat    ,    -- НДС

    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS integer AS
$BODY$
  DECLARE vbNDSKindId Integer;
  DECLARE vbUserId Integer;
  DECLARE vbGoodsMainId Integer;
  DECLARE vbLinkId Integer;
  DECLARE vbMeasureId Integer;
BEGIN

    vbUserId := inSession;

    IF inNDS = 20 THEN 
       vbNDSKindId  := zc_Enum_NDSKind_Common();
    ELSE
       vbNDSKindId  := zc_Enum_NDSKind_Medical();
    END IF; 

    IF COALESCE(ioId, 0) = 0 THEN
       SELECT Object_Goods_View.Id INTO ioId
         FROM Object_Goods_View 
        WHERE Object_Goods_View.ObjectId = inObjectId
          AND Object_Goods_View.GoodsCode = inCode;   
    END IF; 

    SELECT Id INTO vbMeasureId
      FROM Object 
     WHERE DescId = zc_Object_Measure() AND ValueData = inMeasureName;

    IF COALESCE(vbMeasureId, 0) = 0 THEN
       vbMeasureId := gpInsertUpdate_Object_Measure(0, 0, inMeasureName, inSession); 
    END IF;


    ioId := lpInsertUpdate_Object_Goods(ioId, inCode, inName, 0, vbMeasureId, vbNDSKindId, inObjectId, vbUserId);

     SELECT Id INTO vbGoodsMainId FROM Object_Goods_Main_View
      WHERE GoodsCode = inMainCode;

     SELECT Id INTO vbLinkId 
       FROM Object_LinkGoods_View
      WHERE Object_LinkGoods_View.GoodsMainId = vbGoodsMainId 
        AND Object_LinkGoods_View.GoodsId = ioId;

     IF COALESCE(vbLinkId, 0) = 0 THEN
                 PERFORM gpInsertUpdate_Object_LinkGoods(
                                   ioId := 0                     ,  
                                   inGoodsMainId := vbGoodsMainId, -- Главный товар
                                   inGoodsId  := ioId            , -- Товар сети
                                   inSession  := inSession         -- сессия пользователя
                                   );
     END IF;  


END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLoad(Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.14                        *
 28.08.14                        *
 30.07.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
