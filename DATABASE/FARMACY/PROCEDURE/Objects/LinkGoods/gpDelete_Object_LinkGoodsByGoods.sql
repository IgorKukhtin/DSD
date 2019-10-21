-- Function: gpInsertUpdate_Object_LinkGoods(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_LinkGoodsByGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_LinkGoodsByGoods(
    IN inGoodsId          Integer   , -- товар
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbId           Integer;
   DECLARE vbGoodsId      Integer;
   DECLARE vbGoodsMainId  Integer;
   DECLARE vbObjectId     Integer;
   DECLARE text_var1      text;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());
   vbUserId := lpGetUserBySession(inSession);

   SELECT Id INTO vbId 
     FROM Object_LinkGoods_View WHERE GoodsId = inGoodsId;
                             
    -- Сохранили в плоскую таблицй
   BEGIN
    
      SELECT ObjectLink.ChildObjectId   
           , ObjectLink_Goods_Object.ChildObjectId
           , ObjectLink_LinkGoods_GoodsMain.ChildObjectId
      INTO vbGoodsId, vbObjectId, vbGoodsMainId
      FROM ObjectLink 
           LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                ON ObjectLink_Goods_Object.ObjectId = ObjectLink.ChildObjectId
                               AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
           LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                                ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink.ObjectId
                               AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
      WHERE ObjectLink.ObjectId = vbId
        AND ObjectLink.DescId = zc_ObjectLink_LinkGoods_Goods();

      PERFORM lpDelete_Object_Goods_Link(vbGoodsId, vbGoodsMainId, vbObjectId, vbUserId);
   EXCEPTION
       WHEN others THEN
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
         PERFORM lpAddObject_Goods_Temp_Error('gpDelete_Object_LinkGoodsByGoods', text_var1::TVarChar, vbUserId);
   END;

   PERFORM lpDelete_Object(vbId, inSession);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_Object_LinkGoodsByGoods (Integer, TVarChar) OWNER TO postgres;

  
---------------------------------------------------------------------------------------
/* ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.19                                                      *
 05.11.14                         *
  
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
