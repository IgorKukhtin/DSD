-- Function: gpSelect_Object_GoodsAll_Retail_Tab()

DROP FUNCTION IF EXISTS gpSelect_GoodsAll_Retail_Tab (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsAll_Retail_Tab(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, CodeStr TVarChar, Name TVarChar, isErased Boolean,
               LinkId Integer, GoodsMainId Integer,
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               NDS TFloat, MinimumLot TFloat,
               isClose Boolean, isTOP Boolean, isPromo Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean,
               isUpload Boolean, isSpecCondition Boolean,
               PercentMarkup TFloat, Price TFloat,
               ReferCode TFloat, ReferPrice TFloat,
               ObjectDescId Integer, ObjectDescName TVarChar, ObjectName TVarChar,
               MakerName TVarChar, MakerLinkName TVarChar,
               ConditionsKeepName TVarChar,
               AreaName TVarChar,
               CodeMarion Integer, CodeMarionStr TVarChar, NameMarion TVarChar, OrdMarion Integer,
               CodeBar Integer, NameBar TVarChar, OrdBar Integer
              ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- для остальных...
   RETURN QUERY
    WITH tmpMarion AS (SELECT ObjectLink_Main.ChildObjectId AS GoodsMainId
                            , Object_Goods.ObjectCode       AS GoodsCode
                            , Object_Goods.ValueData        AS GoodsName
                            , ObjectString.ValueData        AS GoodsCodeStr
                              --  № п/п
                            , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Main.ChildObjectId ORDER BY Object_Goods.ObjectCode DESC) AS Ord

                       FROM ObjectLink AS ObjectLink_Goods_Object -- связь с Юридические лица или Торговая сеть или ...
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                            -- получается GoodsMainId
                            LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                            LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                            LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_Goods.Id
                                                  AND ObjectString.DescId   = zc_ObjectString_Goods_Code()
                       WHERE ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                         AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_Marion()
                         AND ObjectLink_Main.ChildObjectId > 0 -- !!!убрали безликие!!!
                      )
      , tmpBarCode AS (SELECT ObjectLink_Main.ChildObjectId AS GoodsMainId
                            , Object_Goods.ObjectCode       AS GoodsCode
                            , Object_Goods.ValueData        AS GoodsName
                              --  № п/п
                            , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Main.ChildObjectId ORDER BY Object_Goods.ObjectCode DESC) AS Ord

                       FROM ObjectLink AS ObjectLink_Goods_Object -- связь с Юридические лица или Торговая сеть или ...
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId
                            -- получается GoodsMainId
                            LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods.Id
                                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                            LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                       WHERE ObjectLink_Goods_Object.DescId        = zc_ObjectLink_Goods_Object()
                         AND ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_BarCode()
                         AND ObjectLink_Main.ChildObjectId > 0 -- !!!убрали безликие!!!
                      )
      , tmpObject_Goods_Retail AS (SELECT * FROM Object_Goods_Retail 
--limit 100
                                  )

   -- Результат
   SELECT
             Object_Goods.Id
           , Object_Goods.ObjectCode            AS Code
           , ObjectString_Goods_Code.ValueData  AS CodeStr
           , Object_Goods.ValueData             AS Name
           , Object_Goods.isErased

           , 0/*ObjectLink_Main.ObjectId*/   AS LinkId
           , Object_Goods_Retail.GoodsMainId AS GoodsMainId
           , Object_GoodsGroup.Id          AS GoodsGroupId
           , Object_GoodsGroup.ValueData   AS GoodsGroupName
           , Object_Measure.Id             AS MeasureId
           , Object_Measure.ValueData      AS MeasureName

           , Object_NDSKind.Id                 AS NDSKindId
           , Object_NDSKind.ValueData          AS NDSKindName
           , ObjectFloat_NDSKind_NDS.ValueData AS NDS

           , Object_Goods_Retail.MinimumLot

           , ObjectBoolean_Goods_Close.ValueData    AS isClose
           , Object_Goods_Retail.isTOP

           , ObjectBoolean_Goods_IsPromo.ValueData  AS IsPromo
           , Object_Goods_Retail.isFirst
           , Object_Goods_Retail.isSecond

           , ObjectBoolean_Published.ValueData            AS isPublished
           , ObjectBoolean_Goods_IsUpload.ValueData       AS IsUpload
           , ObjectBoolean_Goods_SpecCondition.ValueData  AS IsSpecCondition

           , Object_Goods_Retail.PercentMarkup
           , Object_Goods_Retail.Price

           , ObjectFloat_Goods_ReferCode.ValueData     AS ReferCode
           , ObjectFloat_Goods_ReferPrice.ValueData    AS ReferPrice


           , ObjectDesc_GoodsObject.Id          AS  ObjectDescId
           , ObjectDesc_GoodsObject.itemname    AS  ObjectDescName
           , Object_GoodsObject.ValueData       AS  ObjectName

           , ObjectString_Goods_Maker.ValueData AS MakerName
           , Object_Maker.ValueData             AS MakerLinkName
           , Object_ConditionsKeep.ValueData    AS ConditionsKeepName
           , Object_Area.ValueData              AS AreaName

           , tmpMarion.GoodsCode       AS CodeMarion
           , tmpMarion.GoodsCodeStr    AS CodeMarionStr
           , tmpMarion.GoodsName       AS NameMarion
           , tmpMarion.Ord  :: Integer AS OrdMarion

           , tmpBarCode.GoodsCode      AS CodeBar
           , tmpBarCode.GoodsName      AS NameBar
           , tmpBarCode.Ord :: Integer AS OrdBar

    FROM tmpObject_Goods_Retail AS Object_Goods_Retail
         LEFT JOIN Object AS Object_Goods
                          ON Object_Goods.Id = Object_Goods_Retail.Id
                         AND Object_Goods.DescId = zc_Object_Goods()

         -- String ...
         LEFT JOIN ObjectString AS ObjectString_Goods_Code
                                ON ObjectString_Goods_Code.ObjectId = Object_Goods.Id
                               AND ObjectString_Goods_Code.DescId = zc_ObjectString_Goods_Code()
         LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                ON ObjectString_Goods_Maker.ObjectId = Object_Goods.Id
                               AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()

         -- ObjectLink ...
         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                              ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
         LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Maker
                              ON ObjectLink_Goods_Maker.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Maker.DescId = zc_ObjectLink_Goods_Maker()
         LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Goods_Maker.ChildObjectId

        -- НДС
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                            --AND 1=0
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                             --AND 1=0

        -- связь с Юридические лица или Торговая сеть или ...
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                             ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
        LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
        LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

        -- Float ...
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferCode
                              ON ObjectFloat_Goods_ReferCode.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Goods_ReferCode.DescId = zc_ObjectFloat_Goods_ReferCode()
                             AND 1=0
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferPrice
                              ON ObjectFloat_Goods_ReferPrice.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Goods_ReferPrice.DescId = zc_ObjectFloat_Goods_ReferPrice()
                             AND 1=0

        -- Boolean ...
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods.Id
                               AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()
                              -- AND 1=0

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                ON ObjectBoolean_Goods_IsPromo.ObjectId = Object_Goods.Id
                               AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()
                               --AND 1=0

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Published
                                ON ObjectBoolean_Published.ObjectId = Object_Goods.Id
                               AND ObjectBoolean_Published.DescId = zc_ObjectBoolean_Goods_Published()
                               AND 1=0

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUpload
                                  ON ObjectBoolean_Goods_IsUpload.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_IsUpload.DescId = zc_ObjectBoolean_Goods_IsUpload()
                                 AND 1=0
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                  ON ObjectBoolean_Goods_SpecCondition.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()
                                 AND 1=0

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isMain
                                  ON ObjectBoolean_Goods_isMain.ObjectId = Object_Goods.Id
                                 AND ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                                 AND ObjectBoolean_Goods_isMain.ValueData = TRUE

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                               ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
          LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                               ON ObjectLink_Goods_Area.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

          LEFT JOIN tmpMarion ON tmpMarion.GoodsMainId = Object_Goods_Retail.GoodsMainId
                              AND tmpMarion.Ord         = 1
                              --AND 1=0
          LEFT JOIN tmpBarCode ON tmpBarCode.GoodsMainId = Object_Goods_Retail.GoodsMainId
                              AND tmpBarCode.Ord         = 1
                              --AND 1=0

    WHERE ObjectBoolean_Goods_isMain.ObjectId IS NULL
      AND COALESCE (Object_GoodsObject.DescId, 0) IN (0, zc_Object_Retail())
      AND COALESCE (Object_GoodsObject.Id, 0) IN (0, 4) -- Не болей
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.10.19         *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsAll_Retail_Tab (zfCalc_UserAdmin())
