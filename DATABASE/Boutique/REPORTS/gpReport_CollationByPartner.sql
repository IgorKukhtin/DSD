-- Function:  gpReport_CollationByPartner()

DROP FUNCTION IF EXISTS gpReport_CollationByPartner (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CollationByPartner (
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inUnitId           Integer  ,  -- Подразделение
    IN inPartnerId        Integer  ,  -- Покупатель
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Text_info             TVarChar
             , MovementId            Integer
             , Invnumber             TVarChar
             , MovementDescName      TVarChar
             , OperDate              TDateTime
             
             , PartionId          Integer
             , DescName_Partion   TVarChar
             , InvNumber_Partion  TVarChar
             , OperDate_Partion   TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName        TVarChar
             , JuridicalName      TVarChar
             , CompositionGroupName TVarChar
             , CompositionName    TVarChar
             , GoodsInfoName      TVarChar
             , LineFabricaName    TVarChar
             , LabelName          TVarChar
             , GoodsSizeId Integer, GoodsSizeName    TVarChar
             , CurrencyName       TVarChar
             , BrandName          TVarChar
             , FabrikaName        TVarChar
             , PeriodName         TVarChar
             , PeriodYear         Integer

             , AmountStart     TFloat
             , AmountIn        TFloat
             , AmountOut       TFloat
             , AmountEnd       TFloat
             , SummStart       TFloat
             , SummIn          TFloat
             , SummOut         TFloat
             , SummEnd         TFloat
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbEndDate TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    vbEndDate := inEndDate + interval '1 day';

    -- Результат
    RETURN QUERY
    WITH
    tmpContainer AS (SELECT Container.Id                    AS ContainerId
                          , Container.DescId                AS ContainerDescId
                          , CLO_Client.ObjectId             AS ClientId 
                         -- , Container.ObjectId              AS GoodsId
                          , CASE WHEN Container.DescId = zc_Container_Count() THEN Container.ObjectId ELSE CLO_Goods.ObjectId END  AS GoodsId
                          , Container.PartionId             AS PartionId
                          , Container.Amount
                     FROM Container
                          INNER JOIN ContainerLinkObject AS CLO_Client 
                                                         ON CLO_Client.ContainerId = Container.Id
                                                        AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                        AND CLO_Client.ObjectId    = inPartnerId --inClientId --Перцева Наталья 6343  -- 
                          INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                         ON CLO_Unit.ContainerId = Container.Id
                                                        AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                        AND (CLO_Unit.ObjectId    = inUnitId OR inUnitId = 0)
                          LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                        ON CLO_Goods.ContainerId = Container.Id
                                                       AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()     
                      WHERE Container.ObjectId <> zc_Enum_Account_20102()                          
                     --WHERE Container.ObjectId = tmpWhere.GoodsId
                            --       AND Container.DescId = zc_Container_Count()

                    )

  , tmpMIContainer AS (SELECT tmpContainer.ContainerId
                            , tmpContainer.GoodsId
                            , tmpContainer.PartionId
                
                            , CASE WHEN tmpContainer.ContainerDescId = zc_Container_Count()
                                   THEN tmpContainer.Amount
                                   ELSE 0
                              END AS Amount
                            , CASE WHEN tmpContainer.ContainerDescId = zc_Container_Summ()
                                   THEN tmpContainer.Amount
                                   ELSE 0
                              END AS AmountSumm
  
                            , /*CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate)
                                        THEN MIContainer.MovementId
                                   ELSE 0
                              END*/ MIContainer.MovementId AS MovementId

                            , SUM (CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate) AND MIContainer.DescId = zc_Container_Count()
                                             THEN MIContainer.Amount
                                        ELSE 0
                                   END) AS Amount_Period
  
                            , SUM (CASE WHEN MIContainer.DescId = zc_Container_Count()
                                        THEN COALESCE (MIContainer.Amount, 0)
                                        ELSE 0
                                    END) AS Amount_Total
                            , SUM (CASE WHEN (MIContainer.OperDate BETWEEN inStartDate AND inEndDate) AND MIContainer.DescId = zc_Container_SummCurrency()
                                             THEN MIContainer.Amount
                                        ELSE 0
                                   END) AS Summ_Period
  
                            , SUM (CASE WHEN MIContainer.DescId = zc_Container_SummCurrency()
                                        THEN COALESCE (MIContainer.Amount, 0)
                                        ELSE 0
                                    END) AS Summ_Total
                       FROM tmpContainer
                            LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                          AND (MIContainer.OperDate >= inStartDate)
                       GROUP BY tmpContainer.ContainerId
                              , tmpContainer.GoodsId
                              , tmpContainer.PartionId
                              , CASE WHEN tmpContainer.ContainerDescId = zc_Container_Count()
                                   THEN tmpContainer.Amount
                                   ELSE 0
                                END
                              , CASE WHEN tmpContainer.ContainerDescId = zc_Container_Summ()
                                     THEN tmpContainer.Amount
                                     ELSE 0
                                END
                              , MIContainer.MovementId
     
                      )

  , tmpMIContainer_group AS (SELECT tmpMIContainer_all.Text_info
                                  , tmpMIContainer_all.MovementId
                                  , tmpMIContainer_all.GoodsId
                                  , tmpMIContainer_all.PartionId

                                  , SUM (tmpMIContainer_all.AmountStart)      AS AmountStart
                                  , SUM (tmpMIContainer_all.AmountEnd)        AS AmountEnd
                                  , SUM (tmpMIContainer_all.AmountIn)         AS AmountIn
                                  , SUM (tmpMIContainer_all.AmountOut)        AS AmountOut

                                  , SUM (tmpMIContainer_all.SummStart)        AS SummStart
                                  , SUM (tmpMIContainer_all.SummEnd)          AS SummEnd
                                  , SUM (tmpMIContainer_all.SummIn)           AS SummIn
                                  , SUM (tmpMIContainer_all.SummOut)          AS SummOut

                              FROM ( -- 1.1. Остатки нач.
                                    SELECT 'Долг начальный'  AS Text_info
                                         , tmpMIContainer.MovementId
                                         , tmpMIContainer.GoodsId
                                         , tmpMIContainer.PartionId

                                         , tmpMIContainer.Amount - SUM (tmpMIContainer.Amount_Total)   AS AmountStart
                                         , 0 AS AmountEnd
                                         , 0 AS AmountIn
                                         , 0 AS AmountOut
                                         , tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total) AS SummStart
                                         , 0 AS SummEnd
                                         , 0 AS SummIn
                                         , 0 AS SummOut
                                    FROM tmpMIContainer
                                    GROUP BY tmpMIContainer.ContainerId
                                           , tmpMIContainer.Amount
                                           , tmpMIContainer.AmountSumm
                                           , tmpMIContainer.MovementId
                                           , tmpMIContainer.GoodsId
                                           , tmpMIContainer.PartionId
                                    HAVING (tmpMIContainer.Amount - SUM (tmpMIContainer.Amount_Total)) <> 0
                                        OR (tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total)) <> 0
                                   UNION ALL
                                    -- 1.1. Остатки конечн.
                                    SELECT 'Долг конечный'   AS Text_info
                                         , tmpMIContainer.MovementId
                                         , tmpMIContainer.GoodsId
                                         , tmpMIContainer.PartionId

                                         , 0 AS AmountStart
                                         , tmpMIContainer.Amount - SUM (tmpMIContainer.Amount_Total) + SUM (tmpMIContainer.Amount_Period) AS AmountEnd
                                         , 0 AS AmountIn
                                         , 0 AS AmountOut
                                         , 0 AS SummStart
                                         , tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total) + SUM (tmpMIContainer.Summ_Period) AS SummEnd
                                         , 0 AS SummIn
                                         , 0 AS SummOut
                                    FROM tmpMIContainer
                                    GROUP BY tmpMIContainer.ContainerId
                                           , tmpMIContainer.Amount
                                           , tmpMIContainer.AmountSumm
                                           , tmpMIContainer.MovementId
                                            , tmpMIContainer.GoodsId
                                           , tmpMIContainer.PartionId
                                    HAVING (tmpMIContainer.Amount - SUM (tmpMIContainer.Amount_Total) + SUM (tmpMIContainer.Amount_Period)) <> 0
                                        OR (tmpMIContainer.AmountSumm - SUM (tmpMIContainer.Summ_Total) + SUM (tmpMIContainer.Summ_Period)) <> 0
                                   UNION ALL
                                    -- 1.2. Движение
                                    SELECT 'Движение'        AS Text_info
                                         , tmpMIContainer.MovementId
                                         , tmpMIContainer.GoodsId
                                         , tmpMIContainer.PartionId

                                         , 0 AS AmountStart
                                         , 0 AS AmountEnd
                                         , CASE WHEN tmpMIContainer.Amount_Period > 0 THEN      tmpMIContainer.Amount_Period ELSE 0 END AS AmountIn
                                         , CASE WHEN tmpMIContainer.Amount_Period < 0 THEN -1 * tmpMIContainer.Amount_Period ELSE 0 END AS AmountOut
                                         , 0 AS SummStart
                                         , 0 AS SummEnd
                                         , CASE WHEN tmpMIContainer.Summ_Period > 0 THEN      tmpMIContainer.Summ_Period ELSE 0 END AS SummIn
                                         , CASE WHEN tmpMIContainer.Summ_Period < 0 THEN -1 * tmpMIContainer.Summ_Period ELSE 0 END AS SummOut
                                    FROM tmpMIContainer
                                    WHERE tmpMIContainer.Amount_Period <> 0
                                       OR tmpMIContainer.Summ_Period <> 0
                                   ) AS tmpMIContainer_all
                      
                              GROUP BY tmpMIContainer_all.Text_info
                                     , tmpMIContainer_all.MovementId
                                     , tmpMIContainer_all.GoodsId
                                     , tmpMIContainer_all.PartionId
                             )


   SELECT tmpData.Text_info :: TVarChar
        , Movement.Id                    AS MovementId
        , Movement.InvNumber             AS InvNumber
        , MovementDesc.ItemName          AS MovementDescName
        , Movement.OperDate              AS OperDate
        
        , tmpData.PartionId              AS PartionId
        , MovementDesc_Partion.ItemName          AS DescName_Partion
        , Movement_Partion.InvNumber     AS InvNumber_Partion
        , Object_PartionGoods.OperDate   AS OperDate_Partion
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
        , Object_GoodsSize.Id            AS GoodsSizeId
        , Object_GoodsSize.ValueData     AS GoodsSizeName
        , Object_Currency.ValueData      AS CurrencyName
        , Object_Brand.ValueData         AS BrandName
        , Object_Fabrika.ValueData       AS FabrikaName
        , Object_Period.ValueData        AS PeriodName
        , Object_PartionGoods.PeriodYear ::Integer
             
        , CAST (tmpData.AmountStart AS TFloat) AS AmountStart
        , CAST (tmpData.AmountIn AS TFloat)    AS AmountIn
        , CAST (tmpData.AmountOut AS TFloat)   AS AmountOut
        , CAST (tmpData.AmountEnd AS TFloat)   AS AmountEnd
      
        , CAST (tmpData.SummStart AS TFloat)   AS SummStart
        , CAST (tmpData.SummIn AS TFloat)      AS SummIn
        , CAST (tmpData.SummOut AS TFloat)     AS SummOut
        , CAST (tmpData.SummEnd AS TFloat)     AS SummEnd
        

   FROM tmpMIContainer_group AS tmpData
        LEFT JOIN Movement ON Movement.Id = tmpData.MovementId
        LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

        LEFT JOIN Object_PartionGoods      ON Object_PartionGoods.MovementItemId  = tmpData.PartionId
        
        LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = Object_PartionGoods.GoodsId 
        LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
        LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
        LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
        LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
        LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
        LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
        LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
        LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
        LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id        = Object_PartionGoods.JuridicalId
        LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = Object_PartionGoods.CurrencyId
        LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = Object_PartionGoods.BrandId
        LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = Object_PartionGoods.PeriodId
        LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = Object_PartionGoods.FabrikaId
        
        LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = Object_PartionGoods.MovementId
        LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId

        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id 
                              AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
        ;
 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 22.01.18         *
*/

-- тест
--  select * from gpReport_CollationByPartner(inStartDate := ('01.03.2017')::TDateTime , inEndDate := ('31.03.2017')::TDateTime , inUnitId := 4195 , inPartnerId := 9765 ,  inSession := '2');