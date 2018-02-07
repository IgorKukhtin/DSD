-- View: SoldTable

DROP VIEW IF EXISTS SoldTable;

CREATE OR REPLACE VIEW SoldTable
AS
  -- Результат
  WITH tmpContainer AS (SELECT Container.Id         AS ContainerId
                             , Container.PartionId  AS PartionId
                             , CLO_Client.ObjectId  AS ClientId
                        FROM Container
                             INNER JOIN ContainerLinkObject AS CLO_Client
                                                            ON CLO_Client.ContainerId = Container.Id
                                                           AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                        WHERE Container.DescId   = zc_Container_Count()
                       )
  SELECT Object_PartionGoods.MovementItemId AS PartionId
       , Object_PartionGoods.BrandId
       , Object_PartionGoods.PeriodId
       , Object_PartionGoods.PeriodYear
       , Object_PartionGoods.PartnerId

       , Object_PartionGoods.GoodsGroupId
       , Object_PartionGoods.LabelId
       , Object_PartionGoods.CompositionGroupId
       , Object_PartionGoods.CompositionId

       , Object_PartionGoods.GoodsId
       , Object_PartionGoods.GoodsInfoId
       , Object_PartionGoods.LineFabricaId
       , Object_PartionGoods.GoodsSizeId

       , MIConatiner.OperDate AS OperDate
       , COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) :: Integer AS UnitId
       , tmpContainer.ClientId

       , Object_PartionGoods.UnitId     AS UnitId_in
       , Object_PartionGoods.CurrencyId AS CurrencyId
         -- Кол-во Приход от поставщика - только для UnitId
       , CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN Object_PartionGoods.Amount ELSE 0 END AS Income_Amount
       , Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS OperPrice

       , SUM (COALESCE (MIConatiner.Amount, 0)) :: TFloat AS Debt_Amount
       , SUM (CASE WHEN MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Amount
       , 0 :: TFloat AS Sale_Summ

       , 0 :: TFloat AS Sale_SummCost
       , 0 :: TFloat AS Sale_Summ_10100
       , 0 :: TFloat AS Sale_Summ_10201
       , 0 :: TFloat AS Sale_Summ_10202
       , 0 :: TFloat AS Sale_Summ_10203
       , 0 :: TFloat AS Sale_Summ_10204
       , 0 :: TFloat AS Sale_Summ_10200
  
       , SUM (CASE WHEN MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Return_Amount
       , 0 :: TFloat AS Return_Summ
       , 0 :: TFloat AS Return_SummCost
       , 0 :: TFloat AS Return_Summ_10200

       , SUM (CASE WHEN MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END
            - CASE WHEN MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END
              ) :: TFloat AS Result_Amount
       , 0 :: TFloat AS Result_Summ
       , 0 :: TFloat AS Result_SummCost
       , 0 :: TFloat AS Result_Summ_10200

  FROM Object_PartionGoods
       LEFT JOIN tmpContainer ON tmpContainer.PartionId = Object_PartionGoods.MovementItemId
       LEFT JOIN MovementItemContainer AS MIConatiner
                                       ON MIConatiner.ContainerId    = tmpContainer.ContainerId
                                      -- AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_GoodsAccount())
  GROUP BY Object_PartionGoods.MovementItemId
         , Object_PartionGoods.BrandId
         , Object_PartionGoods.PeriodId
         , Object_PartionGoods.PeriodYear
         , Object_PartionGoods.PartnerId
  
         , Object_PartionGoods.GoodsGroupId
         , Object_PartionGoods.LabelId
         , Object_PartionGoods.CompositionGroupId
         , Object_PartionGoods.CompositionId
  
         , Object_PartionGoods.GoodsId
         , Object_PartionGoods.GoodsInfoId
         , Object_PartionGoods.LineFabricaId
         , Object_PartionGoods.GoodsSizeId
  
         , MIConatiner.OperDate
         , MIConatiner.ObjectExtId_Analyzer
         , tmpContainer.ClientId

         , Object_PartionGoods.UnitId
         , Object_PartionGoods.CurrencyId
         , Object_PartionGoods.Amount
         , Object_PartionGoods.OperPrice
         , Object_PartionGoods.CountForPrice
       ;


ALTER TABLE SoldTable
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.02.18                                        *
*/

-- тест
-- SELECT * FROM SoldTable WHERE PeriodYear = 2017
