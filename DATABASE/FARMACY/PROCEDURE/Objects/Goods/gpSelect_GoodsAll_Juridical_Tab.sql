-- Function: gpSelect_Object_GoodsAll_Juridical()

DROP FUNCTION IF EXISTS gpSelect_GoodsAll_Juridical_Tab(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsAll_Juridical_Tab(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, CodeStr TVarChar, Name TVarChar, isErased Boolean,
               GoodsMainId Integer,
               GoodsGroupId Integer, GoodsGroupName TVarChar,
               MeasureId Integer, MeasureName TVarChar,
               NDSKindId Integer, NDSKindName TVarChar,
               MinimumLot TFloat,
               isClose Boolean, isTOP Boolean, isPromo Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean,
               isUpload Boolean, isUploadBadm Boolean, isUploadTeva Boolean, isSpecCondition Boolean,
               PercentMarkup TFloat, Price TFloat,
               ReferCode TFloat, ReferPrice TFloat,
               ObjectDescName TVarChar, ObjectName TVarChar,
               MakerName TVarChar,
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
                         AND 1=0
                      )
      , tmpBarCode AS (SELECT Object_Goods_BarCode.GoodsMainId AS GoodsMainId
                            , Object_Goods.ObjectCode          AS GoodsCode
                            , Object_Goods.ValueData           AS GoodsName
                              --  № п/п
                            , ROW_NUMBER() OVER (PARTITION BY Object_Goods_BarCode.GoodsMainId ORDER BY Object_Goods.ObjectCode DESC) AS Ord
                       FROM Object_Goods_BarCode
                            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Object_Goods_BarCode.BarCodeId
                      )
   -- Результат
   SELECT
             Object_Goods_Juridical.Id
           , Object_Goods_Main.ObjectCode   AS Code
           , '' ::TVarChar                  AS CodeStr
           , Object_Goods_Main.Name         AS Name
           , Object_Goods_Main.isErased

           , Object_Goods_Juridical.GoodsMainId AS GoodsMainId
           , Object_GoodsGroup.Id               AS GoodsGroupId
           , Object_GoodsGroup.ValueData        AS GoodsGroupName
           , Object_Measure.Id                  AS MeasureId
           , Object_Measure.ValueData           AS MeasureName

           , Object_NDSKind.Id                  AS NDSKindId
           , Object_NDSKind.ValueData           AS NDSKindName

           , Object_Goods_Juridical.MinimumLot

           , Object_Goods_Main.isClose
           , NULL :: Boolean      AS isTOP
           , Object_Goods_Juridical.isPromo
           , NULL :: Boolean      AS isFirst
           , NULL :: Boolean      AS isSecond
           , Object_Goods_Main.isPublished
           , Object_Goods_Juridical.IsUpload
           , Object_Goods_Juridical.isUploadBadm
           , Object_Goods_Juridical.isUploadTeva
           , Object_Goods_Juridical.IsSpecCondition

           , 0 :: TFloat AS PercentMarkup
           , 0 :: TFloat AS Price
           , 0 :: TFloat AS ReferCode
           , 0 :: TFloat AS ReferPrice

           , ObjectDesc_GoodsObject.itemname    AS ObjectDescName
           , Object_Juridical.ValueData         AS ObjectName

           , Object_Goods_Juridical.MakerName

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
        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Juridical.GoodsMainId

        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
        LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = Object_Goods_Main.MeasureId
        LEFT JOIN Object AS Object_NDSKind    ON Object_NDSKind.Id    = Object_Goods_Main.NDSKindId

        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Juridical.ConditionsKeepId
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = Object_Goods_Juridical.AreaId

        -- связь с Юридические лица
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Goods_Juridical.JuridicalId
        LEFT JOIN ObjectDesc AS ObjectDesc_GoodsObject ON ObjectDesc_GoodsObject.Id = Object_Juridical.DescId

        LEFT JOIN tmpMarion ON tmpMarion.GoodsMainId = Object_Goods_Juridical.GoodsMainId
                            AND tmpMarion.Ord         = 1
        LEFT JOIN tmpBarCode ON tmpBarCode.GoodsMainId = Object_Goods_Juridical.GoodsMainId
                            AND tmpBarCode.Ord         = 1

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
-- SELECT * FROM gpSelect_GoodsAll_Juridical_Tab (zfCalc_UserAdmin())
