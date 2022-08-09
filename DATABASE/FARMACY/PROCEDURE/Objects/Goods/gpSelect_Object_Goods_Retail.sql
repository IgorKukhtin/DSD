-- Function: gpSelect_Object_Goods_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Retail(
    IN inContractId  Integer,       -- договор поставщика
    IN inRetailId    Integer,       -- торговая сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, IdBarCode TVarChar, Name TVarChar
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
             , MakerPromoName TVarChar
             , isMarketToday Boolean
             , isNotMarion Boolean
             , LastPriceDate TDateTime, LastPriceOldDate TDateTime
             , CountDays TFloat, CountDays_inf TFloat
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
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
             , MakerName TVarChar, MakerNameUkr TVarChar, FormDispensingId Integer, FormDispensingName TVarChar, NumberPlates Integer, QtyPackage Integer, isRecipe boolean
             , Dosage TVarChar, Volume TVarChar, GoodsWhoCanId integer, GoodsWhoCanName TVarChar, GoodsMethodApplId integer, GoodsMethodApplName TVarChar, GoodsSignOriginId  integer,  GoodsSignOriginName TVarChar
             , isLeftTheMarket boolean 
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

/*
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
     , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceListItem.GoodsId AS MainGoodsId
                            FROM LoadPriceList
                                 INNER JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                            WHERE LoadPriceList.OperDate >= CURRENT_DATE AND LoadPriceList.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
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
           , COALESCE (Object_Goods_View.isPublished,False) :: Boolean  AS isPublished
           , Object_Goods_View.isSP
           -- , CASE WHEN Object_Goods_View.isPublished = FALSE THEN NULL ELSE Object_Goods_View.isPublished END :: Boolean AS isPublished
           , Object_Goods_View.PercentMarkup
           , Object_Goods_View.Price
           , CASE WHEN ObjectBoolean_Goods_SP.ValueData = TRUE THEN zc_Color_Yelow() WHEN Object_Goods_View.isSecond = TRUE THEN 16440317 WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc  --16380671   10965163
           , Object_Retail.ObjectCode AS RetailCode
           , Object_Retail.ValueData  AS RetailName
           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
           , CASE WHEN COALESCE(tmpLoadPriceList.MainGoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isMarketToday

           , COALESCE(Object_Insert.ValueData, '')         ::TVarChar  AS InsertName
           , COALESCE(ObjectDate_Insert.ValueData, Null)   ::TDateTime AS InsertDate
           , COALESCE(Object_Update.ValueData, '')         ::TVarChar  AS UpdateName
           , COALESCE(ObjectDate_Update.ValueData, Null)   ::TDateTime AS UpdateDate
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName
           , COALESCE (ObjectBoolean_Goods_SUN_v3.ValueData, False) ::Boolean AS isSUN_v3
           , COALESCE (ObjectFloat_Goods_KoeffSUN_v3.ValueData,0)   :: TFloat AS KoeffSUN_v3
           , COALESCE (ObjectFloat_Goods_KoeffSUN_v1.ValueData,0)   :: TFloat AS KoeffSUN_v1
           , COALESCE (ObjectFloat_Goods_KoeffSUN_v2.ValueData,0)   :: TFloat AS KoeffSUN_v2
           , COALESCE (ObjectFloat_Goods_KoeffSUN_v4.ValueData,0)   :: TFloat AS KoeffSUN_v4
           , Object_Goods_Main.isResolution_224                                  AS isResolution_224
           , Object_Goods_Main.DateUpdateClose                                   AS DateUpdateClose

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

         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_KoeffSUN_v3
                                ON ObjectFloat_Goods_KoeffSUN_v3.ObjectId = Object_Goods_View.Id
                               AND ObjectFloat_Goods_KoeffSUN_v3.DescId = zc_ObjectFloat_Goods_KoeffSUN_v3()

         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_KoeffSUN_v1
                                ON ObjectFloat_Goods_KoeffSUN_v1.ObjectId = Object_Goods_View.Id
                               AND ObjectFloat_Goods_KoeffSUN_v1.DescId = zc_ObjectFloat_Goods_KoeffSUN_v1()
         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_KoeffSUN_v2
                                ON ObjectFloat_Goods_KoeffSUN_v2.ObjectId = Object_Goods_View.Id
                               AND ObjectFloat_Goods_KoeffSUN_v2.DescId = zc_ObjectFloat_Goods_KoeffSUN_v2()
         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_KoeffSUN_v4
                                ON ObjectFloat_Goods_KoeffSUN_v4.ObjectId = Object_Goods_View.Id
                               AND ObjectFloat_Goods_KoeffSUN_v4.DescId = zc_ObjectFloat_Goods_KoeffSUN_v4()

         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SUN_v3
                                 ON ObjectBoolean_Goods_SUN_v3.ObjectId = Object_Goods_View.Id
                                AND ObjectBoolean_Goods_SUN_v3.DescId = zc_ObjectBoolean_Goods_SUN_v3()
        -- условия хранения
        LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep
                             ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
                            AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
        LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

        LEFT JOIN tmpLoadPriceList ON tmpLoadPriceList.MainGoodsId = ObjectLink_Main.ChildObjectId
    WHERE Object_Retail.DescId = zc_Object_Retail()

;

   ELSE

   -- для остальных...
*/

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
         -- вытягиваем из LoadPriceListItem.GoodsNDS по входящему Договору поставщика (inContractId)
         , tmpPricelistItems AS (SELECT tmp.GoodsMainId
                                      , tmp.GoodsNDS
                                      , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsMainId  ORDER BY tmp.GoodsMainId, tmp.GoodsNDS) AS Ord
                                 FROM
                                     (SELECT DISTINCT
                                             LoadPriceListItem.GoodsId      AS GoodsMainId
                                           , COALESCE(CASE WHEN LoadPriceListItem.GoodsNDS LIKE '%2%' THEN 20 
                                                           WHEN LoadPriceListItem.GoodsNDS LIKE '%7%' THEN 7 
                                                           WHEN LoadPriceListItem.GoodsNDS IN ('0', 'Без НДС') THEN 0 END,
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

           , CASE WHEN DATE_TRUNC ('DAY', Object_Goods_Main.LastPrice) = CURRENT_DATE THEN TRUE ELSE FALSE END AS isMarketToday
           , Object_Goods_Main.isNotMarion

           , DATE_TRUNC ('DAY', Object_Goods_Main.LastPrice)::TDateTime     AS LastPriceDate
           , DATE_TRUNC ('DAY', Object_Goods_Main.LastPriceOld)::TDateTime  AS LastPriceOldDate

           , CAST (DATE_PART ('DAY', (Object_Goods_Main.LastPrice - Object_Goods_Main.LastPriceOld)) AS NUMERIC (15,2)):: TFloat  AS CountDays
           , CAST (DATE_PART ('DAY', (CURRENT_DATE - Object_Goods_Main.LastPrice)) AS NUMERIC (15,2))                  :: TFloat  AS CountDays_inf

           , COALESCE(Object_Insert.ValueData, '')         ::TVarChar  AS InsertName
           , Object_Goods_Retail.DateInsert                            AS InsertDate
           , COALESCE(Object_Update.ValueData, '')         ::TVarChar  AS UpdateName
           , Object_Goods_Retail.DateUpdate                            AS UpdateDate
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
           , Object_Goods_Main.MakerNameUkr
           , Object_Goods_Main.FormDispensingId
           , Object_FormDispensing.ValueData                                     AS FormDispensingName
           , Object_Goods_Main.NumberPlates
           , Object_Goods_Main.QtyPackage
           , Object_Goods_Main.isRecipe
           
           , Object_Goods_Main.Dosage 
           , Object_Goods_Main.Volume
           , Object_Goods_Main.GoodsWhoCanId
           , Object_GoodsWhoCan.ValueData                                        AS GoodsWhoCanName
           , Object_Goods_Main.GoodsMethodApplId
           , Object_GoodsMethodAppl.ValueData                                    AS GoodsMethodApplName
           , Object_Goods_Main.GoodsSignOriginId
           , Object_GoodsSignOrigin.ValueData                                    AS GoodsSignOriginName

           , Object_Goods_Main.isLeftTheMarket

      FROM Object_Goods_Retail

           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId
           LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = Object_Goods_Main.ConditionsKeepId
           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = Object_Goods_Main.MeasureId
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = Object_Goods_Retail.UserInsertId
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = Object_Goods_Retail.UserUpdateId
           LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Object_Goods_Main.FormDispensingId

           LEFT JOIN Object AS Object_GoodsWhoCan ON Object_GoodsWhoCan.Id = Object_Goods_Main.GoodsWhoCanId
           LEFT JOIN Object AS Object_GoodsMethodAppl ON Object_GoodsMethodAppl.Id = Object_Goods_Main.GoodsMethodApplId
           LEFT JOIN Object AS Object_GoodsSignOrigin ON Object_GoodsSignOrigin.Id = Object_Goods_Main.GoodsSignOriginId
           
           LEFT JOIN tmpNDS ON tmpNDS.Id = Object_Goods_Main.NDSKindId
           LEFT JOIN Object AS Object_GoodsPairSun ON Object_GoodsPairSun.Id = Object_Goods_Retail.GoodsPairSunId

           LEFT JOIN GoodsPromo ON GoodsPromo.GoodsId = Object_Goods_Retail.GoodsMainId

           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = Object_Goods_Retail.GoodsMainId

           -- определяем штрих-код производителя
           LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = Object_Goods_Retail.GoodsMainId

           LEFT JOIN tmpPricelistItems ON tmpPricelistItems.GoodsMainId = Object_Goods_Retail.GoodsMainId

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

select * from gpSelect_Object_Goods_Retail(inContractId := 0 , inRetailId := 0 ,  inSession := '3');