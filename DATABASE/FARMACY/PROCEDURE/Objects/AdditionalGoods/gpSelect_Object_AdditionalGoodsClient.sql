DROP FUNCTION IF EXISTS gpSelect_Object_AdditionalGoodsClient(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AdditionalGoodsClient(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (GoodsMainId Integer             
             , GoodsId Integer, GoodsCodeInt Integer, GoodsCode TVarChar, GoodsName TVarChar, MakerName TVarChar
             ) AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_AdditionalGoods());
    vbUserId := lpGetUserBySession (inSession);
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    
    RETURN QUERY 
        
        SELECT
            ObjectLink_Goods.ChildObjectId 
           ,Object_AdditionalGoodsClient.GoodsId
           ,Object_AdditionalGoodsClient.GoodsCodeInt
           ,Object_AdditionalGoodsClient.GoodsCode
           ,Object_AdditionalGoodsClient.GoodsName
           ,Object_AdditionalGoodsClient.MakerName
        FROM 
            Object_LinkGoods_View AS Object_AdditionalGoodsClient
            INNER JOIN ObjectLink AS ObjectLink_GoodsMain
                                  ON ObjectLink_GoodsMain.ChildObjectId = Object_AdditionalGoodsClient.GoodsMainId
                                 AND ObjectLink_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                 
            INNER JOIN ObjectLink AS ObjectLink_Goods
                                  ON ObjectLink_Goods.ObjectId = ObjectLink_GoodsMain.ObjectId
                                 AND ObjectLink_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                 
            INNER JOIN Object_Goods_View ON Object_Goods_View.Id = ObjectLink_Goods.ChildObjectId
                                        AND Object_Goods_View.ObjectId = vbObjectId
            
        WHERE
            Object_AdditionalGoodsClient.ObjectId <> vbObjectId
        ORDER BY
            Object_AdditionalGoodsClient.GoodsMainId
           ,Object_AdditionalGoodsClient.GoodsName;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AdditionalGoodsClient (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 11.10.15                                                                      *
*/