-- Function: gpSelect_Object_Goods_Retail()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Retail(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Retail(
    IN inContractId  Integer,       -- договор поставщика
    IN inRetailId    Integer,       -- торговая сеть
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, IdBarCode TVarChar, Name TVarChar, isErased Boolean
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , NDS TFloat, MinimumLot TFloat, isClose Boolean
             , isTOP Boolean, isFirst Boolean, isSecond Boolean, isPublished Boolean
             , isSP Boolean
             , PercentMarkup TFloat, Price TFloat
             , CountPrice TFloat
             , Color_calc Integer
             , RetailCode Integer, RetailName TVarChar
             , isPromo boolean
             , isMarketToday Boolean
             , LastPriceDate TDateTime, LastPriceOldDate TDateTime
             , CountDays TFloat, CountDays_inf TFloat
             , InsertName TVarChar, InsertDate TDateTime 
             , UpdateName TVarChar, UpdateDate TDateTime
             , ConditionsKeepName TVarChar
             , MorionCode Integer, BarCode TVarChar--, OrdBar Integer
             , NDS_PriceList TFloat, isNDS_dif Boolean
             , OrdPrice Integer
             , isNotUploadSites Boolean
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
      WITH GoodsPromo AS (SELECT DISTINCT ObjectLink_Child_retail.ChildObjectId AS GoodsId  -- здесь товар "сети"
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

     /*   , tmpLoadPriceList AS (SELECT DISTINCT LoadPriceListItem.GoodsId AS MainGoodsId
                               FROM LoadPriceList  
                                    INNER JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                               WHERE LoadPriceList.OperDate >= CURRENT_DATE AND LoadPriceList.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
                               
     */

         , tmpGoodsMorion AS (SELECT ObjectLink_Main_Morion.ChildObjectId          AS GoodsMainId
                                   , MAX (Object_Goods_Morion.ObjectCode)::Integer AS MorionCode
                              FROM ObjectLink AS ObjectLink_Main_Morion
                                   JOIN ObjectLink AS ObjectLink_Child_Morion
                                                   ON ObjectLink_Child_Morion.ObjectId = ObjectLink_Main_Morion.ObjectId
                                                  AND ObjectLink_Child_Morion.DescId = zc_ObjectLink_LinkGoods_Goods()
                                   JOIN ObjectLink AS ObjectLink_Goods_Object_Morion
                                                   ON ObjectLink_Goods_Object_Morion.ObjectId = ObjectLink_Child_Morion.ChildObjectId
                                                  AND ObjectLink_Goods_Object_Morion.DescId = zc_ObjectLink_Goods_Object()
                                                  AND ObjectLink_Goods_Object_Morion.ChildObjectId = zc_Enum_GlobalConst_Marion()
                                   LEFT JOIN Object AS Object_Goods_Morion ON Object_Goods_Morion.Id = ObjectLink_Goods_Object_Morion.ObjectId
                              WHERE ObjectLink_Main_Morion.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                                AND ObjectLink_Main_Morion.ChildObjectId > 0
                              GROUP BY ObjectLink_Main_Morion.ChildObjectId
                             )
         , tmpGoodsBarCode AS (SELECT ObjectLink_Main_BarCode.ChildObjectId                                                  AS GoodsMainId
                                    , STRING_AGG (Object_Goods_BarCode.ValueData, ',' ORDER BY Object_Goods_BarCode.ID desc) AS BarCode
                                     -- , MAX (Object_Goods_BarCode.ValueData)  AS BarCode
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
                                 AND TRIM (Object_Goods_BarCode.ValueData) <> ''
                               GROUP BY ObjectLink_Main_BarCode.ChildObjectId
                              )  

         -- вытягиваем из LoadPriceListItem.GoodsNDS по входящему Договору поставщика (inContractId)
         , tmpPricelistItems AS (SELECT tmp.GoodsMainId
                                      , tmp.GoodsNDS
                                      , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsMainId  ORDER BY tmp.GoodsMainId, tmp.GoodsNDS) AS Ord
                                 FROM
                                     (SELECT DISTINCT
                                             LoadPriceListItem.GoodsId      AS GoodsMainId
                                           , CAST (REPLACE (REPLACE ( REPLACE (LoadPriceListItem.GoodsNDS , '%', ''), 'НДС', '') , ',', '.') AS TFloat) AS GoodsNDS
                                      FROM LoadPriceList
                                           INNER JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
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

      SELECT Object_Goods_View.Id
           , ObjectLink_Main.ChildObjectId     AS GoodsMainId 
           , Object_Goods_View.GoodsCodeInt
--           , ObjectString.ValueData                           AS GoodsCode
           , zfFormat_BarCode(zc_BarCodePref_Object(), ObjectLink_Main.ChildObjectId) AS IdBarCode         --ObjectLink_Main.ChildObjectId
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
           , COALESCE (tmpGoodsSP.isSP, False)           ::Boolean AS isSP
           -- , CASE WHEN Object_Goods_View.isPublished = FALSE THEN NULL ELSE Object_Goods_View.isPublished END :: Boolean AS isPublished
           , Object_Goods_View.PercentMarkup  
           , Object_Goods_View.Price

           , COALESCE (ObjectFloat_CountPrice.ValueData,0) ::TFloat AS CountPrice

           , CASE WHEN COALESCE (tmpGoodsSP.isSP, False) = TRUE THEN zc_Color_Yelow() WHEN Object_Goods_View.isSecond = TRUE THEN 16440317 WHEN Object_Goods_View.isFirst = TRUE THEN zc_Color_GreenL() ELSE zc_Color_White() END AS Color_calc   --10965163
           , Object_Retail.ObjectCode AS RetailCode
           , Object_Retail.ValueData  AS RetailName
           , CASE WHEN COALESCE(GoodsPromo.GoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo

           --, CASE WHEN COALESCE(tmpLoadPriceList.MainGoodsId,0) <> 0 THEN TRUE ELSE FALSE END AS isMarketToday
           , CASE WHEN DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData) = CURRENT_DATE THEN TRUE ELSE FALSE END AS isMarketToday
           
           , DATE_TRUNC ('DAY', ObjectDate_LastPrice.ValueData)                   ::TDateTime  AS LastPriceDate
           , DATE_TRUNC ('DAY', ObjectDate_LastPriceOld.ValueData)                ::TDateTime  AS LastPriceOldDate
           
           , CAST (DATE_PART ('DAY', (ObjectDate_LastPrice.ValueData - ObjectDate_LastPriceOld.ValueData)) AS NUMERIC (15,2))  :: TFloat  AS CountDays
           , CAST (DATE_PART ('DAY', (CURRENT_DATE - ObjectDate_LastPrice.ValueData)) AS NUMERIC (15,2))                       :: TFloat  AS CountDays_inf
           
           , COALESCE(Object_Insert.ValueData, '')         ::TVarChar  AS InsertName
           , COALESCE(ObjectDate_Insert.ValueData, Null)   ::TDateTime AS InsertDate
           , COALESCE(Object_Update.ValueData, '')         ::TVarChar  AS UpdateName
           , COALESCE(ObjectDate_Update.ValueData, Null)   ::TDateTime AS UpdateDate
           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar  AS ConditionsKeepName

           , tmpGoodsMorion.MorionCode                     
           , tmpGoodsBarCode.BarCode                       ::TVarChar
           --, tmpGoodsBarCode.Ord        :: Integer AS OrdBar

           , tmpPricelistItems.GoodsNDS :: TFloat  AS NDS_PriceList
           , CASE WHEN COALESCE (tmpPricelistItems.GoodsNDS, 0) <> 0 AND inContractId <> 0 AND COALESCE (tmpPricelistItems.GoodsNDS, 0) <> Object_Goods_View.NDS THEN TRUE ELSE FALSE END AS isNDS_dif
           , tmpPricelistItems.Ord      :: Integer AS OrdPrice
           , COALESCE(ObjectBoolean_isNotUploadSites.ValueData, false) AS isNotUploadSites
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

           LEFT JOIN ObjectFloat AS ObjectFloat_CountPrice
                                 ON ObjectFloat_CountPrice.ObjectId = Object_Goods_View.Id --ObjectLink_Main.ChildObjectId   -- теперь это свойство товара сети
                                AND ObjectFloat_CountPrice.DescId = zc_ObjectFloat_Goods_CountPrice()
                                
           -- получается GoodsMainId
           LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = Object_Goods_View.Id --Object_Goods.Id
                                                    AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
           LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                   AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

           LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
           /*LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                    ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                   AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()*/

           LEFT JOIN ObjectDate AS ObjectDate_LastPrice
                                ON ObjectDate_LastPrice.ObjectId = ObjectLink_Main.ChildObjectId
                               AND ObjectDate_LastPrice.DescId = zc_ObjectDate_Goods_LastPrice()

           LEFT JOIN ObjectDate AS ObjectDate_LastPriceOld
                                ON ObjectDate_LastPriceOld.ObjectId = ObjectLink_Main.ChildObjectId
                               AND ObjectDate_LastPriceOld.DescId = zc_ObjectDate_Goods_LastPriceOld()
            
           -- условия хранения
           LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                ON ObjectLink_Goods_ConditionsKeep.ObjectId = Object_Goods_View.Id
                               AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
           LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId

           --LEFT JOIN tmpLoadPriceList ON tmpLoadPriceList.MainGoodsId = ObjectLink_Main.ChildObjectId

           -- определяем код Мориона
           LEFT JOIN tmpGoodsMorion ON tmpGoodsMorion.GoodsMainId = ObjectLink_Main.ChildObjectId
           -- определяем штрих-код производителя
           LEFT JOIN tmpGoodsBarCode ON tmpGoodsBarCode.GoodsMainId = ObjectLink_Main.ChildObjectId
           
           LEFT JOIN tmpPricelistItems ON tmpPricelistItems.GoodsMainId = ObjectLink_Main.ChildObjectId
           
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites 
                                   ON ObjectBoolean_isNotUploadSites.ObjectId = Object_Goods_View.Id 
                                  AND ObjectBoolean_isNotUploadSites.DescId = zc_ObjectBoolean_Goods_isNotUploadSites()

      WHERE Object_Goods_View.ObjectId = vbObjectId
      ;

  -- END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.  Шаблий О.В.
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
-- SELECT * FROM gpSelect_Object_Goods_Retail (inContractId := 0, inRetailId := 0, inSession := '3')
-- select * from gpSelect_Object_Goods_Retail (inContractId := 183257, inRetailId := 4, inSession := '59591')