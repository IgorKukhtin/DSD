-- Function: gpReport_MovementCheck_PromoEntrancesItog()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_PromoEntrancesItog (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_PromoEntrancesItog(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (Entrances TVarChar

             , CheckCount Integer
             , GoodsCount TFloat
             , SummSale TFloat
             , SummChangePercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
         WITH
         tmpMovement AS (SELECT Movement.*
                              , MI_PromoCode.Id                          AS BayerID 
                              , MIString_Bayer.ValueData      ::TVarChar AS Entrances
                         FROM Movement

                               -- ���� �� ��������� ����� ���
                              INNER JOIN MovementFloat AS MovementFloat_MovementItemId
                                                       ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                                      AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                              INNER JOIN MovementItem AS MI_PromoCode
                                                      ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                                     AND MI_PromoCode.isErased = FALSE
                                                     AND MI_PromoCode.MovementId = 16931134
                              LEFT JOIN MovementItemString AS MIString_Bayer
                                                           ON MIString_Bayer.MovementItemId = MI_PromoCode.Id
                                                          AND MIString_Bayer.DescId = zc_MIString_Bayer()

                         WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                           AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Check()
                           AND  Movement.StatusId = zc_Enum_Status_Complete()),
         tmpMovementCount AS (SELECT Movement.BayerID                            AS BayerID
                                   , COUNT(*)::Integer                           AS CheckCount  
                         FROM tmpMovement AS Movement
                         GROUP BY Movement.BayerID),
         tmpItog AS (SELECT Movement_Check.Entrances                     AS Entrances
                          , Movement_Check.BayerID
                          , SUM(MovementItem.Amount) :: TFloat                            AS GoodsCount
                          , SUM(MovementItem.AmountSumm) :: TFloat                        AS SummSale
                          , SUM(MovementItem.SummChangePercent) :: TFloat                 AS SummChangePercent

                       FROM tmpMovement AS Movement_Check

                            LEFT JOIN MovementItem_Check_View AS MovementItem
                                                              ON MovementItem.MovementId = Movement_Check.Id
                       GROUP BY Movement_Check.Entrances, Movement_Check.BayerID
                       )
                         
         SELECT
             tmpItog.Entrances                             AS Entrances
             
           , tmpMovementCount.CheckCount  
           , tmpItog.GoodsCount
           , tmpItog.SummSale
           , tmpItog.SummChangePercent

        FROM tmpItog
             LEFT JOIN tmpMovementCount ON tmpMovementCount.BayerID = tmpItog.BayerID
             ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.12.19                                                       *
*/

-- ����
-- 
select * from gpReport_MovementCheck_PromoEntrancesItog(inStartDate := ('01.12.2019')::TDateTime , inEndDate := ('31.12.2019')::TDateTime ,  inSession := '3');