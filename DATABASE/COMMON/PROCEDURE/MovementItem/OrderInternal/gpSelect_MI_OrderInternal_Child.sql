-- Function: gpSelect_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternal_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternal_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;

   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;

   DECLARE vbDayCount Integer;
   DECLARE vbMonth Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- определяется
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbOperDate, vbDayCount, vbMonth, vbFromId, vbToId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId;


     --
     CREATE TEMP TABLE _tmpMI_master ( GoodsId_detail Integer, GoodsKindId_detail Integer, GoodsId Integer, GoodsId_basis Integer, GoodsKindId_complete Integer
                                    , Amount TFloat, AmountRemains TFloat                                   
                                    , KoeffLoss TFloat, TaxLoss TFloat,  Koeff TFloat, TermProduction TFloat, NormInDays TFloat, StartProductionInDays TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (GoodsId, GoodsId_basis, GoodsKindId_complete
                              , Amount, AmountRemains
                              , KoeffLoss, TaxLoss, Koeff, TermProduction--, NormInDays, StartProductionInDays
                              , isErased)
                              SELECT COALESCE (MILinkObject_Goods.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN MovementItem.ObjectId
                                                    ELSE 0
                                               END
                                              )AS GoodsId
                                   , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis
                                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN zc_GoodsKind_Basis()
                                                    ELSE 0
                                               END
                                              ) AS GoodsKindId_complete
                                   , SUM (MovementItem.Amount)                                   AS Amount
                                   , SUM (COALESCE (MIFloat_AmountRemains.ValueData, 0))         AS AmountRemains
                                     --
                                   , MAX (CASE WHEN ObjectFloat_TaxLoss.ValueData > 0 THEN 1 - ObjectFloat_TaxLoss.ValueData / 100 ELSE 1 END) AS KoeffLoss
                                   , MAX (CASE WHEN ObjectFloat_TaxLoss.ValueData > 0 THEN ObjectFloat_TaxLoss.ValueData ELSE 0 END) AS TaxLoss
                                   , MAX (COALESCE (MIFloat_Koeff.ValueData, 0))                 AS Koeff
                                   , MIN (COALESCE (MIFloat_TermProduction.ValueData, 0))        AS TermProduction
                                 
                                 --  , COALESCE (MIFloat_NormInDays.ValueData, 0)            AS NormInDays
                                 --  , COALESCE (MIFloat_StartProductionInDays.ValueData, 0) AS StartProductionInDays
                                   , MovementItem.isErased                                 AS isErased

                              FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                   INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = tmpIsErased.isErased
                                  
                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                       AND  = Object_InfoMoney_View.InfoMoneyId

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                               ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                  

                                   LEFT JOIN MovementItemFloat AS MIFloat_CuterCount
                                                               ON MIFloat_CuterCount.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CuterCount.DescId = zc_MIFloat_CuterCount()
                                   LEFT JOIN MovementItemFloat AS MIFloat_CuterCountSecond
                                                               ON MIFloat_CuterCountSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CuterCountSecond.DescId = zc_MIFloat_CuterCountSecond()
                                   LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                                               ON MIFloat_Koeff.MovementItemId = MovementItem.Id
                                                              AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()
                                   LEFT JOIN MovementItemFloat AS MIFloat_TermProduction
                                                               ON MIFloat_TermProduction.MovementItemId = MovementItem.Id
                                                              AND MIFloat_TermProduction.DescId = zc_MIFloat_TermProduction()
                                   LEFT JOIN MovementItemFloat AS MIFloat_NormInDays
                                                               ON MIFloat_NormInDays.MovementItemId = MovementItem.Id
                                                              AND MIFloat_NormInDays.DescId = zc_MIFloat_NormInDays()
                                   LEFT JOIN MovementItemFloat AS MIFloat_StartProductionInDays
                                                               ON MIFloat_StartProductionInDays.MovementItemId = MovementItem.Id
                                                              AND MIFloat_StartProductionInDays.DescId = zc_MIFloat_StartProductionInDays()

                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                                    ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsBasis.DescId = zc_MILinkObject_GoodsBasis()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                                    ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                    ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                                                    ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
                                   LEFT JOIN ObjectFloat AS ObjectFloat_TaxLoss
                                                         ON ObjectFloat_TaxLoss.ObjectId = MILinkObject_Receipt.ObjectId
                                                        AND ObjectFloat_TaxLoss.DescId = zc_ObjectFloat_Receipt_TaxLoss()
                              GROUP BY COALESCE (MILinkObject_Goods.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN MovementItem.ObjectId
                                                    ELSE 0
                                               END
                                              )
                                   , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)
                                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN zc_GoodsKind_Basis()
                                                    ELSE 0
                                               END
                                              ) 
                                   , MovementItem.isErased             
                             ;

     --
     CREATE TEMP TABLE _tmpMI_child (MovementItemId Integer, ParentId Integer, GoodsId Integer, GoodsKindId Integer, GoodsKindId_complete Integer, PartionGoodsDate TDateTime, ContainerId Integer, Amount TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI_child (MovementItemId, ParentId, GoodsId, GoodsKindId, GoodsKindId_complete, PartionGoodsDate, ContainerId, Amount)
             SELECT MovementItem.Id                                       AS MovementItemId
                  , MovementItem.ParentId                                 AS ParentId
                  , MovementItem.ObjectId                                 AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                  , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete
                  , MIDate_PartionGoods.ValueData                         AS PartionGoodsDate
                  , MIFloat_ContainerId.ValueData                         AS ContainerId
                  , MovementItem.Amount                                   AS Amount
             FROM MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                              ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                             AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                   ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Child()
               AND MovementItem.isErased   = FALSE;


       OPEN Cursor1 FOR
        WITH tmpGoods_params AS (SELECT _tmpMI_master.GoodsId_basis
                                      , MIN (_tmpMI_master.TermProduction) AS TermProduction
                                      , MAX (_tmpMI_master.KoeffLoss) AS KoeffLoss
                                      , MAX (_tmpMI_master.TaxLoss)   AS TaxLoss
                                 FROM _tmpMI_master
                                 GROUP BY _tmpMI_master.GoodsId_basis
                                )
       SELECT
             _tmpMI_child.MovementItemId         AS Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKindComplete.Id         AS GoodsKindId_complete
           , Object_GoodsKindComplete.ValueData  AS GoodsKindName_complete
           , Object_Measure.ValueData            AS MeasureName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , _tmpMI_child.PartionGoodsDate    ::TDateTime
           , CASE WHEN ABS (_tmpMI_child.Amount) < 1 THEN _tmpMI_child.Amount ELSE CAST (_tmpMI_child.Amount AS NUMERIC (16, 1)) END :: TFloat AS Amount
           , CAST (_tmpMI_child.Amount * tmpGoods_params.KoeffLoss AS NUMERIC (16, 1)) :: TFloat AS Amount_calc
           , CAST (tmpGoods_params.TaxLoss AS NUMERIC (16, 1))                         :: TFloat AS TaxLoss
           , CASE WHEN _tmpMI_child.PartionGoodsDate <= (vbOperDate :: Date - tmpGoods_params.TermProduction :: Integer)
                       THEN CAST (_tmpMI_child.Amount * tmpGoods_params.KoeffLoss AS NUMERIC (16, 1))
                  ELSE 0
             END :: TFloat AS Amount_old
           , CASE WHEN _tmpMI_child.PartionGoodsDate > (vbOperDate :: Date - tmpGoods_params.TermProduction :: Integer)
                       THEN CAST (_tmpMI_child.Amount * tmpGoods_params.KoeffLoss AS NUMERIC (16, 1))
                  ELSE 0
             END :: TFloat AS Amount_next  
           , 0   ::TFloat  AS AmountRemains 
           --, 0   ::TFloat  AS AmountRemains_sh
           , _tmpMI_child.ContainerId  ::Integer  
           , (vbOperDate :: Date - tmpGoods_params.TermProduction :: Integer) :: TDateTime AS Date_TermProd
           , FALSE AS isErased
       FROM _tmpMI_child
             LEFT JOIN tmpGoods_params ON tmpGoods_params.GoodsId_basis = _tmpMI_child.GoodsId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpMI_child.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpMI_child.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpMI_child.GoodsKindId_complete

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = _tmpMI_child.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
             
             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
     --   where _tmpMI_child.GoodsId = 2588     
      UNION all
       SELECT
             0    ::Integer    AS Id
           , Object_Goods.Id                    ::Integer  AS GoodsId
           , Object_Goods.ObjectCode            ::Integer  AS GoodsCode
           , Object_Goods.ValueData             ::TVarChar AS GoodsName
           , ''               ::TVarChar        ::TVarChar AS GoodsKindName
           , Object_GoodsKindComplete.Id        ::Integer  AS GoodsKindId_complete
           , Object_GoodsKindComplete.ValueData ::TVarChar  AS GoodsKindName_complete
           , Object_Measure.ValueData           ::TVarChar  AS MeasureName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , NULL                               ::TDateTime AS PartionGoodsDate
           , 0 :: TFloat AS Amount --CASE WHEN ABS (_tmpMI_master.Amount) < 1 THEN _tmpMI_master.Amount ELSE CAST (_tmpMI_master.Amount AS NUMERIC (16, 1)) END :: TFloat AS Amount
           , 0  :: TFloat AS Amount_calc
           , CAST (_tmpMI_master.TaxLoss AS NUMERIC (16, 1))                           :: TFloat AS TaxLoss
           , 0 :: TFloat AS Amount_old
           , 0 :: TFloat AS Amount_next 
           , _tmpMI_master.AmountRemains  :: TFloat
          -- , _tmpMI_master.AmountRemains_sh
           , NULL ::Integer AS ContainerId  
           , Null :: TDateTime AS Date_TermProd
           , _tmpMI_master.isErased
       FROM _tmpMI_master
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpMI_master.GoodsId
             --LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = _tmpMI_master.GoodsKindId
             LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = _tmpMI_master.GoodsKindId_complete

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = _tmpMI_master.GoodsId
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId 

             LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                    ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
       where COALESCE (_tmpMI_master.AmountRemains,0) <> 0 --AND _tmpMI_master.GoodsId = 2588
       ;
 
      RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.10.23         * 
*/

-- тест
-- select * from gpSelect_MI_OrderInternal_Child(inMovementId := 26307830 , inIsErased := 'False' ,  inSession := '9457') ; 
     --  FETCH ALL "<unnamed portal 12>";