-- Function: gpSelect_Object_Goods_SUN()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_SUN(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_SUN(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, Name TVarChar
             , GoodsPairSunId Integer, GoodsPairSunCode Integer, GoodsPairSunName TVarChar, PairSunAmount TFloat
             , PairSunDate TDateTime
             , isErased Boolean
             
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , NDS TFloat, isClose Boolean
             , isTOP Boolean, isFirst Boolean
             
             , isSecond Boolean
             , isSP Boolean
             , Color_calc Integer
             , isPromo boolean
             , isNot Boolean, isNot_Sun_v2 Boolean, isNot_Sun_v4 Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar
             
             , UpdateDate TDateTime
             , ConditionsKeepName TVarChar
             , MorionCode Integer
             , KoeffSUN_v1 TFloat, KoeffSUN_v2 TFloat, KoeffSUN_v4 TFloat, KoeffSUN_Supplementv1 TFloat
             , isResolution_224  boolean
             , DateUpdateClose TDateTime
             , isInvisibleSUN boolean
             
             , isSupplementSUN1 boolean
             , isOnlySP boolean
             , SummaWages TFloat, PercentWages TFloat, SummaWagesStore TFloat, PercentWagesStore TFloat
             , UnitSupplementSUN1OutId Integer, UnitSupplementSUN1OutName TVarChar
             , UnitSupplementSUN2OutId Integer, UnitSupplementSUN2OutName TVarChar
             , isUkrainianTranslation boolean
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

   vbAreaDneprId := (SELECT Object.Id FROM Object WHERE Object.Descid = zc_Object_Area() AND Object.ValueData LIKE 'Днепр');

   RETURN QUERY
     -- Маркетинговый контракт
      WITH GoodsPromo AS (SELECT DISTINCT Object_Goods_Retail.GoodsMainId AS GoodsId  -- главный товар
                            --   , tmp.ChangePercent
                          FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                       INNER JOIN Object_Goods_Retail AS Object_Goods_Retail
                                                             ON Object_Goods_Retail.Id = tmp.GoodsId
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
           , Object_Goods_Main.Name                                                   AS GoodsName
           , Object_GoodsPairSun.Id                                                   AS GoodsPairSunId
           , Object_GoodsPairSun.ObjectCode                                           AS GoodsPairSunCode
           , Object_GoodsPairSun.ValueData                                            AS GoodsPairSunName
           , Object_Goods_Retail.PairSunAmount
           , Object_Goods_Retail.PairSunDate             :: TDateTime                 AS PairSunDate
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
           , COALESCE (tmpGoodsSP.isSP, False)::Boolean                               AS isSP

           , CASE WHEN COALESCE (tmpGoodsSP.isSP, False) = TRUE THEN zc_Color_Yelow()
                  WHEN Object_Goods_Retail.isSecond = TRUE THEN 16440317
                  WHEN Object_Goods_Retail.isFirst = TRUE THEN zc_Color_GreenL()
                  ELSE zc_Color_White() END                                           AS Color_calc   --10965163

           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END   AS isPromo

           , Object_Goods_Main.isNOT
           , Object_Goods_Main.isNOT_Sun_v2
           , Object_Goods_Main.isNOT_Sun_v4


           , COALESCE(Object_Insert.ValueData, '')         ::TVarChar  AS InsertName
           , Object_Goods_Retail.DateInsert                            AS InsertDate
           , COALESCE(Object_Update.ValueData, '')         ::TVarChar  AS UpdateName
           
           , Object_Goods_Retail.DateUpdate                            AS UpdateDate
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName

           , Object_Goods_Main.MorionCode

           , COALESCE (Object_Goods_Retail.KoeffSUN_v1,0)   :: TFloat AS KoeffSUN_v1
           , COALESCE (Object_Goods_Retail.KoeffSUN_v2,0)   :: TFloat AS KoeffSUN_v2
           , COALESCE (Object_Goods_Retail.KoeffSUN_v4,0)   :: TFloat AS KoeffSUN_v4
           , COALESCE (Object_Goods_Retail.KoeffSUN_Supplementv1,0)   :: TFloat AS KoeffSUN_Supplementv1

           , Object_Goods_Main.isResolution_224                                  AS isResolution_224
           , Object_Goods_Main.DateUpdateClose                                   AS DateUpdateClose
           , Object_Goods_Main.isInvisibleSUN                                    AS isInvisibleSUN
           , Object_Goods_Main.isSupplementSUN1                                  AS isSupplementSUN1
           , Object_Goods_Main.isOnlySP                                          AS isOnlySP
           , Object_Goods_Retail.SummaWages                                      AS SummaWages
           , Object_Goods_Retail.PercentWages                                    AS PercentWages
           , Object_Goods_Retail.SummaWagesStore                                 AS SummaWagesStore
           , Object_Goods_Retail.PercentWagesStore                               AS PercentWagesStore
           , Object_Goods_Main.UnitSupplementSUN1OutId 
           , Object_UnitSupplementSUN1Out.ValueData                              AS UnitSupplementSUN1OutName
           , Object_Goods_Main.UnitSupplementSUN1OutId 
           , Object_UnitSupplementSUN2Out.ValueData                              AS UnitSupplementSUN2OutName
           , Trim(COALESCE(Object_Goods_Main.NameUkr, '')) <> ''                 AS isUkrainianTranslation

      FROM Object_Goods_Retail

           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
           LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = Object_Goods_Main.MeasureId
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = Object_Goods_Retail.UserInsertId
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = Object_Goods_Retail.UserUpdateId
           LEFT JOIN Object AS Object_UnitSupplementSUN1Out ON Object_UnitSupplementSUN1Out.Id = Object_Goods_Main.UnitSupplementSUN1OutId
           LEFT JOIN Object AS Object_UnitSupplementSUN2Out ON Object_UnitSupplementSUN2Out.Id = Object_Goods_Main.UnitSupplementSUN2OutId
           
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
 12.08.21                                                                     * 
*/

-- тест

select * from gpSelect_Object_Goods_SUN(inSession := '3');