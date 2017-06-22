-- Function:  gpReport_Goods_RemainsCurrent()

DROP FUNCTION IF EXISTS gpReport_Goods_RemainsCurrent(Integer,Boolean, Boolean,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Goods_RemainsCurrent(
    IN inUnitId           Integer  ,  -- Подразделение / группа
    IN inisPartion        Boolean,    -- 
    IN inisSize           Boolean,    --
    IN inisPartner        Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber_Partion  TVarChar,
               OperDate_Partion   TDateTime,
               DescName_Partion   TVarChar,
               UnitName       TVarChar
               PartnerName    TVarChar,
               BrandName      TVarChar,
               FabrikaName    TVarChar,
               PeriodName     TVarChar,
               PeriodYear     Integer,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
               GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar,
               JuridicalName TVarChar,
               CompositionGroupName TVarChar,
               CompositionName TVarChar,
               GoodsInfoName TVarChar,
               LineFabricaName TVarChar,
               LabelName TVarChar,
               GoodsSizeName TVarChar,
               CurrencyName  TVarChar,

               CurrencyValue       TFloat,
               ParValue            TFloat,

               OperPrice           TFloat,
               OperPriceList       TFloat,
               PriceSale           TFloat,
               Remains             TFloat,
               TotalSummPrice      TFloat,
               TotalSummPriceList  TFloat,
               TotalSummSale       TFloat,
               TotalSummBalance    TFloat

  )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- таблица подразделений
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF COALESCE (inUnitId,0) <> 0
    THEN
        --
        INSERT INTO _tmpUnit (UnitId)
              SELECT tmp.UnitId
              FROM lfSelect_Object_Unit_byGroup (inUnitId) AS tmp;
    ELSE
        --
        INSERT INTO _tmpUnit (UnitId)
              SELECT Object_Unit.Id
              FROM Object AS Object_Unit
              WHERE Object_Unit.DescId = zc_Object_Unit();
    END IF;
    
    -- Результат
    RETURN QUERY
    WITH
     tmpContainer AS (SELECT tmp.UnitId
                           , tmp.PartionId
                           , tmp.GoodsId
                           , SUM (COALESCE (tmp.Remains,0)) AS Remains
                      FROM
                          (SELECT Container.WhereObjectId                                   AS UnitId
                                , Container.PartionId
                                , Container.ObjectId                                        AS GoodsId
                                , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Remains
                           FROM Container
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                           LEFT JOIN MovementItemContainer AS MIContainer 
                                                           ON MIContainer.ContainerId = Container.Id
                                                          AND MIContainer.OperDate > CURRENT_DATE
                           WHERE Container.DescId = zc_Container_count()
                           GROUP BY Container.WhereObjectId 
                                  , Container.PartionId 
                                  , Container.Amount 
                                  , Container.ObjectId
                           HAVING (Container.Amount - SUM (COALESCE (MIContainer.Amount, 0))) <> 0
                           ) AS tmp 
                      GROUP BY tmp.UnitId
                             , tmp.PartionId
                             , tmp.GoodsId
                      )

      , tmpPrice AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                          , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                     FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                          INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                               AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                               AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                          LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                  ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                 AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                 AND CURRENT_DATE >= ObjectHistory_PriceListItem.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem.EndDate
                          LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                       ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                      AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                     WHERE ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                    )

     , tmpData  AS  (SELECT tmpContainer.UnitId
                          , tmpContainer.GoodsId
                          , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE CAST (NULL AS TVarChar)  END    AS DescName_Partion
                          , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE CAST (NULL AS TVarChar)  END    AS InvNumber_Partion
                          , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE CAST (NULL AS TDateTime) END    AS OperDate_Partion
                          , CASE WHEN inisPartner = TRUE THEN Object_PartionGoods.PartnerId ELSE 0 END                           AS PartnerId
                          , CASE WHEN inisPartner = TRUE THEN Object_PartionGoods.BrandId              ELSE 0 END     AS BrandId
                          , CASE WHEN inisPartner = TRUE THEN ObjectLink_Partner_Fabrika.ChildObjectId ELSE 0 END     AS FabrikaId
                          , CASE WHEN inisPartner = TRUE THEN ObjectLink_Partner_Period.ChildObjectId  ELSE 0 END     AS PeriodId
                          , CASE WHEN inisSize    = TRUE THEN Object_PartionGoods.GoodsSizeId          ELSE 0 END     AS GoodsSizeId
                          , Object_PartionGoods.MeasureId
                          , Object_PartionGoods.GoodsGroupId
                          , Object_PartionGoods.CompositionId
                          , Object_PartionGoods.CompositionGroupId
                          , Object_PartionGoods.GoodsInfoId
                          , Object_PartionGoods.LineFabricaId 
                          , Object_PartionGoods.LabelId
                          , Object_PartionGoods.JuridicalId
                          , Object_PartionGoods.CurrencyId
                          , Object_PartionGoods.PeriodYear

                          , COALESCE (Object_PartionGoods.CountForPrice, 1)      AS CountForPrice
                          , SUM (tmpContainer.Remains)                           AS Remains
                          , SUM (CASE WHEN COALESCE (Object_PartionGoods.CountForPrice, 1) <> 0
                                          THEN CAST (COALESCE (tmpContainer.Remains, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) / COALESCE (Object_PartionGoods.CountForPrice, 1) AS NUMERIC (16, 2))
                                      ELSE CAST ( COALESCE (tmpContainer.Remains, 0) * COALESCE (Object_PartionGoods.OperPrice, 0) AS NUMERIC (16, 2))
                                 END) AS TotalSummPrice

                          , SUM (COALESCE (tmpContainer.Remains, 0) * COALESCE (tmpPrice.ValuePrice, 0))                AS TotalSummPriceList
                          , SUM (COALESCE (tmpContainer.Remains, 0) * COALESCE (Object_PartionGoods.PriceSale,0))       AS TotalSummSale
                     FROM tmpContainer
                          INNER JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpContainer.PartionId
                          LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = Object_PartionGoods.MovementId
                          LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId 

                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Fabrika
                                               ON ObjectLink_Partner_Fabrika.ObjectId = Object_PartionGoods.PartnerId
                                              AND ObjectLink_Partner_Fabrika.DescId = zc_ObjectLink_Partner_Fabrika()
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                               ON ObjectLink_Partner_Period.ObjectId = Object_PartionGoods.PartnerId
                                              AND ObjectLink_Partner_Period.DescId = zc_ObjectLink_Partner_Period()

                          LEFT JOIN tmpPrice ON tmpPrice.GoodsId = Object_PartionGoods.GoodsId

                     GROUP BY tmpContainer.UnitId
                            , tmpContainer.GoodsId
                            , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE CAST (NULL AS TVarChar)  END
                            , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE CAST (NULL AS TVarChar)  END
                            , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE CAST (NULL AS TDateTime) END
                            , CASE WHEN inisPartner = TRUE THEN Object_PartionGoods.PartnerId ELSE 0 END 
                            , CASE WHEN inisPartner = TRUE THEN Object_PartionGoods.BrandId              ELSE 0 END  
                            , CASE WHEN inisPartner = TRUE THEN ObjectLink_Partner_Fabrika.ChildObjectId ELSE 0 END 
                            , CASE WHEN inisPartner = TRUE THEN ObjectLink_Partner_Period.ChildObjectId  ELSE 0 END 
                            , CASE WHEN inisSize    = TRUE THEN Object_PartionGoods.GoodsSizeId          ELSE 0 END
                            , Object_PartionGoods.MeasureId
                            , Object_PartionGoods.GoodsGroupId
                            , Object_PartionGoods.CompositionId
                            , Object_PartionGoods.CompositionGroupId
                            , Object_PartionGoods.GoodsInfoId
                            , Object_PartionGoods.LineFabricaId 
                            , Object_PartionGoods.LabelId
                            , Object_PartionGoods.JuridicalId
                            , Object_PartionGoods.CurrencyId
                            , Object_PartionGoods.PeriodYear
                            , COALESCE (Object_PartionGoods.CountForPrice, 1) 
              )
              

        SELECT
             tmpData.InvNumber_Partion
           , tmpData.OperDate_Partion
           , tmpData.DescName_Partion
           , Object_Unit.ValueData          AS UnitName
           , Object_Partner.ValueData       AS PartnerName
           , Object_Brand.ValueData         AS BrandName
           , Object_Fabrika.ValueData       AS FabrikaName
           , Object_Period.ValueData        AS PeriodName
           , tmpData.PeriodYear

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , Object_Juridical.ValueData     AS JuridicalName
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.ValueData     AS GoodsSizeName
           , Object_Currency.ValueData      AS CurrencyName
           , tmpCurrency.Amount   ::TFloat  AS CurrencyValue
           , tmpCurrency.ParValue ::TFloat  AS ParValue

           , CASE WHEN tmpData.Remains <> 0 THEN tmpData.TotalSummPrice / tmpData.Remains ELSE 0 END            ::TFloat AS OperPrice
           , CASE WHEN tmpData.Remains <> 0 THEN tmpData.TotalSummPrice / tmpData.Remains ELSE 0 END            ::TFloat AS OperPriceList
           , CASE WHEN tmpData.Remains <> 0 THEN tmpData.TotalSummSale  / tmpData.Remains ELSE 0 END            ::TFloat AS PriceSale

           , tmpData.Remains                 ::TFloat
           , tmpData.TotalSummPrice          ::TFloat
           , tmpData.TotalSummPriceList      ::TFloat 
           , tmpData.TotalSummSale           ::TFloat 
            , (CAST (tmpData.TotalSummPrice * tmpCurrency.Amount / CASE WHEN tmpCurrency.ParValue <> 0 THEN tmpCurrency.ParValue ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS TotalSummBalance
           
        FROM tmpData
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpData.UnitId
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpData.GoodsId

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpData.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = tmpData.JuridicalId
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId

            LEFT JOIN Object AS Object_Brand   ON Object_Brand.Id   = tmpData.BrandId
            LEFT JOIN Object AS Object_Fabrika ON Object_Fabrika.Id = tmpData.FabrikaId
            LEFT JOIN Object AS Object_Period  ON Object_Period.Id  = tmpData.PeriodId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
        
            LEFT JOIN lfSelect_Movement_Currency_byDate (inOperDate:= CURRENT_DATE, inCurrencyFromId:= zc_Currency_Basis(), inCurrencyToId:= tmpData.CurrencyId) AS tmpCurrency ON 1=1


;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.06.17         *
*/

-- тест
--SELECT * from gpReport_Movement_Income(inUnitId :=0,inisPartion  := TRUE,inisSize:=  TRUE, inisPartner := TRUE, inSession := '2':: TVarChar )

