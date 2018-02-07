-- View: SoldTable

DROP VIEW IF EXISTS SoldTable;

CREATE OR REPLACE VIEW SoldTable
AS
  -- –ÂÁÛÎ¸Ú‡Ú
  SELECT Object_PartionGoods.MovementItemId AS PartionId
       , Object_PartionGoods.BrandId
       , Object_PartionGoods.PeriodId
       , Object_PartionGoods.PeriodYear
       , 0 :: Integer AS PeriodYearId
       , Object_PartionGoods.PartnerId

       , 0 :: Integer AS GoodsGroupId_all
       , Object_PartionGoods.GoodsGroupId
       , Object_PartionGoods.LabelId
       , Object_PartionGoods.CompositionGroupId
       , Object_PartionGoods.CompositionId

       , Object_PartionGoods.GoodsId
       , Object_PartionGoods.GoodsInfoId
       , Object_PartionGoods.LineFabricaId
       , 0 :: Integer AS FabrikaId
       , Object_PartionGoods.GoodsSizeId

       , COALESCE (MIConatiner.OperDate, Object_PartionGoods.OperDate) :: TDateTime AS OperDate
       , COALESCE (MIConatiner.WhereObjectId_Analyzer, Object_PartionGoods.UnitId) :: Integer AS UnitId

       , Object_PartionGoods.UnitId     AS UnitId_in
       , Object_PartionGoods.Amount     AS Income_Amount

       , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Amount
       , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  THEN MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Summ

       , 0 :: TFloat AS Sale_SummCost
       , 0 :: TFloat AS Sale_Summ_10100
       , 0 :: TFloat AS Sale_Summ_10201
       , 0 :: TFloat AS Sale_Summ_10202
       , 0 :: TFloat AS Sale_Summ_10203
       , 0 :: TFloat AS Sale_Summ_10204
       , 0 :: TFloat AS Sale_Summ_10200
  
       , 0 :: TFloat AS Return_Amount
       , 0 :: TFloat AS Return_Summ
       , 0 :: TFloat AS Return_SummCost
       , 0 :: TFloat AS Return_Summ_10200

       , 0 :: TFloat AS Result_Amount
       , 0 :: TFloat AS Result_Summ
       , 0 :: TFloat AS Result_SummCost
       , 0 :: TFloat AS Result_Summ_10200

  FROM Object_PartionGoods
       LEFT JOIN MovementItemContainer AS MIConatiner
                                       ON MIConatiner.PartionId      = Object_PartionGoods.MovementItemId
                                      AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_GoodsAccount())
  GROUP BY Object_PartionGoods.MovementItemId
         , Object_PartionGoods.BrandId
         , Object_PartionGoods.PeriodId
         , Object_PartionGoods.PeriodYear
         -- , 0 :: Integer AS PeriodYearId
         , Object_PartionGoods.PartnerId
  
         -- , 0 :: Integer AS GoodsGroupId_all
         , Object_PartionGoods.GoodsGroupId
         , Object_PartionGoods.LabelId
         , Object_PartionGoods.CompositionGroupId
         , Object_PartionGoods.CompositionId
  
         , Object_PartionGoods.GoodsId
         , Object_PartionGoods.GoodsInfoId
         , Object_PartionGoods.LineFabricaId
         -- , 0 :: Integer AS FabricaId
         , Object_PartionGoods.GoodsSizeId
  
         , COALESCE (MIConatiner.OperDate, Object_PartionGoods.OperDate)
         , COALESCE (MIConatiner.WhereObjectId_Analyzer, Object_PartionGoods.UnitId)
         , Object_PartionGoods.UnitId
         , Object_PartionGoods.Amount
       ;


ALTER TABLE SoldTable
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 07.02.18                                        *
*/

-- ÚÂÒÚ
-- SELECT * FROM SoldTable WHERE PeriodYear = 2017
