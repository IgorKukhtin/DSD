-- Function: gpSelect_ObjectHistory_PriceListItem ()

DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ObjectHistory_PriceListItem (Integer, Integer, Integer, Integer, TDateTime, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectHistory_PriceListItem(
    IN inPriceListId        Integer   , -- ключ 
    IN inUnitId             Integer   , -- подразделение 
    IN inBrandId            Integer   , -- торговая марка 
    IN inPeriodId           Integer   , -- сезон
    IN inOperDate           TDateTime , -- Дата действия
    IN inStartYear          Integer   , -- год с
    IN inEndYear            Integer   , -- год по
    IN inShowAll            Boolean,   
    IN inSession            TVarChar    -- сессия пользователя
)                              
RETURNS TABLE (Id Integer , ObjectId Integer
                , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
                , GoodsNameFull TVarChar
                , isErased Boolean, GoodsGroupNameFull TVarChar
                , MeasureName TVarChar
                , GoodsGroupId         Integer
                , GoodsGroupName       TVarChar
                , CompositionGroupName TVarChar
                , CompositionName      TVarChar
                , GoodsInfoName        TVarChar
                , LineFabricaId        Integer
                , LineFabricaName      TVarChar
                , LabelId              Integer
                , LabelName            TVarChar
                , UnitId               Integer
                , UnitName             TVarChar
                , BrandId              Integer
                , BrandName            TVarChar
                , PeriodId             Integer
                , PeriodName           TVarChar
                , PeriodYear           Integer
                , FabrikaName          TVarChar
                --, GoodsSizeName        TVarChar
                , CurrencyName         TVarChar
                , OperPriceList        TFloat
                , OperPrice            TFloat
                , Remains              TFloat
                , AmountDebt           TFloat
                , RemainsAll           TFloat

                , StartDate TDateTime, EndDate TDateTime
                , ValuePrice TFloat
                , InsertName TVarChar, UpdateName TVarChar
                , InsertDate TDateTime, UpdateDate TDateTime
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_OH_PriceListItem());
    --vbUserId:= lpGetUserBySession (inSession);
    
    -- !!!замена!!!
    IF COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;
    
   IF inShowAll THEN 

    -- Выбираем данные
     RETURN QUERY 
     WITH 
      tmpPrice AS (SELECT ObjectHistory_PriceListItem.Id                   AS PriceListItemId
                        , ObjectHistory_PriceListItem.ObjectId             AS PriceListItemObjectId
                        , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                        , ObjectHistory_PriceListItem.StartDate            AS StartDate
                        , ObjectHistory_PriceListItem.EndDate              AS EndDate
                        , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
 
                   FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                             ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                            AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
       
                        LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                               AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                               AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                     ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                    AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
 
                   WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                     AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
                  )

    , tmpPartionGoods AS (SELECT Object_PartionGoods.MovementItemId  AS PartionId
                               , Object_Partner.ValueData            AS PartnerName
                               , Object_Unit.Id                      AS UnitId
                               , Object_Unit.ValueData               AS UnitName
                               , Object_PartionGoods.OperDate        AS OperDate
                               , Object_PartionGoods.GoodsId         AS GoodsId
                               , Object_Currency.ValueData           AS CurrencyName
                               , Object_PartionGoods.OperPrice       AS OperPrice
                               , Object_PartionGoods.OperPriceList   AS OperPriceList
                               , Object_Brand.Id                     AS BrandId
                               , Object_Brand.ValueData              AS BrandName
                               , Object_Period.Id                    AS PeriodId
                               , Object_Period.ValueData             AS PeriodName
                               , Object_PartionGoods.PeriodYear      AS PeriodYear
                               , Object_Fabrika.ValueData            AS FabrikaName
                               , Object_GoodsGroup.Id                AS GoodsGroupId
                               , Object_GoodsGroup.ValueData         AS GoodsGroupName
                               , Object_Measure.ValueData            AS MeasureName    
                               , Object_Composition.ValueData        AS CompositionName
                               , Object_GoodsInfo.ValueData          AS GoodsInfoName
                               , Object_LineFabrica.Id               AS LineFabricaId
                               , Object_LineFabrica.ValueData        AS LineFabricaName
                               , Object_PartionGoods.LabelId         AS LabelId
                               , Object_Label.ValueData              AS LabelName
                               , Object_CompositionGroup.ValueData   AS CompositionGroupName
                               --, Object_GoodsSize.ValueData          AS GoodsSizeName
                          FROM Object_PartionGoods
                               LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id = Object_PartiONGoods.PartnerId
                               LEFT JOIN Object AS Object_Unit        ON Object_Unit.Id    = Object_PartionGoods.UnitId
                               LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = Object_PartionGoods.CurrencyId
                               LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = Object_PartionGoods.BrandId
                               LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = Object_PartionGoods.PeriodId
                               LEFT JOIN Object AS Object_Fabrika     ON Object_Fabrika.Id     = Object_PartionGoods.FabrikaId
                               LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
                               LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
                               LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
                               LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                               LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                               LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
                               LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
                               --LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                          WHERE Object_PartionGoods.isErased = FALSE 
                            AND (Object_PartionGoods.UnitId = inUnitId OR inUnitId = 0)
                            AND (Object_PartionGoods.BrandId = inBrandId OR inBrandId = 0)
                            AND (Object_PartionGoods.PeriodId = inPeriodId OR inPeriodId = 0)   
                            AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                           -- AND (Object_PartionGoods.PeriodYear <= inEndYear OR inEndYear = 0)                   
                          )
    -- остаток
    , tmpContainer AS (SELECT Container.PartionId     AS PartionId
                            , Container.ObjectId      AS GoodsId
                            , Container.WhereObjectId AS UnitId
                            , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS Amount
                            , SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS AmountDebt
                       FROM Container
                            INNER JOIN (SELECT DISTINCT tmpPartionGoods.GoodsId 
                                        FROM tmpPartionGoods
                                        ) AS tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                            LEFT JOIN ContainerLinkObject AS CLO_Client
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                       WHERE Container.DescId        = zc_Container_Count()
                         AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                         AND CLO_Client.ContainerId IS NULL
                         AND Container.Amount       <> 0
                       GROUP BY Container.PartionId
                              , Container.ObjectId
                              , Container.WhereObjectId
                       HAVING SUM (Container.Amount)<> 0
                      )

    , tmpGoods AS (SELECT tmpPartionGoods.PartnerName
                        , tmpPartionGoods.UnitId
                        , tmpPartionGoods.UnitName
                        , tmpPartionGoods.OperDate
                        , tmpPartionGoods.GoodsId
                        , tmpPartionGoods.CurrencyName
                        , tmpPartionGoods.OperPrice
                        , tmpPartionGoods.OperPriceList
                        , tmpPartionGoods.BrandId
                        , tmpPartionGoods.BrandName
                        , tmpPartionGoods.PeriodId
                        , tmpPartionGoods.PeriodName
                        , tmpPartionGoods.PeriodYear
                        , tmpPartionGoods.FabrikaName
                        , tmpPartionGoods.GoodsGroupId
                        , tmpPartionGoods.GoodsGroupName
                        , tmpPartionGoods.MeasureName    
                        , tmpPartionGoods.CompositionName
                        , tmpPartionGoods.GoodsInfoName
                        , tmpPartionGoods.LineFabricaId
                        , tmpPartionGoods.LineFabricaName
                        , tmpPartionGoods.LabelId
                        , tmpPartionGoods.LabelName
                        , tmpPartionGoods.CompositionGroupName
                        --, tmpPartionGoods.GoodsSizeName
                        , SUM (COALESCE (tmpContainer.Amount, 0))        AS Remains
                        , SUM (COALESCE (tmpContainer.AmountDebt, 0))    AS AmountDebt
                   FROM tmpPartionGoods
                        LEFT JOIN tmpContainer ON tmpContainer.GoodsId   = tmpPartionGoods.GoodsId
                                              AND tmpContainer.PartionId = tmpPartionGoods.PartionId
                                              AND tmpContainer.UnitId    = tmpPartionGoods.UnitId
                   GROUP BY tmpPartionGoods.PartnerName
                          , tmpPartionGoods.UnitId
                          , tmpPartionGoods.UnitName
                          , tmpPartionGoods.OperDate
                          , tmpPartionGoods.GoodsId
                          , tmpPartionGoods.CurrencyName
                          , tmpPartionGoods.OperPrice
                          , tmpPartionGoods.OperPriceList
                          , tmpPartionGoods.BrandId
                          , tmpPartionGoods.BrandName
                          , tmpPartionGoods.PeriodId
                          , tmpPartionGoods.PeriodName
                          , tmpPartionGoods.PeriodYear
                          , tmpPartionGoods.FabrikaName
                          , tmpPartionGoods.GoodsGroupId
                          , tmpPartionGoods.GoodsGroupName
                          , tmpPartionGoods.MeasureName    
                          , tmpPartionGoods.CompositionName
                          , tmpPartionGoods.GoodsInfoName
                          , tmpPartionGoods.LineFabricaId
                          , tmpPartionGoods.LineFabricaName
                          , tmpPartionGoods.LabelId
                          , tmpPartionGoods.LabelName
                          , tmpPartionGoods.CompositionGroupName
                          --, tmpPartionGoods.GoodsSizeName
                   )

       SELECT
             tmpPrice.PriceListItemId             AS Id
           , tmpPrice.PriceListItemObjectId       AS ObjectId
           , Object_Goods.Id                      AS GoodsId               
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , (ObjectString_Goods_GoodsGroupFull.ValueData ||' - '||tmpPartionGoods.LabelName||' - '||Object_Goods.ObjectCode||' - ' || Object_Goods.ValueData) ::TVarChar AS GoodsNameFull
           , Object_Goods.isErased                AS isErased 
           
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , tmpPartionGoods.MeasureName          AS MeasureName
           , tmpPartionGoods.GoodsGroupId         AS GoodsGroupId
           , tmpPartionGoods.GoodsGroupName       AS GoodsGroupName
           , tmpPartionGoods.CompositionGroupName AS CompositionGroupName    
           , tmpPartionGoods.CompositionName      AS CompositionName
           , tmpPartionGoods.GoodsInfoName        AS GoodsInfoName
           , tmpPartionGoods.LineFabricaId        AS LineFabricaId
           , tmpPartionGoods.LineFabricaName      AS LineFabricaName
           , tmpPartionGoods.LabelId              AS LabelId
           , tmpPartionGoods.LabelName            AS LabelName
           
           , tmpPartionGoods.UnitId
           , tmpPartionGoods.UnitName
           , tmpPartionGoods.BrandId
           , tmpPartionGoods.BrandName
           , tmpPartionGoods.PeriodId
           , tmpPartionGoods.PeriodName
           , tmpPartionGoods.PeriodYear
           , tmpPartionGoods.FabrikaName
           --, tmpPartionGoods.GoodsSizeName
           , tmpPartionGoods.CurrencyName
           , tmpPartionGoods.OperPriceList   :: TFloat
           , tmpPartionGoods.OperPrice       :: TFloat
           , tmpPartionGoods.Remains         :: TFloat
           , tmpPartionGoods.AmountDebt      :: TFloat
           , (COALESCE(tmpPartionGoods.Remains, 0) + COALESCE(tmpPartionGoods.AmountDebt, 0)) :: TFloat  AS RemainsAll

           , CASE WHEN tmpPrice.StartDate = zc_DateStart() OR tmpPrice.StartDate < '01.01.1980' THEN NULL ELSE tmpPrice.StartDate END :: TDateTime  AS StartDate
           , CASE WHEN tmpPrice.EndDate   = zc_DateEnd() THEN NULL ELSE tmpPrice.EndDate   END :: TDateTime  AS EndDate
           , COALESCE (tmpPrice.ValuePrice, 0) :: TFloat  AS ValuePrice

           , Object_Insert.ValueData   AS InsertName
           , Object_Update.ValueData   AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

       FROM tmpGoods AS tmpPartionGoods 
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpPartionGoods.GoodsId
           
           LEFT JOIN tmpPrice ON tmpPrice.GoodsId= Object_Goods.Id --Object_Goods.DescId = zc_Object_Goods()
          
           LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                  ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                 AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

           LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                ON ObjectDate_Protocol_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
           LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                ON ObjectDate_Protocol_Update.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
 
           LEFT JOIN ObjectLink AS ObjectLink_Insert
                                ON ObjectLink_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   
 
           LEFT JOIN ObjectLink AS ObjectLink_Update
                                ON ObjectLink_Update.ObjectId = tmpPrice.PriceListItemObjectId
                               AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId              
        ;

   ELSE
    
     -- Выбираем данные
     RETURN QUERY 
     WITH 
      tmpPrice AS (SELECT ObjectHistory_PriceListItem.Id                   AS PriceListItemId
                        , ObjectHistory_PriceListItem.ObjectId             AS PriceListItemObjectId
                        , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                        , ObjectHistory_PriceListItem.StartDate            AS StartDate
                        , ObjectHistory_PriceListItem.EndDate              AS EndDate
                        , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
 
                   FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                        LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                             ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                            AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
       
                        LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                               AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                               AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                        LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                     ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                    AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
 
                   WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                     AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                     AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
                  )

    , tmpPartionGoods AS (SELECT Object_PartionGoods.MovementItemId  AS PartionId
                               , Object_Partner.ValueData            AS PartnerName
                               , Object_Unit.Id                      AS UnitId
                               , Object_Unit.ValueData               AS UnitName
                               , Object_PartionGoods.OperDate        AS OperDate
                               , Object_PartionGoods.GoodsId         AS GoodsId
                               , Object_Currency.ValueData           AS CurrencyName
                               , Object_PartionGoods.OperPrice       AS OperPrice
                               , Object_PartionGoods.OperPriceList   AS OperPriceList
                               , Object_Brand.Id                     AS BrandId
                               , Object_Brand.ValueData              AS BrandName
                               , Object_Period.Id                    AS PeriodId
                               , Object_Period.ValueData             AS PeriodName
                               , Object_PartionGoods.PeriodYear      AS PeriodYear
                               , Object_Fabrika.ValueData            AS FabrikaName
                               , Object_GoodsGroup.Id                AS GoodsGroupId
                               , Object_GoodsGroup.ValueData         AS GoodsGroupName
                               , Object_Measure.ValueData            AS MeasureName    
                               , Object_Composition.ValueData        AS CompositionName
                               , Object_GoodsInfo.ValueData          AS GoodsInfoName
                               , Object_LineFabrica.Id               AS LineFabricaId
                               , Object_LineFabrica.ValueData        AS LineFabricaName
                               , Object_PartionGoods.LabelId         AS LabelId
                               , Object_Label.ValueData              AS LabelName
                               , Object_CompositionGroup.ValueData   AS CompositionGroupName
                               --, Object_GoodsSize.ValueData          AS GoodsSizeName
                          FROM Object_PartionGoods
                               LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = Object_PartiONGoods.PartnerId
                               LEFT JOIN Object AS Object_Unit        ON Object_Unit.Id        = Object_PartionGoods.UnitId
                               LEFT JOIN Object AS Object_Currency    ON Object_Currency.Id    = Object_PartionGoods.CurrencyId
                               LEFT JOIN Object AS Object_Brand       ON Object_Brand.Id       = Object_PartionGoods.BrandId
                               LEFT JOIN Object AS Object_Period      ON Object_Period.Id      = Object_PartionGoods.PeriodId
                               LEFT JOIN Object AS Object_Fabrika     ON Object_Fabrika.Id     = Object_PartionGoods.FabrikaId
                               LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
                               LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
                               LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
                               LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
                               LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
                               LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
                               LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
                               --LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
                          WHERE Object_PartionGoods.isErased = FALSE 
                            AND (Object_PartionGoods.UnitId = inUnitId OR inUnitId = 0)
                            AND (Object_PartionGoods.BrandId = inBrandId OR inBrandId = 0)
                            AND (Object_PartionGoods.PeriodId = inPeriodId OR inPeriodId = 0)   
                            AND (Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear)
                            --AND (Object_PartionGoods.PeriodYear <= inEndYear OR inEndYear = 0)                   
                          )
    -- остаток
    , tmpContainer AS (SELECT Container.PartionId     AS PartionId
                            , Container.ObjectId      AS GoodsId
                            , Container.WhereObjectId AS UnitId
                            , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS Amount
                            , SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS AmountDebt
                       FROM Container
                            INNER JOIN (SELECT DISTINCT tmpPartionGoods.GoodsId 
                                        FROM tmpPartionGoods
                                        ) AS tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                            LEFT JOIN ContainerLinkObject AS CLO_Client
                                                          ON CLO_Client.ContainerId = Container.Id
                                                         AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                       WHERE Container.DescId        = zc_Container_Count()
                         AND (Container.WhereObjectId = inUnitId OR inUnitId = 0)
                         AND Container.Amount       <> 0
                       GROUP BY Container.PartionId
                              , Container.ObjectId
                              , Container.WhereObjectId
                       HAVING SUM (Container.Amount)<> 0
                      )

    , tmpGoods AS (SELECT tmpPartionGoods.PartnerName
                        , tmpPartionGoods.UnitId
                        , tmpPartionGoods.UnitName
                        , tmpPartionGoods.OperDate
                        , tmpPartionGoods.GoodsId
                        , tmpPartionGoods.CurrencyName
                        , tmpPartionGoods.OperPrice
                        , tmpPartionGoods.OperPriceList
                        , tmpPartionGoods.BrandId
                        , tmpPartionGoods.BrandName
                        , tmpPartionGoods.PeriodId
                        , tmpPartionGoods.PeriodName
                        , tmpPartionGoods.PeriodYear
                        , tmpPartionGoods.FabrikaName
                        , tmpPartionGoods.GoodsGroupId
                        , tmpPartionGoods.GoodsGroupName
                        , tmpPartionGoods.MeasureName    
                        , tmpPartionGoods.CompositionName
                        , tmpPartionGoods.GoodsInfoName
                        , tmpPartionGoods.LineFabricaId
                        , tmpPartionGoods.LineFabricaName
                        , tmpPartionGoods.LabelId
                        , tmpPartionGoods.LabelName
                        , tmpPartionGoods.CompositionGroupName
                        --, tmpPartionGoods.GoodsSizeName
                        , SUM (COALESCE (tmpContainer.Amount, 0))        AS Remains
                        , SUM (COALESCE (tmpContainer.AmountDebt, 0))    AS AmountDebt
                   FROM tmpPartionGoods
                        LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpPartionGoods.GoodsId
                                              AND tmpContainer.PartionId = tmpPartionGoods.PartionId
                                              AND tmpContainer.UnitId    = tmpPartionGoods.UnitId
                   GROUP BY tmpPartionGoods.PartnerName
                          , tmpPartionGoods.UnitId
                          , tmpPartionGoods.UnitName
                          , tmpPartionGoods.OperDate
                          , tmpPartionGoods.GoodsId
                          , tmpPartionGoods.CurrencyName
                          , tmpPartionGoods.OperPrice
                          , tmpPartionGoods.OperPriceList
                          , tmpPartionGoods.BrandId
                          , tmpPartionGoods.BrandName
                          , tmpPartionGoods.PeriodId
                          , tmpPartionGoods.PeriodName
                          , tmpPartionGoods.PeriodYear
                          , tmpPartionGoods.FabrikaName
                          , tmpPartionGoods.GoodsGroupId
                          , tmpPartionGoods.GoodsGroupName
                          , tmpPartionGoods.MeasureName    
                          , tmpPartionGoods.CompositionName
                          , tmpPartionGoods.GoodsInfoName
                          , tmpPartionGoods.LineFabricaId
                          , tmpPartionGoods.LineFabricaName
                          , tmpPartionGoods.LabelId
                          , tmpPartionGoods.LabelName
                          , tmpPartionGoods.CompositionGroupName
                          --, tmpPartionGoods.GoodsSizeName
                   )
       SELECT
             tmpPrice.PriceListItemId             AS Id
           , tmpPrice.PriceListItemObjectId       AS ObjectId
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , (ObjectString_Goods_GoodsGroupFull.ValueData ||' - '||tmpPartionGoods.LabelName||' - '||Object_Goods.ObjectCode||' - ' || Object_Goods.ValueData) ::TVarChar AS GoodsNameFull
           , Object_Goods.isErased                AS isErased 
           
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , tmpPartionGoods.MeasureName          AS MeasureName
           , tmpPartionGoods.GoodsGroupId         AS GoodsGroupId
           , tmpPartionGoods.GoodsGroupName       AS GoodsGroupName
           , tmpPartionGoods.CompositionGroupName AS CompositionGroupName    
           , tmpPartionGoods.CompositionName      AS CompositionName
           , tmpPartionGoods.GoodsInfoName        AS GoodsInfoName
           , tmpPartionGoods.LineFabricaId        AS LineFabricaId
           , tmpPartionGoods.LineFabricaName      AS LineFabricaName
           , tmpPartionGoods.LabelId              AS LabelId
           , tmpPartionGoods.LabelName            AS LabelName
           
           , tmpPartionGoods.UnitId
           , tmpPartionGoods.UnitName
           , tmpPartionGoods.BrandId
           , tmpPartionGoods.BrandName
           , tmpPartionGoods.PeriodId
           , tmpPartionGoods.PeriodName
           , tmpPartionGoods.PeriodYear
           , tmpPartionGoods.FabrikaName
           --, tmpPartionGoods.GoodsSizeName
           , tmpPartionGoods.CurrencyName
           , tmpPartionGoods.OperPriceList   :: TFloat
           , tmpPartionGoods.OperPrice       :: TFloat
           , tmpPartionGoods.Remains         :: TFloat
           , tmpPartionGoods.AmountDebt      :: TFloat
           , (COALESCE(tmpPartionGoods.Remains, 0) + COALESCE(tmpPartionGoods.AmountDebt, 0)) :: TFloat  AS RemainsAll
           
           , CASE WHEN tmpPrice.StartDate IN (zc_DateStart(), zc_DateEnd()) THEN NULL ELSE tmpPrice.StartDate END ::TDateTime  AS StartDate
           , CASE WHEN tmpPrice.EndDate   IN (zc_DateStart(), zc_DateEnd()) THEN NULL ELSE tmpPrice.EndDate   END ::TDateTime  AS EndDate
           , tmpPrice.ValuePrice

           , Object_Insert.ValueData              AS InsertName
           , Object_Update.ValueData              AS UpdateName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

       FROM tmpPrice
          INNER JOIN tmpGoods AS tmpPartionGoods ON tmpPartionGoods.GoodsId = tmpPrice.GoodsId

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = tmpPrice.PriceListItemObjectId 
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = tmpPrice.PriceListItemObjectId
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = tmpPrice.PriceListItemObjectId
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = tmpPrice.PriceListItemObjectId
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId
          --
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpPrice.GoodsId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
       ;
       
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.18         *
 06.03.18         *
 05.03.18         *
 01.03.18         * новые вх.параметры
 28.04.17         * битики + св-ва товара
 20.08.15         * add inShowAll
 25.07.13                        *
*/

-- тест
-- SELECT * FROM gpSelect_ObjectHistory_PriceListItem (inPriceListId := 4306, inUnitId:= 1159, inBrandId:= 710, inPeriodId:= 1174, inOperDate:= CURRENT_DATE, inStartYear:= 2007, inEndYear:= 2007, inShowAll:= FALSE, inSession:= zfCalc_UserAdmin());
