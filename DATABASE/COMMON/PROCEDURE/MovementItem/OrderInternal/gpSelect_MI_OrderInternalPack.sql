-- Function: gpSelect_MI_OrderInternalPack()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalPack (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalPack(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;

   DECLARE vbOperDate TDateTime;
   DECLARE vbDayCount Integer;
   DECLARE vbMonth Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������������
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (MovementDate_OperDateEnd.ValueData - MovementDate_OperDateStart.ValueData))
          , EXTRACT (MONTH FROM (Movement.OperDate + INTERVAL '1 DAY'))
            INTO vbOperDate, vbDayCount, vbMonth
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
     WHERE Movement.Id = inMovementId;


     -- 
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId_detail Integer, GoodsKindId_detail Integer, GoodsId Integer, GoodsKindId_complete Integer
                                    , ReceiptId Integer, ReceiptId_basis Integer
                                    , Amount TFloat, AmountSecond TFloat, AmountRemains TFloat, AmountPartnerPrior TFloat, AmountPartner TFloat
                                    , AmountForecast TFloat, AmountForecastOrder TFloat
                                    , Koeff TFloat, TermProduction TFloat, NormInDays TFloat, StartProductionInDays TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (MovementItemId, GoodsId_detail, GoodsKindId_detail, GoodsId, GoodsKindId_complete
                              , ReceiptId, ReceiptId_basis
                              , Amount, AmountSecond, AmountRemains, AmountPartnerPrior, AmountPartner
                              , AmountForecast, AmountForecastOrder
                              , Koeff, TermProduction, NormInDays, StartProductionInDays
                              , isErased)
                              SELECT MovementItem.Id AS MovementItemId
                                   , MovementItem.ObjectId AS GoodsId_detail
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_detail

                                   , COALESCE (MILinkObject_Goods.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN MovementItem.ObjectId
                                                    ELSE 0
                                               END
                                              )AS GoodsId

                                   , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                         THEN zc_GoodsKind_Basis()
                                                    ELSE 0
                                               END
                                              ) AS GoodsKindId_complete
                                   , COALESCE (MILinkObject_Receipt.ObjectId, 0)           AS ReceiptId
                                   , COALESCE (MILinkObject_ReceiptBasis.ObjectId, 0)      AS ReceiptId_basis

                                   , MovementItem.Amount                                   AS Amount
                                   , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

                                   , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
                                   , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)    AS AmountPartnerPrior
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0)         AS AmountPartner
                                   , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast
                                   , COALESCE (MIFloat_AmountForecastOrder.ValueData, 0)   AS AmountForecastOrder
                                   , COALESCE (MIFloat_Koeff.ValueData, 0)                 AS Koeff
                                   , COALESCE (MIFloat_TermProduction.ValueData, 0)        AS TermProduction
                                   , COALESCE (MIFloat_NormInDays.ValueData, 0)            AS NormInDays
                                   , COALESCE (MIFloat_StartProductionInDays.ValueData, 0) AS StartProductionInDays
                                   , MovementItem.isErased                                 AS isErased

                              FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                   INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = tmpIsErased.isErased
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

                                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                        ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                       AND  = Object_InfoMoney_View.InfoMoneyId

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                               ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                               ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                               ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()
                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                                               ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                                              AND MIFloat_AmountForecastOrder.DescId = zc_MIFloat_AmountForecastOrder()
 
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
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptBasis
                                                                    ON MILinkObject_ReceiptBasis.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                             ;


     -- 
     CREATE TEMP TABLE _tmpMI_child (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
     -- 
     INSERT INTO _tmpMI_child (MovementItemId, GoodsId, GoodsKindId, Amount)
             SELECT MovementItem.Id                                       AS MovementItemId
                  , MovementItem.ObjectId                                 AS GoodsId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                  , MovementItem.Amount                                   AS Amount
             FROM MovementItem
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Child()
               AND MovementItem.isErased   = FALSE;

       --
       OPEN Cursor1 FOR
        WITH tmpMI_master_find AS (SELECT MAX (tmpMI_master.MovementItemId) AS MovementItemId
                                   FROM _tmpMI_master AS tmpMI_master
                                   WHERE tmpMI_master.isErased = FALSE
                                   GROUP BY tmpMI_master.GoodsId_detail, tmpMI_master.GoodsKindId_detail
                                  )
           , tmpMIPartion_master AS (SELECT tmpMI_master.MovementItemId
                                          , SUM (_tmpMI_child.Amount) AS AmountRemains
                                     FROM tmpMI_master_find
                                          INNER JOIN _tmpMI_master AS tmpMI_master ON tmpMI_master.MovementItemId = tmpMI_master_find.MovementItemId
                                          INNER JOIN _tmpMI_child ON _tmpMI_child.GoodsId    = tmpMI_master.GoodsId_detail
                                                                 AND _tmpMI_child.GoodsKindId = tmpMI_master.GoodsKindId_detail
                                     GROUP BY tmpMI_master.MovementItemId
                                    )

       SELECT
             tmpMI.MovementItemId :: Integer     AS Id
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , Object_Goods_detail.ObjectCode              AS GoodsCode_detail
           , Object_Goods_detail.ValueData               AS GoodsName_detail
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , CASE WHEN tmpMI.GoodsId <> tmpMI.GoodsId_detail THEN TRUE ELSE FALSE END AS isCheck_detail

           , tmpMI.Amount           :: TFloat AS Amount           -- ����� �� ��-��
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- ������� �� ��-��

           , CAST (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner                             AS NUMERIC (16, 1)) :: TFloat AS AmountRemains_calc      -- �����. ���.
           , CAST (tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner + tmpMI.AmountRemains_child AS NUMERIC (16, 1)) :: TFloat AS AmountRemainsChild_calc -- *�����. ���. c ������ �� ����.

           , CAST (tmpMI.NormInDays     * tmpMI.CountForecast      * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognoz_calc          -- ����� ����� (�� ��.)
           , CAST (tmpMI.NormInDays     * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozOrder_calc     -- ����� ����� (�� ��.)
           , CAST (tmpMI.TermProduction * tmpMI.CountForecast      * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozTerm_calc      -- *����� ���. �� ���� (�� ��.)
           , CAST (tmpMI.TermProduction * tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS AmountPrognozOrderTerm_calc -- *����� ���. �� ���� (�� ��.)

           , CAST (tmpMI.AmountRemains_child  AS NUMERIC (16, 1)) :: TFloat AS AmountRemains_child  -- ������� �� ����.

           , CASE WHEN ABS (tmpMI.AmountRemains) < 1 THEN tmpMI.AmountRemains ELSE CAST (tmpMI.AmountRemains AS NUMERIC (16, 1)) END :: TFloat AS AmountRemains -- ���. �������.
           , CAST (tmpMI.AmountPartnerPrior  AS NUMERIC (16, 2)) :: TFloat AS AmountPartnerPrior  -- �������. ������
           , CAST (tmpMI.AmountPartner       AS NUMERIC (16, 2)) :: TFloat AS AmountPartner       -- ������� ������
           , CASE WHEN ABS (tmpMI.AmountForecast) < 1      THEN tmpMI.AmountForecast      ELSE CAST (tmpMI.AmountForecast AS NUMERIC (16, 1))      END :: TFloat AS AmountForecast      -- ������� �� ����.
           , CASE WHEN ABS (tmpMI.AmountForecastOrder) < 1 THEN tmpMI.AmountForecastOrder ELSE CAST (tmpMI.AmountForecastOrder AS NUMERIC (16, 1)) END :: TFloat AS AmountForecastOrder -- ������� �� ����.

           , CAST (tmpMI.CountForecast AS NUMERIC (16, 1))      :: TFloat AS CountForecast                     -- ���� 1� (�� ��.) ��� �
           , CAST (tmpMI.CountForecastOrder AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrder                -- ���� 1� (�� ��.) ��� �
           , CAST (tmpMI.CountForecast * tmpMI.Koeff AS NUMERIC (16, 1))      :: TFloat AS CountForecastK      -- ���� 1� (�� ��.)
           , CAST (tmpMI.CountForecastOrder * tmpMI.Koeff AS NUMERIC (16, 1)) :: TFloat AS CountForecastOrderK -- ���� 1� (�� ��.)

           , CAST (CASE WHEN tmpMI.CountForecast > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecast * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast      -- ���. � ���� (�� ����.) 
           , CAST (CASE WHEN tmpMI.CountForecastOrder > 0 AND tmpMI.Koeff > 0
                             THEN tmpMI.AmountRemains / (tmpMI.CountForecastOrder * tmpMI.Koeff)
                         ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecastOrder -- ���. � ���� (�� ��.)

           , tmpMI.Koeff                 :: TFloat AS Koeff                 -- �����.
           , tmpMI.TermProduction        :: TFloat AS TermProduction        -- ���� ������. � ��.
           , tmpMI.NormInDays            :: TFloat AS NormInDays            -- ����� ����� � ��.
           , tmpMI.StartProductionInDays :: TFloat AS StartProductionInDays -- ���. ������. � ��.

           , Object_GoodsKind.Id                 AS GoodsKindId
           , Object_GoodsKind.ValueData          AS GoodsKindName
           , Object_GoodsKind_detail.ValueData   AS GoodsKindName_detail
           , Object_Measure.ValueData            AS MeasureName
           , Object_Measure_detail.ValueData     AS MeasureName_detail

           , Object_Receipt_basis.Id                   AS ReceiptId_basis
           , Object_Receipt_basis.ObjectCode           AS ReceiptCode_code_basis
           , ObjectString_Receipt_Code_basis.ValueData AS ReceiptCode_basis
           , Object_Receipt_basis.ValueData            AS ReceiptName_basis

           , Object_Receipt.Id                         AS ReceiptId
           , Object_Receipt.ObjectCode                 AS ReceiptCode_code
           , ObjectString_Receipt_Code.ValueData       AS ReceiptCode
           , Object_Receipt.ValueData                  AS ReceiptName

           , Object_Unit.Id                            AS UnitId
           , Object_Unit.ObjectCode                    AS UnitCode
           , Object_Unit.ValueData                     AS UnitName 

           , CASE WHEN tmpMI.AmountRemains <= 0
                       THEN 1118719 -- clRed
                  ELSE 0 -- clBlack
             END :: Integer AS Color_remains
           , CASE WHEN tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner <= 0
                       THEN 1118719 -- clRed
                  ELSE 0 -- clBlack
             END :: Integer AS Color_remains_calc
           , CASE WHEN tmpMI.AmountRemains - tmpMI.AmountPartnerPrior - tmpMI.AmountPartner + tmpMI.AmountRemains_child <= 0
                       THEN 1118719 -- clRed
                  ELSE 0 -- clBlack
             END :: Integer AS Color_remainsChild_calc

           , 16777158   :: Integer AS ColorB_const            -- aclAqua
           , 14862279   :: Integer AS ColorB_DayCountForecast -- $00E2C7C7
           , 11987626   :: Integer AS ColorB_AmountPartner    -- $00B6EAAA
           , 8978431    :: Integer AS ColorB_AmountPrognoz    -- $008FF8F2 9435378

           , tmpMI.isErased

       FROM (SELECT tmpMI_master.MovementItemId AS MovementItemId
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail
                  , SUM (tmpMI_master.Amount)           AS Amount
                  , SUM (tmpMI_master.AmountSecond)     AS AmountSecond

                  , SUM (tmpMI_master.AmountRemains)       AS AmountRemains
                  , SUM (tmpMI_master.AmountPartnerPrior)  AS AmountPartnerPrior
                  , SUM (tmpMI_master.AmountPartner)       AS AmountPartner
                  , SUM (tmpMI_master.AmountForecast)      AS AmountForecast
                  , SUM (tmpMI_master.AmountForecastOrder) AS AmountForecastOrder

                  , CASE WHEN vbDayCount <> 0 THEN SUM (tmpMI_master.AmountForecast) / vbDayCount      ELSE 0 END AS CountForecast
                  , CASE WHEN vbDayCount <> 0 THEN SUM (tmpMI_master.AmountForecastOrder) / vbDayCount ELSE 0 END AS CountForecastOrder

                  , tmpMI_master.Koeff
                  , tmpMI_master.TermProduction
                  , tmpMI_master.NormInDays
                  , tmpMI_master.StartProductionInDays
                  , tmpMI_master.ReceiptId
                  , tmpMI_master.ReceiptId_basis
                  , tmpMI_master.GoodsId
                  , tmpMI_master.GoodsKindId_complete

                  , SUM (COALESCE (tmpMIPartion_master.AmountRemains, 0))  AS AmountRemains_child

                  , tmpMI_master.isErased
             FROM _tmpMI_master AS tmpMI_master
                  LEFT JOIN tmpMIPartion_master ON tmpMIPartion_master.MovementItemId = tmpMI_master.MovementItemId
             GROUP BY tmpMI_master.MovementItemId
                  , tmpMI_master.GoodsId_detail
                  , tmpMI_master.GoodsKindId_detail

                  , tmpMI_master.Koeff
                  , tmpMI_master.TermProduction
                  , tmpMI_master.NormInDays
                  , tmpMI_master.StartProductionInDays
                  , tmpMI_master.ReceiptId
                  , tmpMI_master.ReceiptId_basis
                  , tmpMI_master.GoodsId
                  , tmpMI_master.GoodsKindId_complete

                  , tmpMI_master.isErased
            ) AS tmpMI

            LEFT JOIN Object AS Object_Goods_detail ON Object_Goods_detail.Id = tmpMI.GoodsId_detail
            LEFT JOIN Object AS Object_GoodsKind_detail ON Object_GoodsKind_detail.Id = tmpMI.GoodsKindId_detail
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_detail
                                 ON ObjectLink_Goods_Measure_detail.ObjectId = Object_Goods_detail.Id
                                AND ObjectLink_Goods_Measure_detail.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure_detail ON Object_Measure_detail.Id = ObjectLink_Goods_Measure_detail.ChildObjectId

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()
 
            LEFT JOIN Object AS Object_Receipt_basis ON Object_Receipt_basis.Id = tmpMI.ReceiptId_basis
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code_basis
                                   ON ObjectString_Receipt_Code_basis.ObjectId = Object_Receipt_basis.Id
                                  AND ObjectString_Receipt_Code_basis.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId_complete

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = COALESCE (Object_Goods.Id, Object_Goods_detail.Id)
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Goods
                                 ON ObjectLink_OrderType_Goods.ChildObjectId = Object_Goods.Id
                                AND ObjectLink_OrderType_Goods.DescId = zc_ObjectLink_OrderType_Goods()
            LEFT JOIN ObjectLink AS ObjectLink_OrderType_Unit
                                 ON ObjectLink_OrderType_Unit.ObjectId = ObjectLink_OrderType_Goods.ObjectId
                                AND ObjectLink_OrderType_Unit.DescId = zc_ObjectLink_OrderType_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_OrderType_Unit.ChildObjectId
          ;

       RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternalPack (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.06.15                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MI_OrderInternalPack (inMovementId:= 1828419, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalPack (inMovementId:= 1828419, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
