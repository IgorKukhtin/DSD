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
   DECLARE vbGoodsId     Integer;
   DECLARE vbId          Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());

     -- поиск
     --vbGoodsMainId:= (SELECT Id FROM Object_Goods_Main_View WHERE GoodsCode = inGoodsMainCode :: Integer);
     vbGoodsMainId := (SELECT ObjectBoolean_Goods_isMain.ObjectId
                       FROM Object AS Object_Goods 
                            INNER JOIN ObjectBoolean AS ObjectBoolean_Goods_isMain 
                                                     ON ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                                                    AND ObjectBoolean_Goods_isMain.ObjectId = Object_Goods.Id
                       WHERE Object_Goods.DescId = zc_Object_Goods()
                         AND Object_Goods.ObjectCode  = inGoodsMainCode :: Integer
                       );
     -- поиск
     --vbGoodsId:= (SELECT Id FROM Object_Goods_View WHERE ObjectId = inRetailId AND GoodsCode = inGoodsCode);
     vbGoodsId := (SELECT ObjectLink_Goods_Object.ObjectId
                   FROM ObjectLink AS ObjectLink_Goods_Object
                        LEFT JOIN Object AS Object_Goods 
                                         ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                                        AND Object_Goods.DescId = zc_Object_Goods()
                        INNER JOIN ObjectString ON ObjectString.ObjectId = ObjectLink_Goods_Object.ObjectId
                                              AND ObjectString.DescId = zc_ObjectString_Goods_Code()
                                              AND ObjectString.ValueData = inGoodsCode
                   WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                     AND ObjectLink_Goods_Object.ChildObjectId = inRetailId
                   );

     -- проверка
     IF COALESCE (vbGoodsMainId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Главный товар не определен.Главный код = <%> и Код = <%>', inGoodsMainCode, inGoodsCode;
     END IF; 
     -- проверка
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Товар не определен.Главный код = <%> и Код = <%>', inGoodsMainCode, inGoodsCode;
     END IF; 

     -- поиск
     vbId:= (SELECT Id FROM Object_LinkGoods_View WHERE Object_LinkGoods_View.GoodsMainId = vbGoodsMainId 
                                                    AND Object_LinkGoods_View.GoodsId = vbGoodsId);

     IF COALESCE(vbId, 0) = 0
     THEN
          PERFORM gpInsertUpdate_Object_LinkGoods (ioId          := 0
                                                 , inGoodsMainId := vbGoodsMainId -- Главный товар
                                                 , inGoodsId     := vbGoodsId     -- Товар для замены
                                                 , inSession     := inSession     -- сессия пользователя
                                                  );
     END IF;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_LinkGoods_Load (TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;
  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.16                                        *
 26.08.14                         *
 15.08.14                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
