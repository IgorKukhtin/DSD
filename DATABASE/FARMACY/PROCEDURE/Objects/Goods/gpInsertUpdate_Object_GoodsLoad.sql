-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsLoad(Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsLoad(
    IN ioId                  Integer   , 
    IN inOKPO                TVarChar  ,    -- ОКПО
    IN inObjectId            Integer   , 
    IN inMainCode            Integer   ,    -- Код товара
    IN inGoodsCode           TVarChar  ,    -- Код товара партнера
    IN inGoodsName           TVarChar  ,    -- Название товара партнера
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
DECLARE vbJuridicalId Integer;
DECLARE vbGoodsMainId Integer;
BEGIN

   SELECT Id INTO vbGoodsMainId
     FROM Object_Goods_View
    WHERE Object_Goods_View.GoodsCodeInt = inMainCode
      AND Object_Goods_View.ObjectId IS Null;

   IF COALESCE(inObjectId, 0) = 0 THEN
      SELECT JuridicalId INTO vbJuridicalId
        FROM ObjectHistory_JuridicalDetails_View
       WHERE OKPO = inOKPO;
   ELSE
      vbJuridicalId := inObjectId;
   END IF;
   
   IF (COALESCE(vbGoodsMainId, 0) <> 0) AND (COALESCE(vbJuridicalId, 0) <> 0) THEN
      ioId := gpInsertUpdate_Object_GoodsLink(ioId, inGoodsCode, inGoodsName, vbGoodsMainId, vbJuridicalId, inSession);
   END IF;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsLoad(Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
