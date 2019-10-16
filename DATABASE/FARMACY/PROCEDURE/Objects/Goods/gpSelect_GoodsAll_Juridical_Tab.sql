-- Function: gpSelect_Object_GoodsAll_Juridical()

DROP FUNCTION IF EXISTS gpSelect_GoodsAll_Juridical_Tab(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsAll_Juridical_Tab(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, CodeStr TVarChar, Name TVarChar, isErased Boolean,
               LinkId Integer, GoodsMainId Integer,
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               NDS TFloat, MinimumLot TFloat,
               isClose Boolean, isTOP Boolean, isPromo Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean,
               isUpload Boolean, isUploadBadm Boolean, isUploadTeva Boolean, isSpecCondition Boolean,
               PercentMarkup TFloat, Price TFloat,
               ReferCode TFloat, ReferPrice TFloat,
               ObjectDescName TVarChar, ObjectName TVarChar,
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
   -- Результат
   SELECT
             Object_Goods_Juridical.Id
           , Object_Goods_Juridical.ObjectCode   AS Code
           , Object_Goods_Juridical.Code         AS CodeStr
           , Object_Goods_Juridical.Name         AS Name
           , Object_Goods_Juridical.isErased

           , 0                 AS LinkId
           , Object_Goods_Juridical.GoodsMainId AS GoodsMainId
           , Object_GoodsGroup.Id          AS GoodsGroupId
           , Object_GoodsGroup.ValueData   AS GoodsGroupName
           , Object_Measure.Id             AS MeasureId
           , Object_Measure.ValueData      AS MeasureName

           , Object_NDSKind.Id                 AS NDSKindId
           , Object_NDSKind.ValueData          AS NDSKindName

           , Object_Goods_Juridical.MinimumLot

           , ObjectBoolean_Goods_Close.ValueData    AS isClose
           , ObjectBoolean_Goods_TOP.ValueData      AS isTOP
           , Object_Goods_Juridical.IsPromo
           , ObjectBoolean_First.ValueData          AS isFirst
           , ObjectBoolean_Second.ValueData         AS isSecond
           , ObjectBoolean_Published.ValueData      AS isPublished
           , Object_Goods_Juridical.IsUpload
           , Object_Goods_Juridical.isUploadBadm
           , Object_Goods_Juridical.isUploadTeva
           , Object_Goods_Juridical.IsSpecCondition

           , ObjectFloat_Goods_PercentMarkup.ValueData AS PercentMarkup
           , ObjectFloat_Goods_Price.ValueData         AS Price
           , ObjectFloat_Goods_ReferCode.ValueData     AS ReferCode
           , ObjectFloat_Goods_ReferPrice.ValueData    AS ReferPrice

           , ObjectDesc_GoodsObject.itemname    AS  ObjectDescName
           , Object_GoodsObject.ValueData       AS  ObjectName

           , Object_Goods_Juridical.MakerName
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

    FROM Object_Goods_Juridical

         -- ObjectLink ...
         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods_Juridical.Id
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                              ON ObjectLink_Goods_Measure.ObjectId = Object_Goods_Juridical.Id
                             AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
         LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Maker
                              ON ObjectLink_Goods_Maker.ObjectId = Object_Goods_Juridical.Id
                             AND ObjectLink_Goods_Maker.DescId = zc_ObjectLink_Goods_Maker()
         LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Goods_Maker.ChildObjectId

        -- НДС
        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods_Juridical.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        -- связь с Юридические лица или Торговая сеть или ...
        LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                             ON ObjectLink_Goods_Object.ObjectId = Object_Goods_Juridical.Id
                            AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
        LEFT JOIN Object AS Object_GoodsObject ON Object_GoodsObject.Id = ObjectLink_Goods_Object.ChildObjectId
        LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_GoodsObject.DescId

        -- Float ...
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                              ON ObjectFloat_Goods_PercentMarkup.ObjectId = Object_Goods_Juridical.Id
                             AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                              ON ObjectFloat_Goods_Price.ObjectId = Object_Goods_Juridical.Id
                             AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()

        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferCode
                              ON ObjectFloat_Goods_ReferCode.ObjectId = Object_Goods_Juridical.Id
                             AND ObjectFloat_Goods_ReferCode.DescId = zc_ObjectFloat_Goods_ReferCode()
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_ReferPrice
                              ON ObjectFloat_Goods_ReferPrice.ObjectId = Object_Goods_Juridical.Id
                             AND ObjectFloat_Goods_ReferPrice.DescId = zc_ObjectFloat_Goods_ReferPrice()

        -- Boolean ...
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                ON ObjectBoolean_Goods_Close.ObjectId = Object_Goods_Juridical.Id
                               AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                ON ObjectBoolean_Goods_TOP.ObjectId = Object_Goods_Juridical.Id
                               AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_First
                                ON ObjectBoolean_First.ObjectId = Object_Goods_Juridical.Id
                               AND ObjectBoolean_First.DescId = zc_ObjectBoolean_Goods_First()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Second
                                ON ObjectBoolean_Second.ObjectId = Object_Goods_Juridical.Id
                               AND ObjectBoolean_Second.DescId = zc_ObjectBoolean_Goods_Second()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Published
                                ON ObjectBoolean_Published.ObjectId = Object_Goods_Juridical.Id
                               AND ObjectBoolean_Published.DescId = zc_ObjectBoolean_Goods_Published()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_isMain
                                  ON ObjectBoolean_Goods_isMain.ObjectId = Object_Goods_Juridical.Id
                                 AND ObjectBoolean_Goods_isMain.DescId = zc_ObjectBoolean_Goods_isMain()
                                 AND ObjectBoolean_Goods_isMain.ValueData = TRUE

          LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Juridical.ConditionsKeepId
          LEFT JOIN Object AS Object_Area ON Object_Area.Id = Object_Goods_Juridical.AreaId

          LEFT JOIN tmpMarion ON tmpMarion.GoodsMainId = Object_Goods_Juridical.GoodsMainId
                              AND tmpMarion.Ord         = 1
          LEFT JOIN tmpBarCode ON tmpBarCode.GoodsMainId = Object_Goods_Juridical.GoodsMainId
                              AND tmpBarCode.Ord         = 1

    WHERE ObjectBoolean_Goods_isMain.ObjectId IS NULL
      AND (Object_GoodsObject.DescId = zc_Object_Juridical()
        OR ObjectLink_Goods_Object.ChildObjectId = zc_Enum_GlobalConst_Marion()
          )
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
-- SELECT * FROM gpSelect_GoodsAll_Juridical_Tab (zfCalc_UserAdmin()) WHERE Id IN (6035413, 6035413)
