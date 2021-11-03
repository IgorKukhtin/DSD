-- Function: gpSelect_KilledCodeRecovery()

DROP FUNCTION IF EXISTS gpSelect_KilledCodeRecovery (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_KilledCodeRecovery(
    IN inRangeOfDays      Integer  ,  -- Диапозон дней
    IN inPercePharmaciesd TFloat   ,  -- % аптек
    IN inSalesThreshold   TFloat   ,  -- Порог продаж
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
                UnitName TVarChar
              , GoodsCode Integer
              , GoodsName TVarChar
              , isClose   boolean
              , MakerId          Integer
              , MakerCode        Integer      --Производитель
              , MakerName        TVarChar     --Наименование производителя

              , MCSIsCloseDateChange TDateTime
              , CountUnit Integer
              , CountSelling Integer
              , CountUnitAll Integer
              , GoodsCount Integer
              , Remains TFloat
              , Price_min TFloat
              , AmountOrder TFloat
              , SummaOrder TFloat
              , JuridicalId       Integer    -- Поставщик (по которому найдена миним цена)
              , JuridicalName     TVarChar   -- Поставщик (по которому найдена миним цена)
              , ContractId        Integer    -- Договор (по которому найдена миним цена)
              , ContractName      TVarChar   -- Договор (по которому найдена миним цена)
              , ExpirationDate    TDateTime -- срок годности (по которому найдена миним цена)
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitCount Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    CREATE TEMP TABLE tmpUnitCheck ON COMMIT DROP AS
     (
     WITH tmpGoods AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , Object_Unit.valuedata             AS UnitName
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , Object_Goods.objectcode           AS GoodsCode
                            , Object_Goods.valuedata            AS GoodsName
                            , MCS_Value.ValueData               AS MCSValue
                            , MCS_isClose.ValueData             AS isClose
                            , MCSIsClose_DateChange.valuedata   AS MCSIsCloseDateChange
                       FROM ObjectLink AS OL_Price_Unit

                            INNER JOIN ObjectBoolean AS MCS_isClose
                                                     ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                    AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                    AND MCS_isClose.ValueData = TRUE
                            LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                                 ON MCSIsClose_DateChange.ObjectId = OL_Price_Unit.ObjectId
                                                AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()

                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN Object AS Object_Unit
                                             ON Object_Unit.Id       = OL_Price_Unit.ChildObjectId
                            LEFT JOIN Object AS Object_Goods
                                             ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            

                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = OL_Price_Unit.ChildObjectId
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Juridical_Retail.childobjectid = 4
                         AND Object_Unit.ValueData not ILIKE '%закры%'
                         AND Object_Unit.isErased = False
                         AND Object_Goods.isErased = FALSE),

          tmpUnitCheckAll AS (SELECT ACI.UnitId                    AS UnitId
                              FROM AnalysisContainerItem AS ACI
                              WHERE ACI.OperDate < CURRENT_DATE - ((inRangeOfDays)::TVarChar||' DAY')::INTERVAL
                                AND ACI.OperDate >= CURRENT_DATE - ((inRangeOfDays + 10)::TVarChar||' DAY')::INTERVAL

                         GROUP BY ACI.UnitId
                        )
                        
          SELECT tmpUnitCheckAll.UnitId                    AS UnitId
                           FROM tmpUnitCheckAll
                           
                                INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                      ON ObjectLink_Unit_Juridical.ObjectId = tmpUnitCheckAll.UnitId
                                                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                      ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                     AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                     AND ObjectLink_Juridical_Retail.childobjectid = 4
                                INNER JOIN Object AS Object_Unit
                                                  ON Object_Unit.Id       = tmpUnitCheckAll.UnitId 
                                                 AND Object_Unit.ValueData not ILIKE '%закры%'
                                                 AND Object_Unit.isErased = False
          );
                                
     vbUnitCount := (SELECT Count(*) as UnitCount FROM tmpUnitCheck);

    -- Результат
    RETURN QUERY
     WITH tmpGoods AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , Object_Unit.valuedata             AS UnitName
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , Object_Goods.objectcode           AS GoodsCode
                            , Object_Goods.valuedata            AS GoodsName
                            , MCS_Value.ValueData               AS MCSValue
                            , MCS_isClose.ValueData             AS isMCSClose
                            , MCSIsClose_DateChange.valuedata   AS MCSIsCloseDateChange
                            , COALESCE (ObjectBoolean_Goods_Close.valuedata, False) AS isClose
                       FROM ObjectLink AS OL_Price_Unit

                            INNER JOIN ObjectBoolean AS MCS_isClose
                                                     ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                    AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                                                    AND MCS_isClose.ValueData = TRUE
                            LEFT JOIN ObjectDate AS MCSIsClose_DateChange
                                                 ON MCSIsClose_DateChange.ObjectId = OL_Price_Unit.ObjectId
                                                AND MCSIsClose_DateChange.DescId = zc_ObjectDate_Price_MCSIsCloseDateChange()

                            LEFT JOIN ObjectLink AS OL_Price_Goods
                                                 ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN Object AS Object_Unit
                                             ON Object_Unit.Id       = OL_Price_Unit.ChildObjectId
                            LEFT JOIN Object AS Object_Goods
                                             ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            

                            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = OL_Price_Unit.ChildObjectId
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                                    ON ObjectBoolean_Goods_Close.ObjectId  = OL_Price_Goods.ChildObjectId
                                                   AND ObjectBoolean_Goods_Close.DescId    = zc_ObjectBoolean_Goods_Close()
                                                

                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                         AND ObjectLink_Juridical_Retail.childobjectid = 4
                         AND Object_Unit.ValueData not ILIKE '%закры%'
                         AND Object_Unit.isErased = False
                         AND Object_Goods.isErased = FALSE),

          tmpGoodsUnitCount AS (SELECT tmpGoods.GoodsId
                                     , COUNT(*)           AS CountUnit
                                FROM tmpGoods
                                GROUP BY tmpGoods.GoodsId
                                HAVING COUNT(*) <= FLOOR(vbUnitCount - vbUnitCount * inPercePharmaciesd / 100)
                                ),
                                
                                
          tmpSelling AS (SELECT ACI.GoodsId                   AS GoodsId
                              , ACI.UnitId                    AS UnitId
                              , SUM(ACI.AmountCheck)          AS AmountCheck
                         FROM AnalysisContainerItem AS ACI
                              
                              LEFT JOIN tmpGoods ON tmpGoods.GoodsId = ACI.GoodsId
                                                AND tmpGoods.UnitId = ACI.UnitId
                                                
                         WHERE ACI.OperDate >= CASE WHEN tmpGoods.MCSIsCloseDateChange IS NULL
                                                      OR tmpGoods.MCSIsCloseDateChange < CURRENT_DATE - ((inRangeOfDays + 1)::TVarChar||' DAY')::INTERVAL 
                                                    THEN CURRENT_DATE - ((inRangeOfDays + 1)::TVarChar||' DAY')::INTERVAL
                                                    ELSE tmpGoods.MCSIsCloseDateChange END

                         GROUP BY ACI.GoodsId
                                , ACI.UnitId
                        ),
           tmpSellingCount AS (SELECT tmpSelling.GoodsId
                                    , COUNT(*)           AS CountSelling
                               FROM tmpSelling
                                    INNER JOIN tmpGoodsUnitCount ON tmpGoodsUnitCount.GoodsId = tmpSelling.GoodsId
                                    INNER JOIN tmpUnitCheck ON tmpUnitCheck.UnitId = tmpSelling.UnitId
                               WHERE tmpSelling.AmountCheck >= inSalesThreshold
                               GROUP BY tmpSelling.GoodsId
                               ),
           tmpMinPrice_List AS (SELECT MinPriceList.GoodsId,
                                       MinPriceList.GoodsCode,
                                       MinPriceList.GoodsName,
                                       MinPriceList.PartionGoodsDate,
                                       MinPriceList.Partner_GoodsId,
                                       MinPriceList.Partner_GoodsCode,
                                       MinPriceList.Partner_GoodsName,
                                       MinPriceList.MakerName,
                                       MinPriceList.ContractId,
                                       MinPriceList.AreaId,
                                       MinPriceList.JuridicalId,
                                       MinPriceList.JuridicalName,
                                       MinPriceList.Price,
                                       MinPriceList.SuperFinalPrice,
                                       MinPriceList.isTop,
                                       MinPriceList.isOneJuridical
                                FROM (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods) AS GoodsList_all
                                     INNER JOIN MinPrice_ForSite AS MinPriceList
                                                                 ON GoodsList_all.GoodsId = MinPriceList.GoodsId),
           tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                , ObjectFloat_NDSKind_NDS.ValueData
                          FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                          WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                         ),
           tmpDate AS (SELECT tmpGoods.UnitId
                            , tmpGoods.UnitName
                            , tmpGoods.GoodsId
                            , tmpGoods.GoodsCode
                            , tmpGoods.GoodsName
                            , tmpGoods.isClose
                            , tmpGoods.MCSIsCloseDateChange
                            , tmpGoodsUnitCount.CountUnit::Integer     AS CountUnit
                            , tmpSellingCount.CountSelling::Integer    AS CountSelling
                            , ROUND (MinPrice_List.Price * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0) / 100), 2) :: TFloat  AS Price_min
                            , MinPrice_List.JuridicalId
                            , MinPrice_List.JuridicalName
                            , MinPrice_List.ContractId
                            , Object_Contract.ValueData       AS ContractName
                            , MinPrice_List.PartionGoodsDate  AS ExpirationDate
                       FROM tmpGoods

                            INNER JOIN tmpGoodsUnitCount ON tmpGoodsUnitCount.GoodsId = tmpGoods.GoodsId

                            INNER JOIN tmpSellingCount ON tmpSellingCount.GoodsId = tmpGoods.GoodsId
                                                      AND tmpSellingCount.CountSelling >= CEIL((vbUnitCount - tmpGoodsUnitCount.CountUnit) * inPercePharmaciesd / 100)
                                                      
                            LEFT JOIN ObjectLink AS OL_Unit_Area
                                                 ON OL_Unit_Area.ObjectId = tmpGoods.UnitId
                                                AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                 ON ObjectLink_Goods_NDSKind.ObjectId = tmpGoods.GoodsId
                                                AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                            LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                 ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId
 
                            LEFT JOIN tmpMinPrice_List AS MinPrice_List  ON MinPrice_List.GoodsId  = tmpGoods.GoodsId
                                                                        AND MinPrice_List.AreaId   =
                                                                            CASE WHEN COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis())  <> 12487449  
                                                                                 THEN COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis()) 
                                                                                 ELSE zc_Area_Basis() END
                                                                        AND MinPrice_List.PartionGoodsDate >= CURRENT_DATE + INTERVAL '1 YEAR'
                            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MinPrice_List.ContractId
                       ),
           tmpGoodsCount AS (SELECT Count(DISTINCT tmpDate.GoodsId) as GoodsCount FROM tmpDate) ,  
           tmpContainer AS (SELECT Container.ObjectId
                                 , Container.WhereObjectId
                                 , Container.Amount
                            FROM
                                Container
                            WHERE Container.DescId = zc_Container_Count()
                              AND Container.ObjectId in (SELECT DISTINCT tmpDate.GoodsId FROM tmpDate)
                              AND Container.WhereObjectId in (SELECT DISTINCT tmpDate.UnitId FROM tmpDate)
                              AND Container.Amount <> 0),
           tmpRemains AS (SELECT Container.ObjectId           AS GoodsId
                               , Container.WhereObjectId      AS UnitId
                               , SUM (Container.Amount)       AS Amount
                              FROM tmpContainer AS Container
                              GROUP BY Container.ObjectId
                                     , Container.WhereObjectId
                             ),
           tmpGoodsPromo AS (SELECT  MI_Goods.ObjectId  AS GoodsId        -- здесь товар
                                   , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                   , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                                   , MIFloat_Price.ValueData            AS Price
                                   , COALESCE (MIBoolean_Checked.ValueData, FALSE)                                           ::Boolean  AS isChecked
                                   , CASE WHEN COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE THEN FALSE ELSE TRUE END ::Boolean  AS isReport
                                   , MovementLinkObject_Maker.ObjectId  AS MakerId
                              FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                              ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                             AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                INNER JOIN MovementDate AS MovementDate_StartPromo
                                                        ON MovementDate_StartPromo.MovementId = Movement.Id
                                                       AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                INNER JOIN MovementDate AS MovementDate_EndPromo
                                                        ON MovementDate_EndPromo.MovementId = Movement.Id
                                                       AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                   AND MI_Goods.DescId = zc_MI_Master()
                                                                   AND MI_Goods.isErased = FALSE
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                              ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                             AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                              WHERE Movement.StatusId = zc_Enum_Status_Complete()
                                AND Movement.DescId = zc_Movement_Promo()
                         ),
            -- товары промо
           tmpGoods_All AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                                 , tmpGoodsPromo.StartDate_Promo
                                 , tmpGoodsPromo.EndDate_Promo
                                 , tmpGoodsPromo.MakerId
                            FROM tmpGoodsPromo
                                    -- !!!
                                   INNER JOIN ObjectLink AS ObjectLink_Child
                                                         ON ObjectLink_Child.ChildObjectId = tmpGoodsPromo.GoodsId
                                                        AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                           AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                   INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                             AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                   INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                              AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                             WHERE  ObjectLink_Child_R.ChildObjectId<>0
                           ),                             
           tmpListGodsMarket AS (SELECT tmpGoods_All.GoodsId
                                      , Max(tmpGoods_All.MakerId)    AS MakerId
                                 FROM tmpGoods_All
                                 WHERE tmpGoods_All.StartDate_Promo <= CURRENT_DATE
                                   AND tmpGoods_All.EndDate_Promo >= CURRENT_DATE
                                 GROUP BY tmpGoods_All.GoodsId
                                 )                             

           
    SELECT tmpDate.UnitName
         , tmpDate.GoodsCode
         , tmpDate.GoodsName
         , tmpDate.isClose
         , Object_Maker.Id
         , Object_Maker.ObjectCode
         , Object_Maker.ValueData
         , tmpDate.MCSIsCloseDateChange
         , tmpDate.CountUnit
         , tmpDate.CountSelling
         , vbUnitCount
         , tmpGoodsCount.GoodsCount::Integer
         , tmpRemains.Amount::TFloat   
         , tmpDate.Price_min
         , CASE WHEN COALESCE (tmpDate.Price_min, 0) > 0 AND COALESCE (tmpRemains.Amount, 0) < 1 THEN 1 ELSE 0 END::TFloat                  AS AmountOrder
         , CASE WHEN COALESCE (tmpDate.Price_min, 0) > 0 AND COALESCE (tmpRemains.Amount, 0) < 1 THEN tmpDate.Price_min ELSE 0 END::TFloat  AS SummaOrder
         , tmpDate.JuridicalId
         , tmpDate.JuridicalName
         , tmpDate.ContractId
         , tmpDate.ContractName
         , tmpDate.ExpirationDate
    FROM tmpDate

         INNER JOIN tmpGoodsCount ON 1 = 1
         
         LEFT JOIN tmpRemains ON tmpRemains.GoodsId =  tmpDate.GoodsId
                             AND tmpRemains.UnitId =  tmpDate.UnitId 

         LEFT JOIN tmpListGodsMarket ON tmpListGodsMarket.GoodsId = tmpDate.GoodsId

         LEFT JOIN Object AS Object_Maker
                          ON Object_Maker.ID = tmpListGodsMarket.MakerId
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.04.21                                                       *
*/

-- тест SELECT * FROM gpSelect_KilledCodeRecovery(200, 60, 1, '3')

select * from gpSelect_KilledCodeRecovery(inRangeOfDays := 200 , inPercePharmaciesd := 60 , inSalesThreshold := 1 ,  inSession := '3');