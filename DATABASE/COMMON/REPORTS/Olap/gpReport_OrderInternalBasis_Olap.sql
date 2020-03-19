-- Function: gpReport_OrderInternalBasis_Olap ()

DROP FUNCTION IF EXISTS gpReport_OrderInternalBasis_Olap (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderInternalBasis_Olap (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderInternalBasis_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inFromId             Integer   ,    -- �� ����
    IN inToId               Integer   ,    -- ���� 
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS TABLE (OperDate            TDateTime
             , InvNumber           TVarChar
             , DayOfWeekName       TVarChar
             , DayOfWeekNumber     Integer
             , MonthName           TVarChar
             , FromCode            Integer
             , FromName            TVarChar
             , ToCode              Integer
             , ToName              TVarChar
             , GoodsGroupNameFull  TVarChar
             , GoodsGroupName      TVarChar
             , GoodsId             Integer
             , GoodsCode           Integer
             , GoodsName           TVarChar
             , GoodsKindId         Integer
             , GoodsKindName       TVarChar
             , Amount              TFloat -- ����� �� �����
             , AmountSecond        TFloat -- ������� �� �����
             , AmountSend          TFloat -- ������ �� "�������"
             , Amount_calc         TFloat -- ��������� �����
             , AmountRemains       TFloat -- ���. �������.
             , AmountPartner       TFloat -- ������ ������������ �� ������ �� ������������ (��� ������������ ��)
             , AmountPartnerPrior  TFloat -- ������ ������������ �� ������ �� ������������ (��� ������������ ��)
             , AmountPartner_all   TFloat -- ������ ������������ �� ������ �� ������������ (�����)
             , AmountPartnerSecond TFloat -- ������ ....
             , AmountForecast      TFloat -- ������� �� ����. ������� �� ������������
             , CountForecast       TFloat -- ���� 1� (�� ��.)
             , DayCountForecast    TFloat -- ���. � ���� (�� ��.)  
             )   
AS
$BODY$
BEGIN

    -- ����������� �� ������
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
 
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
          SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE IF inGoodsId <> 0
         THEN
             INSERT INTO _tmpGoods (GoodsId)
              SELECT inGoodsId;
         ELSE
             INSERT INTO _tmpGoods (GoodsId)
               SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
         END IF;
    END IF;

    -- ����������� �� ��������������
    CREATE TEMP TABLE _tmpUnitFrom (UnitId Integer) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpUnitTo (UnitId Integer) ON COMMIT DROP;
    -- �� ����
    IF inFromId <> 0
    THEN
        INSERT INTO _tmpUnitFrom (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpUnitFrom (UnitId)
          SELECT Id FROM Object_Unit_View;
    END IF;
    -- ����
    IF inToId <> 0
    THEN
        INSERT INTO _tmpUnitTo (UnitId)
           SELECT UnitId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup;
    ELSE
         INSERT INTO _tmpUnitTo (UnitId)
          SELECT Id FROM Object_Unit_View;
    END IF;
    -------

    
    -- ���������
    RETURN QUERY
    WITH
     tmpMovement AS (SELECT Movement.Id        AS Id
                          , Movement.OperDate  AS OperDate
                          , Movement.InvNumber
                          , 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData))) AS DayCount
                          , MovementLinkObject_From.ObjectId AS FromId
                     FROM Movement 
                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                        INNER JOIN _tmpUnitFrom ON _tmpUnitFrom.UnitId = MovementLinkObject_From.ObjectId

                        LEFT JOIN MovementBoolean AS MovementBoolean_Remains
                                                  ON MovementBoolean_Remains.MovementId = Movement.Id
                                                 AND MovementBoolean_Remains.DescId = zc_MovementBoolean_Remains()

                        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                               ON MovementDate_OperDateStart.MovementId = Movement.Id
                                              AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
                        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                               ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                              AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

                     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                       AND Movement.DescId = zc_Movement_OrderInternal()
                       AND Movement.StatusId = zc_Enum_Status_Complete()
                       AND (COALESCE (MovementBoolean_Remains.ValueData, FALSE) = FALSE)
                     )
     
     , tmpMI AS (SELECT Movement.Id           AS MovementId
                      , Movement.FromId       AS FromId
                      , Movement.OperDate     AS OperDate
                      , Movement.InvNumber    AS InvNumber
                      , Movement.DayCount     AS DayCount
                      , MovementItem.Id       AS MovementItemId
                      , MovementItem.ObjectId AS GoodsId
                      , MovementItem.Amount   AS Amount
                 FROM tmpMovement AS Movement
                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = FALSE
                      INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                 )
     
     , tmpMIFloat AS (SELECT MovementItemFloat.*
                      FROM MovementItemFloat
                      WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemFloat.DescId IN (zc_MIFloat_AmountSecond()
                                                       , zc_MIFloat_AmountRemains()
                                                       , zc_MIFloat_AmountPartner()
                                                       , zc_MIFloat_AmountPartnerPrior()
                                                       , zc_MIFloat_AmountPartnerSecond()
                                                       , zc_MIFloat_AmountForecast()
                                                       )
                      )

     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                             )

     , tmpMILO_Receipt AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId = zc_MILinkObject_Receipt()
                             )

     , tmpData AS (SELECT tmpMI.OperDate
                        , STRING_AGG (tmpMI.InvNumber :: TVarChar, ';') :: TVarChar AS InvNumber
                        , tmpMI.DayCount
                        , tmpMI.FromId
                        , tmpMI.GoodsId
                        , COALESCE (MILinkObject_Receipt.ObjectId, 0)   AS ReceiptId
                        , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                        , SUM (tmpMI.Amount)                                          AS Amount
                        , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))          AS AmountSecond
                        , SUM (COALESCE (MIFloat_AmountRemains.ValueData, 0))         AS AmountRemains
                        , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))         AS AmountPartner
                        , SUM (COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0))    AS AmountPartnerPrior
                        , SUM (COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0))   AS AmountPartnerSecond
                        , SUM (COALESCE (MIFloat_AmountForecast.ValueData, 0))        AS AmountForecast
                   FROM tmpMI
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountSecond
                                             ON MIFloat_AmountSecond.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountRemains
                                             ON MIFloat_AmountRemains.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountPartner
                                             ON MIFloat_AmountPartner.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountPartnerPrior
                                             ON MIFloat_AmountPartnerPrior.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountPartnerSecond
                                             ON MIFloat_AmountPartnerSecond.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
                        LEFT JOIN tmpMIFloat AS MIFloat_AmountForecast
                                             ON MIFloat_AmountForecast.MovementItemId = tmpMI.MovementItemId
                                            AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()

                        LEFT JOIN tmpMILO_Receipt AS MILinkObject_Receipt
                                                  ON MILinkObject_Receipt.MovementItemId = tmpMI.MovementItemId

                        LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MovementItemId
                   GROUP BY tmpMI.OperDate
                          , tmpMI.DayCount
                          , tmpMI.FromId
                          , tmpMI.GoodsId
                          , COALESCE (MILinkObject_Receipt.ObjectId, 0)
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
              )

     , tmpMI_Send AS (-- ������������ �����������
                       SELECT tmpMI.OperDate     AS OperDate
                            , tmpMI.UnitId       AS UnitId
                            , tmpMI.GoodsId      AS GoodsId
                            , tmpMI.GoodsKindId  AS GoodsKindId
                            , SUM (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount
                       FROM (SELECT MIContainer.OperDate
                                  , MIContainer.WhereObjectId_Analyzer     AS UnitId
                                  , MIContainer.ObjectId_Analyzer          AS GoodsId
                                  , CASE -- !!!�������� �����������!!!
                                         WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- ����� ���������
                                              THEN 8338 -- �����.
                                         ELSE 0
                                    END                                    AS GoodsKindId
                                  , SUM (MIContainer.Amount)               AS Amount
                             FROM MovementItemContainer AS MIContainer
                                  INNER JOIN _tmpUnitFrom ON _tmpUnitFrom.UnitId = MIContainer.WhereObjectId_Analyzer
                             WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                               AND MIContainer.DescId     = zc_MIContainer_Count()
                               AND MIContainer.MovementDescId = zc_Movement_Send()
                               --AND MIContainer.WhereObjectId_Analyzer = inFromId
                             GROUP BY MIContainer.ObjectId_Analyzer, MIContainer.OperDate
                                    , MIContainer.WhereObjectId_Analyzer
                                    , CASE -- !!!�������� �����������!!!
                                           WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- ����� ���������
                                                THEN 8338 -- �����.
                                           ELSE 0
                                      END
                            ) AS tmpMI
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                        GROUP BY tmpMI.OperDate
                               , tmpMI.UnitId
                               , tmpMI.GoodsId
                               , tmpMI.GoodsKindId
                      )

      SELECT tmpData.OperDate
           , tmpData.InvNumber ::TVarChar
           , (tmpWeekDay.Number::TVarChar ||' '||tmpWeekDay.DayOfWeekName_Full)   ::TVarChar AS DayOfWeekName
           , (tmpWeekDay.Number)                                                  ::Integer  AS DayOfWeekNumber
           , zfCalc_MonthName (DATE_TRUNC ('Month', tmpData.OperDate)) ::TVarChar AS MonthName
           , Object_From.ObjectCode               AS FromCode
           , Object_From.ValueData                AS FromName
           , Object_To.ObjectCode                 AS ToCode
           , Object_To.ValueData                  AS ToName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData                 AS GoodsGroupName
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , Object_GoodsKind.Id                  AS GoodsKindId
           , Object_GoodsKind.ValueData           AS GoodsKindName


           , tmpData.Amount             :: TFloat AS Amount           -- ����� �� �����
           , tmpData.AmountSecond       :: TFloat AS AmountSecond     -- ������� �� �����
           , tmpMI_Send.Amount          :: TFloat AS AmountSend       -- ������ �� "�������"

           , CASE WHEN tmpData.AmountRemains + COALESCE (tmpMI_Send.Amount, 0) < tmpData.AmountPartner + tmpData.AmountPartnerPrior + tmpData.AmountPartnerSecond 
                      THEN tmpData.AmountPartner + tmpData.AmountPartnerPrior + tmpData.AmountPartnerSecond - tmpData.AmountRemains - COALESCE (tmpMI_Send.Amount, 0) 
                  ELSE 0
             END                        :: TFloat AS Amount_calc  -- ��������� �����

           , tmpData.AmountRemains      :: TFloat  AS AmountRemains       -- ���. �������.
           , tmpData.AmountPartner      :: TFloat  AS AmountPartner       -- ������ ������������ �� ������ �� ������������ (��� ������������ ��)
           , tmpData.AmountPartnerPrior :: TFloat  AS AmountPartnerPrior  -- ������ ������������ �� ������ �� ������������ (��� ������������ ��)
           , (tmpData.AmountPartner + tmpData.AmountPartnerPrior + tmpData.AmountPartnerSecond) :: TFloat AS AmountPartner_all -- ������ ������������ �� ������ �� ������������ (�����)
           , tmpData.AmountPartnerSecond :: TFloat AS AmountPartnerSecond -- ������ ....

           , CASE WHEN ABS (tmpData.AmountForecast) < 1 THEN tmpData.AmountForecast ELSE CAST (tmpData.AmountForecast AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast -- ������� �� ����. ������� �� ������������
           , CAST (CASE WHEN DayCount <> 0 THEN tmpData.AmountForecast / DayCount ELSE 0 END AS NUMERIC (16, 1))                      :: TFloat AS CountForecast  -- ���� 1� (�� ��.)
           , CAST (CASE WHEN (CASE WHEN DayCount <> 0 THEN tmpData.AmountForecast / DayCount ELSE 0 END) > 0
                             THEN tmpData.AmountRemains / CASE WHEN DayCount <> 0 THEN tmpData.AmountForecast / DayCount ELSE 0 END
                        WHEN tmpData.AmountRemains > 0
                             THEN 365
                        ELSE 0
                   END
             AS NUMERIC (16, 1))        :: TFloat AS DayCountForecast -- ���. � ���� (�� ��.)
  
      FROM tmpData
          LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.FromId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpData.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpData.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData.GoodsId
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                               ON ObjectLink_Goods_InfoMoney.ObjectId = tmpData.GoodsId
                              AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
          LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

          LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN tmpData.ReceiptId > 0 AND ObjectLink_Goods_GoodsGroup.ChildObjectId = 1942 -- ��-��������
                                                                        THEN tmpData.FromId
                                                                   WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����
                                                                        THEN 8455 -- ����� ������
                                                                   ELSE 8439 -- ������� ������� �����
                                                              END
          --����������� �� ������������� ����
          INNER JOIN _tmpUnitTo ON _tmpUnitTo.UnitId = Object_To.Id

          LEFT JOIN tmpMI_Send ON tmpMI_Send.GoodsId     = tmpData.GoodsId
                              AND tmpMI_Send.GoodsKindId = tmpData.GoodsKindId
                              AND tmpMI_Send.OperDate    = tmpData.OperDate
                              AND tmpMI_Send.UnitId      = tmpData.FromId

          LEFT JOIN zfCalc_DayOfWeekName (tmpData.OperDate) AS tmpWeekDay ON 1=1
         ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.03.20         *
*/

-- ����
-- SELECT * FROM gpReport_OrderInternalBasis_Olap (inStartDate:= '17.03.2020'::TDateTime, inEndDate:= '18.03.2020'::TDateTime, inGoodsGroupId:= 0, inGoodsId:= 0, inFromId:= 8447, inToId:= 8447 , inSession:= zfCalc_UserAdmin())