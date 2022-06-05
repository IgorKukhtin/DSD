-- Function: gpSelect_Object_Goods_Site()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Site(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Site(
    IN inContractId  Integer,       -- договор поставщика
    IN inRetailId    Integer,       -- торговая сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, IdBarCode TVarChar, Name TVarChar
             , isErased Boolean
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , NDS TFloat, isClose Boolean
             , isTOP Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean
             , isSP Boolean
             , Color_calc Integer
             , isPromo boolean
             , MakerPromoName TVarChar
             , ConditionsKeepName TVarChar
             , MorionCode Integer, BarCode TVarChar, isErrorBarCode Boolean, BarCode_Color  Integer 
             , isResolution_224  boolean
             , isUkrainianTranslation boolean
             , MakerName TVarChar, FormDispensingId Integer, FormDispensingName TVarChar, NumberPlates Integer, QtyPackage Integer, isRecipe boolean
             , isExpDateExcSite boolean, isHideOnTheSite boolean
             , DiscontSiteStart TDateTime, DiscontSiteEnd TDateTime, DiscontAmountSite TFloat, DiscontPercentSite TFloat
             , isNotUploadSites Boolean
             , isPublishedSite Boolean
              ) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
  DECLARE vbAreaDneprId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- поиск <Торговой сети>
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- если выбрана торг.сеть то выбираем товары по ней
   IF COALESCE (inRetailId, 0) <> 0
   THEN
       vbObjectId := inRetailId;
   END IF;

   vbAreaDneprId := (SELECT Object.Id FROM Object WHERE Object.Descid = zc_Object_Area() AND Object.ValueData LIKE 'Днепр');

   RETURN QUERY
     -- Маркетинговый контракт
      WITH GoodsPromoAll AS (SELECT Object_Goods_Retail.GoodsMainId AS GoodsId  -- главный товар
                                  , Object_Maker.ValueData          AS MakerPromoName
                                  , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.GoodsMainId ORDER BY tmp.MovementId DESC) AS Ord
                             FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                  INNER JOIN Object_Goods_Retail AS Object_Goods_Retail
                                                                 ON Object_Goods_Retail.Id = tmp.GoodsId
                                  INNER JOIN Object AS Object_Maker
                                                    ON Object_Maker.Id = tmp.MakerId
                             )

         , GoodsPromo AS (SELECT GoodsPromoAll.GoodsId
                               , GoodsPromoAll.MakerPromoName
                          FROM GoodsPromoAll 
                          WHERE GoodsPromoAll.Ord = 1
                            )

         , tmpGoodsBarCode AS (SELECT Object_Goods_BarCode.GoodsMainId
                                    , STRING_AGG (Object_Goods_BarCode.BarCode, ',' ORDER BY Object_Goods_BarCode.GoodsMainId desc)    AS BarCode
                                    , SUM(CASE WHEN zfCheck_BarCode(Object_Goods_BarCode.BarCode, False) THEN 0 ELSE 1 END) AS ErrorBarCode
                               FROM Object_Goods_BarCode
                               GROUP BY Object_Goods_BarCode.GoodsMainId
                              )

         , tmpNDSKind AS
               (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                      , ObjectFloat_NDSKind_NDS.ValueData
                FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
               )
        -- Товары соц-проект (документ)
      , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                       FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
                       )
      ,  tmpNDS AS (SELECT Object_NDSKind.Id
                         , Object_NDSKind.ValueData                        AS NDSKindName
                         , ObjectFloat_NDSKind_NDS.ValueData               AS NDS
                    FROM Object AS Object_NDSKind
                         LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                               ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id
                                              AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                    WHERE Object_NDSKind.DescId = zc_Object_NDSKind()
                    )

      SELECT Object_Goods_Retail.Id
           , Object_Goods_Retail.GoodsMainId
           , Object_Goods_Main.ObjectCode                                             AS GoodsCodeInt
           , zfFormat_BarCode(zc_BarCodePref_Object(), Object_Goods_Retail.GoodsMainId) AS IdBarCode
           , Object_Goods_Main.Name                                                   AS GoodsName
           , Object_Goods_Retail.isErased
           , Object_Goods_Main.GoodsGroupId
           , Object_GoodsGroup.ValueData                                              AS GoodsGroupName
           , Object_Goods_Main.MeasureId
           , Object_Measure.ValueData                                                 AS MeasureName
           , Object_Goods_Main.NDSKindId
           , tmpNDS.NDSKindName
           , tmpNDS.NDS
           , Object_Goods_Main.isClose
           , Object_Goods_Retail.isTOP
           , Object_Goods_Retail.isFirst
           , Object_Goods_Retail.isSecond
           , Object_Goods_Main.isPublished
           , COALESCE (tmpGoodsSP.isSP, False)::Boolean                               AS isSP

           , CASE WHEN COALESCE (tmpGoodsSP.isSP, False) = TRUE THEN zc_Color_Yelow()
                  WHEN Object_Goods_Retail.isSecond = TRUE THEN 16440317
                  WHEN Object_Goods_Retail.isFirst = TRUE THEN zc_Color_GreenL()
                  ELSE zc_Color_White() END                                           AS Color_calc   --10965163

           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END   AS isPromo
           , GoodsPromo.MakerPromoName

           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName

           , Object_Goods_Main.MorionCode
           , tmpGoodsBarCode.BarCode                       ::TVarChar
           , CASE WHEN COALESCE (tmpGoodsBarCode.ErrorBarCode, 0) > 0 THEN TRUE ELSE FALSE END
           , CASE WHEN COALESCE (tmpGoodsBarCode.ErrorBarCode, 0) > 0 THEN zc_Color_Red() ELSE zc_Color_Black() END

           , Object_Goods_Main.isResolution_224                                  AS isResolution_224
           , Trim(COALESCE(Object_Goods_Main.NameUkr, '')) <> ''                 AS isUkrainianTranslation

           , Object_Goods_Main.MakerName
           , Object_Goods_Main.FormDispensingId
           , Object_FormDispensing.ValueData                                     AS FormDispensingName
           , Object_Goods_Main.NumberPlates
           , Object_Goods_Main.QtyPackage
           , Object_Goods_Main.isRecipe
           , Object_Goods_Main.isExpDateExcSite
           , Object_Goods_Main.isHideOnTheSite
           , Object_Goods_Retail.DiscontSiteStart
           , Object_Goods_Retail.DiscontSiteEnd
           , Object_Goods_Retail.DiscontAmountSite
           , Object_Goods_Retail.DiscontPercentSite
           , Object_Goods_Main.isNotUploadSites
           
           , Object_Goods_Main.isPublishedSite                                   AS isPublishedSite

      FROM Object_Goods_Retail

           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
           LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = Object_Goods_Main.MeasureId
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = Object_Goods_Retail.UserInsertId
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = Object_Goods_Retail.UserUpdateId
           LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Object_Goods_Main.FormDispensingId
           
           LEFT JOIN tmpNDS ON tmpNDS.Id = Object_Goods_Main.NDSKindId
           LEFT JOIN Object AS Object_GoodsPairSun ON Object_GoodsPairSun.Id = Object_Goods_Retail.GoodsPairSunId

           LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_Retail.GoodsMainId

           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Retail.GoodsMainId

           -- определяем штрих-код производителя
           LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Retail.GoodsMainId

      WHERE Object_Goods_Retail.RetailId = vbObjectId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.  Шаблий О.В.
 12.08.21                                                                     * перенос СУН в отдельную форму
 22.09.20                                                                     * isExceptionUKTZED
 25.05.20         * dell LimitSUN_T1
 18.05.20         * GoodsPairSun
 17.05.20         * LimitSUN_T1
 11.05.20         *
 03.05.20         * isNot_Sun_v4
 29.10.19                                                                     * Плоские таблицы
 24.10.19         * zc_ObjectBoolean_Goods_Not
 19.10.19         *
 14.06.19                                                                     * add AllowDivision
 15.03.19                                                                     * add DoesNotShare
 11.02.19         * признак Товары соц-проект берем и документа
 24.05.18                                                                     * add isNotUploadSites
 05.01.18         * add inRetailId
 03.01.18         * add inContractId, NDS_PriceList, isNDS_dif
 22.08.17         *
 16.08.17         * LastPriceOld
 19.05.17                                                       * MorionCode, BarCode
 21.04.17         *
 19.04.17         * add zc_ObjectDate_Goods_LastPrice
 06.04.17         *
 21.03.17         *
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
--SELECT * FROM gpSelect_Object_Goods_Retail (inContractId := 0, inRetailId := 0, inSession := '3')
-- select * from gpSelect_Object_Goods_Retail (inContractId := 183257, inRetailId := 4, inSession := '59591')

select * from gpSelect_Object_Goods_Site(inContractId := 0 , inRetailId := 0 ,  inSession := '3');