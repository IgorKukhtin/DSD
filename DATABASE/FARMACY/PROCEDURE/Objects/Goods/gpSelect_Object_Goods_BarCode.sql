-- Function: gpSelect_Object_Goods_BarCode()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_BarCode(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_BarCode(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, BarCode TVarChar, IsErrorBarCode Boolean
              ) AS
$BODY$ 
  DECLARE vbUserId Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   RETURN QUERY 
   SELECT Object_Goods_BarCode.Id                                                                AS ID
        , ObjectLink_Main_BarCode.ChildObjectId                                                  AS GoodsMainId
        , Object_Goods_BarCode.ValueData                                                         AS BarCode
        , not zfCheck_BarCode(Object_Goods_BarCode.ValueData, False)                             AS IsErrorBarCode
   FROM ObjectLink AS ObjectLink_Main_BarCode
        JOIN ObjectLink AS ObjectLink_Child_BarCode
                        ON ObjectLink_Child_BarCode.ObjectId = ObjectLink_Main_BarCode.ObjectId
                       AND ObjectLink_Child_BarCode.DescId = zc_ObjectLink_LinkGoods_Goods()
        JOIN ObjectLink AS ObjectLink_Goods_Object_BarCode
                        ON ObjectLink_Goods_Object_BarCode.ObjectId = ObjectLink_Child_BarCode.ChildObjectId
                       AND ObjectLink_Goods_Object_BarCode.DescId = zc_ObjectLink_Goods_Object()
                       AND ObjectLink_Goods_Object_BarCode.ChildObjectId = zc_Enum_GlobalConst_BarCode()
        LEFT JOIN Object AS Object_Goods_BarCode ON Object_Goods_BarCode.Id = ObjectLink_Goods_Object_BarCode.ObjectId
   WHERE ObjectLink_Main_BarCode.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
     AND ObjectLink_Main_BarCode.ChildObjectId > 0
     AND TRIM (Object_Goods_BarCode.ValueData) <> '';
       
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.  Шаблий О.В.
 16.06.19                                                                     *
*/

-- тест
-- select * from gpSelect_Object_Goods_BarCode (inSession := '59591')