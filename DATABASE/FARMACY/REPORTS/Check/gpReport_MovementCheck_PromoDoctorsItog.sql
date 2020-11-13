-- Function: gpReport_MovementCheck_PromoDoctorsItog()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_PromoDoctorsItog (TDateTime, TDateTime, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_PromoDoctorsItog(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inPromoCodeID        Integer   , --
    IN inChangePercent      TFloat    , --
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Doctors TVarChar
             , GUID TVarChar

             , CheckCount Integer
             , GoodsCount TFloat
             , SummSale TFloat
             , SummChangePercent TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
         WITH
         tmpMovement AS (SELECT Movement.*
                              , MI_PromoCode.Id                          AS BayerID 
                              , MIString_Bayer.ValueData      ::TVarChar AS Doctors
                              , MIString_GUID.ValueData       ::TVarChar AS GUID
                         FROM Movement

                               -- инфа из документа промо код
                              INNER JOIN MovementFloat AS MovementFloat_MovementItemId
                                                       ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                                      AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                              INNER JOIN MovementItem AS MI_PromoCode
                                                      ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                                     AND MI_PromoCode.isErased = FALSE
                                                     AND MI_PromoCode.MovementId = inPromoCodeID
                              LEFT JOIN MovementItemString AS MIString_Bayer
                                                           ON MIString_Bayer.MovementItemId = MI_PromoCode.Id
                                                          AND MIString_Bayer.DescId = zc_MIString_Bayer()
                              LEFT JOIN MovementItemString AS MIString_GUID
                                                           ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                                          AND MIString_GUID.DescId = zc_MIString_GUID()

                         WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                           AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Check()
                           AND  Movement.StatusId = zc_Enum_Status_Complete()),
         tmpMovementCount AS (SELECT Movement.BayerID                            AS BayerID
                                   , COUNT(*)::Integer                           AS CheckCount  
                         FROM tmpMovement AS Movement
                         GROUP BY Movement.BayerID),
         tmpItog AS (SELECT Movement_Check.Doctors                     AS Doctors
                          , Movement_Check.GUID                        AS GUID
                          , Movement_Check.BayerID
                          , SUM(MovementItem.Amount) :: TFloat                            AS GoodsCount
                          , SUM(MovementItem.AmountSumm) :: TFloat                        AS SummSale
                          , SUM(Round(MovementItem.AmountSumm * inChangePercent / 100, 2)) :: TFloat  AS SummChangePercent

                       FROM tmpMovement AS Movement_Check

                            LEFT JOIN MovementItem_Check_View AS MovementItem
                                                              ON MovementItem.MovementId = Movement_Check.Id
                       GROUP BY Movement_Check.Doctors, Movement_Check.GUID, Movement_Check.BayerID
                       )
                         
         SELECT
             tmpItog.Doctors                             AS Doctors
           , tmpItog.GUID                                AS GUID 
             
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.12.19                                                       *
*/

-- тест
-- select * from gpReport_MovementCheck_PromoDoctorsItog(inStartDate := ('01.12.2019')::TDateTime , inEndDate := ('31.12.2019')::TDateTime ,  inSession := '3');
