-- Function: gpGet_Object_Goods_BarCode()

DROP FUNCTION IF EXISTS gpGet_Object_Goods_BarCode(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Goods_BarCode(
    IN inId          Integer  ,  -- Товар нашей сети
    IN inGoodsMainId Integer  ,  -- Главный товар (если товар не задан, то ищем по главному)
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsMainId Integer   
             , BarCode TVarChar
             , isErased Boolean   
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbGoodsId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);
  
      IF (COALESCE (inId, 0) = 0) AND (COALESCE (inGoodsMainId, 0) = 0)
      THEN
           -- Результат
           RETURN QUERY
             SELECT 0::Integer   AS Id
                  , ''::TVarChar AS BarCode
                  , FALSE        AS isErased
             ; 

      ELSE
           IF (COALESCE (inId, 0) = 0)
           THEN
                -- определяется <Торговая сеть>
                vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

                SELECT ObjectLink_LinkGoods_Goods.ChildObjectId AS GoodsId
                INTO vbGoodsId 
                FROM ObjectLink AS ObjectLink_LinkGoods_GoodsMain
                     JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                     ON ObjectLink_LinkGoods_Goods.ObjectId = ObjectLink_LinkGoods_GoodsMain.ObjectId
                                    AND ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                     JOIN ObjectLink AS ObjectLink_Goods_Object
                                     ON ObjectLink_Goods_Object.ObjectId = ObjectLink_LinkGoods_Goods.ChildObjectId
                                    AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                    AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                WHERE ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                  AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = inGoodsMainId;
           ELSE
                vbGoodsId:= inId;
           END IF;

           -- Результат
           RETURN QUERY 
             WITH tmpGoodsMain AS (SELECT ObjectLink_Main.ChildObjectId  AS GoodsMainId
                                        , ObjectLink_Child.ChildObjectId AS GoodsId
                                        , COALESCE (Object_Goods.isErased, FALSE)::Boolean AS isErased
                                   FROM ObjectLink AS ObjectLink_Child 
                                        JOIN ObjectLink AS ObjectLink_Main 
                                                        ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                       AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Child.ChildObjectId
                                   WHERE ObjectLink_Child.ChildObjectId = vbGoodsId
                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                                  )
                , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId          AS GoodsMainId
                                           , STRING_AGG (Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc) AS BarCode
                                           --, MAX (Object_Goods_BarCode.ValueData)::TVarChar AS BarCode
                                      FROM ObjectLink AS ObjectLink_Main_BarCode
                                           JOIN tmpGoodsMain ON tmpGoodsMain.GoodsMainId = ObjectLink_Main_BarCode.ChildObjectId
                                           JOIN ObjectLink AS ObjectLink_Child_BarCode
                                                           ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                                                          AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
                                           JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                                                           ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                                                          AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                                                          AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                                           LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
                                      WHERE ObjectLink_Main_BarCode.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                      GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                                     )                  
             SELECT tmpGoodsMain.GoodsId AS Id 
                  , tmpGoodsMain.GoodsMainId 
                  , COALESCE (tmpGoodsBarCode.BarCode, '')::TVarChar AS BarCode
                  , tmpGoodsMain.isErased
             FROM tmpGoodsMain
                  -- определяем штрих-код производителя
                  LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = tmpGoodsMain.GoodsMainId
             ;
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 20.06.17                                                       *
*/

-- тест
/*
SELECT *, 'By GoodsId' AS MethodType FROM gpGet_Object_Goods_BarCode (43813, 0, zfCalc_UserAdmin())
UNION ALL
SELECT *, 'By GoodsMainId' AS MethodType FROM gpGet_Object_Goods_BarCode (0, 43812, zfCalc_UserAdmin())
*/