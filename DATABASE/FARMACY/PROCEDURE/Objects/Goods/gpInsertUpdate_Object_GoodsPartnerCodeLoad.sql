
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPartnerCodeLoad(TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPartnerCodeLoad(
    IN inOKPO                TVarChar  ,    -- ОКПО
    IN inMainCode            Integer   ,    -- Код товара
    IN inGoodsCode           TVarChar  ,    -- Код товара партнера
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
DECLARE vbJuridicalId Integer;
DECLARE vbGoodsMainId Integer;
BEGIN

   SELECT Id INTO vbGoodsMainId
     FROM Object_Goods_Main_View
    WHERE Object_Goods_Main_View.GoodsCode = inMainCode;

      SELECT JuridicalId INTO vbJuridicalId
        FROM ObjectHistory_JuridicalDetails_View
       WHERE OKPO = inOKPO;
   
   IF (COALESCE(vbGoodsMainId, 0) <> 0) AND (COALESCE(vbJuridicalId, 0) <> 0) THEN
      PERFORM gpInsertUpdate_Object_GoodsLink(0, inGoodsCode, inGoodsCode, vbGoodsMainId, vbJuridicalId, inSession);
   END IF;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsPartnerCodeLoad(TVarChar, Integer, TVarChar, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.07.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
