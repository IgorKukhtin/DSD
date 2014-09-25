-- Function: gpInsertUpdate_Object_LinkGoods_Load(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LinkGoods_Load (TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LinkGoods_Load(
    IN inGoodsMainCode    TVarChar  , -- Главный товар
    IN inGoodsCode        TVarChar  , -- Товар для замены
    IN inRetailId         Integer   , -- Торговая сеть
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsMainId Integer;
   DECLARE vbGoodsId  Integer;
   DECLARE vbId  Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
--   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());

     SELECT Id INTO vbGoodsMainId FROM Object_Goods_Main_View
      WHERE GoodsCode = inGoodsMainCode::Integer;

     SELECT Id INTO vbGoodsId FROM Object_Goods_View
      WHERE ObjectId = inRetailId AND GoodsCode = inGoodsCode;

     SELECT Id INTO vbId 
       FROM Object_LinkGoods_View
      WHERE Object_LinkGoods_View.GoodsMainId = vbGoodsMainId 
        AND Object_LinkGoods_View.GoodsId = vbGoodsId;

     IF COALESCE(vbId, 0) = 0 THEN

                 PERFORM gpInsertUpdate_Object_LinkGoods(
                                   ioId := 0                     ,  
                                   inGoodsMainId := vbGoodsMainId, -- Главный товар
                                   inGoodsId  := vbGoodsId       , -- Товар для замены
                                   inSession  := inSession         -- сессия пользователя
                                   );
     END IF;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_LinkGoods_Load (TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.08.14                         *
 15.08.14                         *
  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
