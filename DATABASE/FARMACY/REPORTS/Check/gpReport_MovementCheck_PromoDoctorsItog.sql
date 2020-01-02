-- Function: gpReport_MovementCheck_PromoDoctorsItog()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_PromoDoctorsItog (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_PromoDoctorsItog(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (Doctors TVarChar

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
                              , MIString_Bayer.ValueData      ::TVarChar AS Doctors
                         FROM Movement

                               -- ���� �� ��������� ����� ���
                              INNER JOIN MovementFloat AS MovementFloat_MovementItemId
                                                       ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                                      AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                              INNER JOIN MovementItem AS MI_PromoCode
                                                      ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                                     AND MI_PromoCode.isErased = FALSE
                                                     AND MI_PromoCode.MovementId = 16904771
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
         tmpItog AS (SELECT Movement_Check.Doctors                     AS Doctors
                          , Movement_Check.BayerID
                          , SUM(MovementItem.Amount) :: TFloat                            AS GoodsCount
                          , SUM(MovementItem.AmountSumm) :: TFloat                        AS SummSale
                          , SUM(MovementItem.SummChangePercent) :: TFloat                 AS SummChangePercent

                       FROM tmpMovement AS Movement_Check

                            LEFT JOIN MovementItem_Check_View AS MovementItem
                                                              ON MovementItem.MovementId = Movement_Check.Id
                       GROUP BY Movement_Check.Doctors, Movement_Check.BayerID
                       )
                         
         SELECT
             tmpItog.Doctors                             AS Doctors
             
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
select * from gpReport_MovementCheck_PromoDoctorsItog(inStartDate := ('01.12.2019')::TDateTime , inEndDate := ('31.12.2019')::TDateTime ,  inSession := '3');