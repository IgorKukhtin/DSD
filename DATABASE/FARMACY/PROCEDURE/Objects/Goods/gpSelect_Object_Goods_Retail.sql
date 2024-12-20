-- Function: gpSelect_Object_Goods_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Retail(
    IN inContractId  Integer,       -- ������� ����������
    IN inRetailId    Integer,       -- �������� ����
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, IdBarCode TVarChar, Name TVarChar, NameUkr TVarChar
             , isErased Boolean
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , NDS TFloat, MinimumLot TFloat, isClose Boolean
             , isTOP Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean
             , isSP Boolean
             , PercentMarkup TFloat, Price TFloat
             , CountPrice TFloat
             , Color_calc Integer
             , isPromo boolean
             , MakerPromoName TVarChar, GoodsGroupPromoName TVarChar
             , isMarketToday Boolean
             , isNotMarion Boolean
             , LastPriceDate TDateTime, LastPriceOldDate TDateTime
             , CountDays TFloat, CountDays_inf TFloat
             , InsertName TVarChar, InsertDate TDateTime
             , ConditionsKeepName TVarChar
             , MorionCode Integer, BarCode TVarChar, isErrorBarCode Boolean, BarCode_Color  Integer --, OrdBar Integer
             , NDS_PriceList TFloat, isNDS_dif Boolean
             , isNotUploadSites Boolean
             , GoodsAnalog TVarChar, GoodsAnalogATC TVarChar, GoodsActiveSubstance TVarChar
             , isResolution_224  boolean
             , DateUpdateClose TDateTime
             , isExceptionUKTZED boolean
             , isOnlySP boolean
             , isUkrainianTranslation boolean
             , MakerName TVarChar, FormDispensingId Integer, FormDispensingName TVarChar, isRecipe boolean
             , isLeftTheMarket boolean, DateLeftTheMarket TDateTime, DateAddToOrder TDateTime 
             , CodeUKTZED TVarChar, isNewUKTZED Boolean, isNoRegUKTZED Boolean, Color_UKTZED Integer
              ) AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbObjectId Integer;
  DECLARE vbAreaDneprId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);


   -- ����� <�������� ����>
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- ���� ������� ����.���� �� �������� ������ �� ���
   IF COALESCE (inRetailId, 0) <> 0
   THEN
       vbObjectId := inRetailId;
   END IF;

   vbAreaDneprId := (SELECT Object.Id FROM Object WHERE Object.Descid = zc_Object_Area() AND Object.ValueData LIKE '�����');

   CREATE TEMP TABLE tmpContainer ON COMMIT DROP AS
   SELECT Container.ObjectId               AS GoodsId
        , sum(Container.Amount)::TFloat    AS Amount
   FROM Container
   WHERE Container.DescId        = zc_Container_Count()
     AND Container.Amount        <> 0
     AND Container.WhereObjectId IN (SELECT tmp.Id FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := inSession) AS tmp)
   GROUP BY Container.ObjectId;
                       
   ANALYSE tmpContainer;


   RETURN QUERY
     -- ������������� ��������
      WITH GoodsPromoAll AS (SELECT Object_Goods_Retail.GoodsMainId AS GoodsId  -- ������� �����
                                  , Object_Maker.ValueData          AS MakerPromoName
                                  , tmp.GoodsGroupPromoName
                                  , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.GoodsMainId ORDER BY tmp.MovementId DESC) AS Ord
                             FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                  INNER JOIN Object_Goods_Retail AS Object_Goods_Retail
                                                                 ON Object_Goods_Retail.Id = tmp.GoodsId
                                  INNER JOIN Object AS Object_Maker
                                                    ON Object_Maker.Id = tmp.MakerId
                             )

         , GoodsPromo AS (SELECT GoodsPromoAll.GoodsId
                               , GoodsPromoAll.MakerPromoName
                               , GoodsPromoAll.GoodsGroupPromoName
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
         -- ���������� �� LoadPriceListItem.GoodsNDS �� ��������� �������� ���������� (inContractId)
         , tmpPricelistItems AS (SELECT tmp.GoodsMainId
                                      , tmp.GoodsNDS
                                      , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsMainId  ORDER BY tmp.GoodsMainId, tmp.GoodsNDS) AS Ord
                                 FROM
                                     (SELECT DISTINCT
                                             LoadPriceListItem.GoodsId      AS GoodsMainId
                                           , COALESCE(CASE WHEN LoadPriceListItem.GoodsNDS LIKE '%2%' THEN 20 
                                                           WHEN LoadPriceListItem.GoodsNDS LIKE '%7%' THEN 7 
                                                           WHEN LoadPriceListItem.GoodsNDS IN ('0', '��� ���') THEN 0 END,
                                                           ObjectFloat_NDSKind_NDS.ValueData, 7)::TFloat AS GoodsNDS
                                      FROM LoadPriceList
                                           INNER JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                                           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = LoadPriceListItem.GoodsId
                                           LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                                ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                                      WHERE (LoadPriceList.ContractId = inContractId AND inContractId <> 0)
                                        AND COALESCE (LoadPriceListItem.GoodsId, 0) <> 0
                                        AND (COALESCE (LoadPriceList.AreaId, 0) = 0 OR LoadPriceList.AreaId = vbAreaDneprId)
                                     ) tmp
                                 GROUP BY tmp.GoodsMainId
                                        , tmp.GoodsNDS
                                 )
        -- ������ ���-������ (��������)
      , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                       FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE) AS tmp
                       )
      , tmpNDS AS (SELECT Object_NDSKind.Id
                        , Object_NDSKind.ValueData                        AS NDSKindName
                        , ObjectFloat_NDSKind_NDS.ValueData               AS NDS
                   FROM Object AS Object_NDSKind
                        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                              ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id
                                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                   WHERE Object_NDSKind.DescId = zc_Object_NDSKind()
                   )
      , tmpGoodsWhoCan AS (SELECT Object_GoodsWhoCan.Id                       AS Id
                                , Object_GoodsWhoCan.ValueData                AS Name
                           FROM OBJECT AS Object_GoodsWhoCan
                           WHERE Object_GoodsWhoCan.DescId = zc_Object_GoodsWhoCan())
      , tmpGoodsMainWhoCanAll AS (SELECT Object_Goods_Main.Id
                                       , tmpGoodsWhoCan.Id      AS  GoodsWhoCanId
                                       , tmpGoodsWhoCan.Name 
                                  FROM Object_Goods_Main
                                       INNER JOIN tmpGoodsWhoCan ON ','||Object_Goods_Main.GoodsWhoCanList||',' LIKE '%,'||(tmpGoodsWhoCan.ID::TVarChar)||',%'
                                  WHERE COALESCE(Object_Goods_Main.GoodsWhoCanList, '') <> ''
                                  )
      , tmpGoodsMainWhoCan AS (SELECT Object_Goods_Main.Id
                                    , string_agg(Object_Goods_Main.Name, ', ' order by Object_Goods_Main.GoodsWhoCanId)::TVarChar AS GoodsWhoCanName
                               FROM tmpGoodsMainWhoCanAll AS Object_Goods_Main
                               GROUP BY Object_Goods_Main.Id
                               )
      , tmpCodeUKTZED AS (SELECT DISTINCT Object_UKTZED.ValueData    AS UKTZED
                          FROM Object AS Object_UKTZED
                          WHERE Object_UKTZED.DescId = zc_Object_UKTZED()
                            AND Object_UKTZED.isErased = FALSE)
      , tmpGoodsUKTZED AS (SELECT Object_Goods_Juridical.GoodsMainId
                                 , string_agg(DISTINCT REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), ''), ',')::TVarChar AS UKTZED
                                 , max(CASE WHEN COALESCE (tmpCodeUKTZED.UKTZED, '') <> '' THEN 1 ELSE 0 END) AS RegUKTZED        
                            FROM Object_Goods_Juridical
                                 LEFT JOIN tmpCodeUKTZED ON tmpCodeUKTZED.UKTZED ILIKE REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')
                            WHERE COALESCE (Object_Goods_Juridical.UKTZED, '') <> ''
                              AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) >= 4
                              AND length(REPLACE(REPLACE(REPLACE(Object_Goods_Juridical.UKTZED, ' ', ''), '.', ''), Chr(160), '')) <= 10
                              AND Object_Goods_Juridical.GoodsMainId <> 0
                            GROUP BY Object_Goods_Juridical.GoodsMainId
                            )

      SELECT Object_Goods_Retail.Id
           , Object_Goods_Retail.GoodsMainId
           , Object_Goods_Main.ObjectCode                                             AS GoodsCodeInt
           , zfFormat_BarCode(zc_BarCodePref_Object(), Object_Goods_Retail.GoodsMainId) AS IdBarCode
           , Object_Goods_Main.Name                                                   AS GoodsName
           , Object_Goods_Main.NameUkr                                                AS GoodsNameUkr
           , Object_Goods_Retail.isErased
           , Object_Goods_Main.GoodsGroupId
           , Object_GoodsGroup.ValueData                                              AS GoodsGroupName
           , Object_Goods_Main.MeasureId
           , Object_Measure.ValueData                                                 AS MeasureName
           , Object_Goods_Main.NDSKindId
           , tmpNDS.NDSKindName
           , tmpNDS.NDS
           , Object_Goods_Retail.MinimumLot
           , Object_Goods_Main.isClose
           , Object_Goods_Retail.isTOP
           , Object_Goods_Retail.isFirst
           , Object_Goods_Retail.isSecond
           , Object_Goods_Main.isPublished
           , COALESCE (tmpGoodsSP.isSP, False)::Boolean                               AS isSP
           , Object_Goods_Retail.PercentMarkup
           , Object_Goods_Retail.Price

           , Object_Goods_Main.CountPrice

           , CASE WHEN COALESCE (tmpGoodsSP.isSP, False) = TRUE THEN zc_Color_Yelow()
                  WHEN Object_Goods_Retail.isSecond = TRUE THEN 16440317
                  WHEN Object_Goods_Retail.isFirst = TRUE THEN zc_Color_GreenL()
                  ELSE zc_Color_White() END                                           AS Color_calc   --10965163

           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END   AS isPromo
           , GoodsPromo.MakerPromoName
           , GoodsPromo.GoodsGroupPromoName

           , CASE WHEN DATE_TRUNC ('DAY', Object_Goods_Main.LastPrice) = CURRENT_DATE THEN TRUE ELSE FALSE END AS isMarketToday
           , Object_Goods_Main.isNotMarion

           , DATE_TRUNC ('DAY', Object_Goods_Main.LastPrice)::TDateTime     AS LastPriceDate
           , DATE_TRUNC ('DAY', Object_Goods_Main.LastPriceOld)::TDateTime  AS LastPriceOldDate

           , CAST (DATE_PART ('DAY', (Object_Goods_Main.LastPrice - Object_Goods_Main.LastPriceOld)) AS NUMERIC (15,2)):: TFloat  AS CountDays
           , CAST (DATE_PART ('DAY', (CURRENT_DATE - Object_Goods_Main.LastPrice)) AS NUMERIC (15,2))                  :: TFloat  AS CountDays_inf

           , COALESCE(Object_Insert.ValueData, '')         ::TVarChar  AS InsertName
           , Object_Goods_Retail.DateInsert                            AS InsertDate
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName

           , Object_Goods_Main.MorionCode
           , tmpGoodsBarCode.BarCode                       ::TVarChar
           , CASE WHEN COALESCE (tmpGoodsBarCode.ErrorBarCode, 0) > 0 THEN TRUE ELSE FALSE END
           , CASE WHEN COALESCE (tmpGoodsBarCode.ErrorBarCode, 0) > 0 THEN zc_Color_Red() ELSE zc_Color_Black() END

           , tmpPricelistItems.GoodsNDS :: TFloat  AS NDS_PriceList
           , CASE WHEN tmpPricelistItems.GoodsNDS IS NOT NULL AND inContractId <> 0 AND
             COALESCE (tmpPricelistItems.GoodsNDS, 0) <> tmpNDS.NDS THEN TRUE ELSE FALSE END AS isNDS_dif
           , Object_Goods_Main.isNotUploadSites
           , Object_Goods_Main.Analog                                            AS GoodsAnalog
           , Object_Goods_Main.AnalogATC                                         AS GoodsAnalogATC
           , Object_Goods_Main.ActiveSubstance                                   AS GoodsActiveSubstance

           , Object_Goods_Main.isResolution_224                                  AS isResolution_224
           , Object_Goods_Main.DateUpdateClose                                   AS DateUpdateClose
           , Object_Goods_Main.isExceptionUKTZED                                 AS isExceptionUKTZED
           , Object_Goods_Main.isOnlySP                                          AS isOnlySP
           , Trim(COALESCE(Object_Goods_Main.NameUkr, '')) <> ''                 AS isUkrainianTranslation

           , Object_Goods_Main.MakerName
           , Object_Goods_Main.FormDispensingId
           , Object_FormDispensing.ValueData                                     AS FormDispensingName
           , Object_Goods_Main.isRecipe
           

           , Object_Goods_Main.isLeftTheMarket
           , Object_Goods_Main.DateLeftTheMarket
           , Object_Goods_Main.DateAddToOrder 
           , CASE WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') <> ''
                  THEN Object_Goods_Main.CodeUKTZED
                  WHEN COALESCE (tmpContainer.Amount, 0) > 0
                  THEN tmpGoodsUKTZED.UKTZED END::TVarChar
           , CASE WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') = '' 
                   AND COALESCE (tmpGoodsUKTZED.UKTZED, '') <> '' 
                   AND COALESCE (tmpContainer.Amount, 0) > 0
                  THEN TRUE
                  ELSE FALSE END                                                 AS isNewUKTZED
           , CASE WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') <> ''  
                   AND COALESCE (tmpCodeUKTZED.UKTZED, '') <> ''
                  THEN FALSE
                  WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') <> ''
                  THEN TRUE 
                  WHEN COALESCE (tmpGoodsUKTZED.UKTZED, '') <> '' 
                   AND COALESCE (tmpContainer.Amount, 0) > 0
                  THEN tmpGoodsUKTZED.RegUKTZED = 0
                  ELSE FALSE END                                                 AS isNoRegUKTZED
           , CASE WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') = '' 
                   AND COALESCE (tmpGoodsUKTZED.UKTZED, '') = '' 
                   AND COALESCE (tmpContainer.Amount, 0) > 0
                    OR COALESCE (Object_Goods_Main.CodeUKTZED, '') = '' 
                   AND COALESCE (tmpGoodsUKTZED.UKTZED, '') <> '' 
                   AND COALESCE (tmpContainer.Amount, 0) > 0
                   AND tmpGoodsUKTZED.RegUKTZED = 1
                  THEN zfCalc_Color (255, 165, 0) 
                  WHEN COALESCE (Object_Goods_Main.CodeUKTZED, '') <> ''
                   AND COALESCE (tmpCodeUKTZED.UKTZED, '') = ''
                    OR COALESCE (Object_Goods_Main.CodeUKTZED, '') = '' 
                   AND COALESCE (tmpGoodsUKTZED.UKTZED, '') <> '' 
                   AND COALESCE (tmpContainer.Amount, 0) > 0
                   AND tmpGoodsUKTZED.RegUKTZED = 0
                  THEN zfCalc_Color (255, 0, 255) 
                  ELSE zc_Color_White() END                                      AS Color_UKTZED

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
           
           LEFT JOIN tmpContainer ON tmpContainer.GoodsId = Object_Goods_Retail.Id

           LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_Retail.GoodsMainId

           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Retail.GoodsMainId

           -- ���������� �����-��� �������������
           LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Retail.GoodsMainId

           LEFT JOIN tmpPricelistItems ON tmpPricelistItems.GoodsMainId = Object_Goods_Retail.GoodsMainId
           
           LEFT JOIN tmpGoodsMainWhoCan ON tmpGoodsMainWhoCan.ID = Object_Goods_Retail.GoodsMainId
           
           LEFT JOIN tmpGoodsUKTZED ON tmpGoodsUKTZED.GoodsMainId = Object_Goods_Retail.GoodsMainId
           
           LEFT JOIN tmpCodeUKTZED ON tmpCodeUKTZED.UKTZED ILIKE Object_Goods_Main.CodeUKTZED

      WHERE Object_Goods_Retail.RetailId = vbObjectId
    --LIMIT CASE WHEN vbUserId = 3 THEN 100 ELSE 200000 END
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.  ������ �.�.
 15.11.22         * UKTZED_main
 12.08.21                                                                     * ������� ��� � ��������� �����
 22.09.20                                                                     * isExceptionUKTZED
 25.05.20         * dell LimitSUN_T1
 18.05.20         * GoodsPairSun
 17.05.20         * LimitSUN_T1
 11.05.20         *
 03.05.20         * isNot_Sun_v4
 29.10.19                                                                     * ������� �������
 24.10.19         * zc_ObjectBoolean_Goods_Not
 19.10.19         *
 14.06.19                                                                     * add AllowDivision
 15.03.19                                                                     * add DoesNotShare
 11.02.19         * ������� ������ ���-������ ����� � ���������
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

-- ����
--SELECT * FROM gpSelect_Object_Goods_Retail (inContractId := 0, inRetailId := 0, inSession := '3')
-- select * from gpSelect_Object_Goods_Retail (inContractId := 183257, inRetailId := 4, inSession := '59591')
-- 

select * from gpSelect_Object_Goods_Retail(inContractId := 0 , inRetailId := 0 ,  inSession := '3');