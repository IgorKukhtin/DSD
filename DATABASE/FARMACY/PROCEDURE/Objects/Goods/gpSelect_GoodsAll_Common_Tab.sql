-- Function: gpSelect_Object_GoodsAll_Common()

DROP FUNCTION IF EXISTS gpSelect_GoodsAll_Common_Tab(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsAll_Common_Tab(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean,
               GoodsMainId Integer,
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               isClose Boolean, isTOP Boolean, isPromo Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean,
               isUpload Boolean, isSpecCondition Boolean,
               ReferCode TFloat, ReferPrice TFloat,
               MakerName TVarChar,
               ConditionsKeepName TVarChar,
               AreaName TVarChar,
               CodeMarion Integer,
               CodeMarionStr TVarChar, NameMarion TVarChar, OrdMarion Integer,
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
    WITH 
       tmpMarion AS (SELECT ObjectLink_Main.ChildObjectId AS GoodsMainId
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
                         AND 1=0
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
                         AND 1=0
                      )
      , tmpObject_Goods AS (SELECT *
                            FROM Object_Goods 
                          --limit 1000
                            )

   -- Результат
   SELECT
             Object_Goods_Common.Id             AS Id
           , Object_Goods_Common.ObjectCode     AS Code
           , Object_Goods_Common.Name           AS Name
           , Object_Goods_Common.isErased

           , Object_Goods_Common.Id        AS GoodsMainId
           , Object_GoodsGroup.Id          AS GoodsGroupId
           , Object_GoodsGroup.ValueData   AS GoodsGroupName
           , Object_Measure.Id             AS MeasureId
           , Object_Measure.ValueData      AS MeasureName         --10

           , Object_NDSKind.Id                 AS NDSKindId
           , Object_NDSKind.ValueData          AS NDSKindName

           , Object_Goods_Common.isClose            AS isClose
           , ObjectBoolean_Goods_TOP.ValueData      AS isTOP
           , ObjectBoolean_Goods_IsPromo.ValueData  AS IsPromo
           , ObjectBoolean_First.ValueData          AS isFirst
           , ObjectBoolean_Second.ValueData         AS isSecond
           , Object_Goods_Common.isPublished
           , ObjectBoolean_Goods_IsUpload.ValueData       AS IsUpload                   -- 20
           , ObjectBoolean_Goods_SpecCondition.ValueData  AS IsSpecCondition

           , Object_Goods_Common.ReferCode  ::TFloat
           , Object_Goods_Common.ReferPrice ::TFloat

           , Object_Goods_Common.MakerName      AS MakerName
           , Object_ConditionsKeep.ValueData    AS ConditionsKeepName
           , Object_Area.ValueData              AS AreaName

           , tmpMarion.GoodsCode   ::Integer     AS CodeMarion
           , tmpMarion.GoodsCodeStr    AS CodeMarionStr                              --30
           , tmpMarion.GoodsName       AS NameMarion
           , tmpMarion.Ord  :: Integer AS OrdMarion

           , tmpBarCode.GoodsCode   ::Integer   AS CodeBar
           , tmpBarCode.GoodsName      AS NameBar
           , tmpBarCode.Ord :: Integer AS OrdBar

    FROM tmpObject_Goods AS Object_Goods_Common

         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Common.GoodsGroupId
         LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = Object_Goods_Common.MeasureId
         LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Common.ConditionsKeepId
         LEFT JOIN Object AS Object_NDSKind    ON Object_NDSKind.Id    = Object_Goods_Common.NDSKindId

        -- Boolean ...
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods_Common.Id
                               AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsPromo
                                ON ObjectBoolean_Goods_IsPromo.ObjectId = Object_Goods_Common.Id
                               AND ObjectBoolean_Goods_IsPromo.DescId = zc_ObjectBoolean_Goods_Promo()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                ON ObjectBoolean_First.ObjectId = Object_Goods_Common.Id
                               AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                ON ObjectBoolean_Second.ObjectId = Object_Goods_Common.Id
                               AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()
        
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_IsUpload
                                  ON ObjectBoolean_Goods_IsUpload.ObjectId = Object_Goods_Common.Id
                                 AND ObjectBoolean_Goods_IsUpload.DescId = zc_ObjectBoolean_Goods_IsUpload()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SpecCondition
                                  ON ObjectBoolean_Goods_SpecCondition.ObjectId = Object_Goods_Common.Id
                                 AND ObjectBoolean_Goods_SpecCondition.DescId = zc_ObjectBoolean_Goods_SpecCondition()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Area
                               ON ObjectLink_Goods_Area.ObjectId = Object_Goods_Common.Id
                              AND ObjectLink_Goods_Area.DescId = zc_ObjectLink_Goods_Area()
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId

          LEFT JOIN tmpMarion ON tmpMarion.GoodsMainId = Object_Goods_Common.Id
                             -- AND tmpMarion.Ord         = 1
          LEFT JOIN tmpBarCode ON tmpBarCode.GoodsMainId = Object_Goods_Common.Id
                             -- AND tmpBarCode.Ord         = 1
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
-- SELECT * FROM gpSelect_GoodsAll_Common_Tab (zfCalc_UserAdmin())
