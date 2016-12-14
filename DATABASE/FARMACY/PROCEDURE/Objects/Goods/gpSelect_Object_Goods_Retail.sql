-- Function: gpSelect_Object_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Retail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, IdBarCode TVarChar, Name TVarChar, isErased Boolean
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , NDS TFloat, MinimumLot TFloat, isClose Boolean
             , isTOP Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean
             , PercentMarkup TFloat, Price TFloat
             , Color_calc Integer
             , RetailCode Integer, RetailName TVarChar
             , isPromo boolean
             , InsertName TVarChar, InsertDate TDateTime 
             , UpdateName TVarChar, UpdateDate TDateTime
              ) AS
$BODY$ 
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- поиск <Торговой сети>
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- !!!для Админа!!!
   IF (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
   RETURN QUERY 
-- Маркетинговый контракт
  WITH  GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                                      , ObjectLink_Goods_Object.ChildObjectId AS ObjectId
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                       --  AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                         )

   SELECT 
             Object_Goods_View.Id
           , Object_Goods_View.GoodsCodeInt
--           , ObjectString.ValueData                           AS GoodsCode
           , zfFormat_BarCode(zc_BarCodePref_Object(), ObjectLink_Main.ChildObjectId) AS IdBarCode
           , Object_Goods_View.GoodsName
           , Object_Goods_View.isErased
           , Object_Goods_View.GoodsGroupId
           , Object_Goods_View.GoodsGroupName
           , Object_Goods_View.MeasureId
           , Object_Goods_View.MeasureName
           , Object_Goods_View.NDSKindId
           , Object_Goods_View.NDSKindName
           , Object_Goods_View.NDS
           , Object_Goods_View.MinimumLot
           , Object_Goods_View.isClose
           , Object_Goods_View.isTOP          
           , Object_Goods_View.isFirst 
           , Object_Goods_View.isSecond
           , Object_Goods_View.isPublished
           -- , CASE WHEN Object_Goods_View.isPublished = FALSE THEN NULL ELSE Object_Goods_View.isPublished END :: Boolean AS isPublished
           , Object_Goods_View.PercentMarkup  
           , Object_Goods_View.Price
           , CASE WHEN Object_Goods_View.isSecond = TRUE THEN 16440317 WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc  --16380671   10965163 
           , Object_Retail.ObjectCode AS RetailCode
           , Object_Retail.ValueData  AS RetailName
           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

           , COALESCE(Object_Insert.ValueData, '')         ::TVarChar  AS InsertName
           , COALESCE(ObjectDate_Insert.ValueData, Null)   ::TDateTime AS InsertDate
           , COALESCE(Object_Update.ValueData, '')         ::TVarChar  AS UpdateName
           , COALESCE(ObjectDate_Update.ValueData, Null)   ::TDateTime AS UpdateDate

    FROM Object AS Object_Retail
         INNER JOIN Object_Goods_View ON Object_Goods_View.ObjectId = Object_Retail.Id
         LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id 
                             AND GoodsPromo.ObjectId = Object_Goods_View.ObjectId 
         LEFT JOIN ObjectDate AS ObjectDate_Insert
                              ON ObjectDate_Insert.ObjectId = Object_Goods_View.Id
                             AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
         LEFT JOIN ObjectLink AS ObjectLink_Insert
                              ON ObjectLink_Insert.ObjectId = Object_Goods_View.Id
                             AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

         LEFT JOIN ObjectDate AS ObjectDate_Update
                              ON ObjectDate_Update.ObjectId = Object_Goods_View.Id
                             AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
         LEFT JOIN ObjectLink AS ObjectLink_Update
                              ON ObjectLink_Update.ObjectId = Object_Goods_View.Id
                             AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
         LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

        -- получается GoodsMainId
        LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id --Object_Goods.Id
                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
        LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

    WHERE Object_Retail.DescId = zc_Object_Retail();

   ELSE

   -- для остальных...

   RETURN QUERY 
  -- Маркетинговый контракт
  WITH  GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
                         --   , tmp.ChangePercent
                       FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                   AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                                    AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                         )
   SELECT 
             Object_Goods_View.Id
           , Object_Goods_View.GoodsCodeInt
--           , ObjectString.ValueData                           AS GoodsCode
           , zfFormat_BarCode(zc_BarCodePref_Object(), ObjectLink_Main.ChildObjectId) AS IdBarCode
           , Object_Goods_View.GoodsName
           , Object_Goods_View.isErased
           , Object_Goods_View.GoodsGroupId
           , Object_Goods_View.GoodsGroupName
           , Object_Goods_View.MeasureId
           , Object_Goods_View.MeasureName
           , Object_Goods_View.NDSKindId
           , Object_Goods_View.NDSKindName
           , Object_Goods_View.NDS
           , Object_Goods_View.MinimumLot
           , Object_Goods_View.isClose
           , Object_Goods_View.isTOP          
           , Object_Goods_View.isFirst
           , Object_Goods_View.isSecond
           , Object_Goods_View.isPublished
           -- , CASE WHEN Object_Goods_View.isPublished = FALSE THEN NULL ELSE Object_Goods_View.isPublished END :: Boolean AS isPublished
           , Object_Goods_View.PercentMarkup  
           , Object_Goods_View.Price
           , CASE WHEN Object_Goods_View.isSecond = TRUE THEN 16440317 WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc   --10965163
           , Object_Retail.ObjectCode AS RetailCode
           , Object_Retail.ValueData  AS RetailName
           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

           , COALESCE(Object_Insert.ValueData, '')         ::TVarChar  AS InsertName
           , COALESCE(ObjectDate_Insert.ValueData, Null)   ::TDateTime AS InsertDate
           , COALESCE(Object_Update.ValueData, '')         ::TVarChar  AS UpdateName
           , COALESCE(ObjectDate_Update.ValueData, Null)   ::TDateTime AS UpdateDate

    FROM Object_Goods_View
         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = Object_Goods_View.ObjectId
         LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_View.Id 

         LEFT JOIN ObjectDate AS ObjectDate_Insert
                              ON ObjectDate_Insert.ObjectId = Object_Goods_View.Id
                             AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
         LEFT JOIN ObjectLink AS ObjectLink_Insert
                              ON ObjectLink_Insert.ObjectId = Object_Goods_View.Id
                             AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

         LEFT JOIN ObjectDate AS ObjectDate_Update
                              ON ObjectDate_Update.ObjectId = Object_Goods_View.Id
                             AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
         LEFT JOIN ObjectLink AS ObjectLink_Update
                              ON ObjectLink_Update.ObjectId = Object_Goods_View.Id
                             AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
         LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

        -- получается GoodsMainId
        LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id --Object_Goods.Id
                                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
        LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

    WHERE Object_Goods_View.ObjectId = vbObjectId;

   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.12.16         *
 13.07.16         * protocol
 30.04.16         *
 12.04.16         *
 25.03.16                                        *
 16.02.15                         * 
 13.11.14                         * Add MinimumLot
 24.06.14         *
 20.06.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods_Retail (zfCalc_UserAdmin())
