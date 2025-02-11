DROP FUNCTION IF EXISTS gpReport_Promo_DetailError(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Promo_DetailError(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     MovementId           Integer   --ИД документа акции
    ,OperDate             TDateTime --Дата
    ,InvNumber            Integer   --№ документа акции       
    ,isOut                Boolean   -- отклонение по Факт продаже
    ,isReal               Boolean   -- отклонение по аналог. периоду 
    ,isOperDate           Boolean   --аналог. период после даты отгрузки
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH 
        tmpMovement AS (SELECT Movement.*
                        FROM Movement
                        WHERE Movement.DescId = zc_Movement_Promo()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.OperDate BETWEEN inStartDate AND inEndDate --'01.01.2025' AND '01.06.2025'
--AND Movement.Id = 30156300
                         )

      , tmpMI_Master AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementItem.DescId = zc_MI_Master()
                            AND MovementItem.isErased = FALSE
                         )


      , tmpMI_Detail AS (SELECT MovementItem.*
                         FROM MovementItem
                         WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementItem.DescId = zc_MI_Detail()
                            AND MovementItem.isErased = FALSE
                         )

      , tmpMIFloat_Master AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Master.Id FROM tmpMI_Master)
                                AND MovementItemFloat.DescId IN (zc_MIFloat_AmountReal()
                                                               , zc_MIFloat_AmountOut()
                                                                 )
                              )
                                               
      , tmpMIFloat_Detail AS (SELECT MovementItemFloat.*
                              FROM MovementItemFloat
                              WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                AND MovementItemFloat.DescId IN (zc_MIFloat_AmountReal()
                                                               )
                              )
                  
      , tmpDetail AS (SELECT MovementItem.MovementId
                           --, MovementItem.ParentId
                           , SUM (COALESCE (MovementItem.Amount,0))          AS AmountOut
                           , SUM (COALESCE (MIFloat_AmountReal.ValueData,0)) AS AmountReal
                      FROM tmpMI_Detail AS MovementItem
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                                       ON MIFloat_AmountReal.MovementItemId = MovementItem.Id 
                                                      AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
                      GROUP BY MovementItem.MovementId
                           -- , MovementItem.ParentId
                      )
       , tmpMaster AS (SELECT MovementItem.MovementId
                            --, MovementItem.Id
                            , SUM (COALESCE (MIFloat_AmountOut.ValueData,0))  AS AmountOut
                            , SUM (COALESCE (MIFloat_AmountReal.ValueData,0)) AS AmountReal
                       FROM tmpMI_Master AS MovementItem
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountReal
                                                        ON MIFloat_AmountReal.MovementItemId = MovementItem.Id 
                                                       AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
                            LEFT JOIN tmpMIFloat_Master AS MIFloat_AmountOut
                                                        ON MIFloat_AmountOut.MovementItemId = MovementItem.Id 
                                                       AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                       WHERE (COALESCE (MIFloat_AmountOut.ValueData,0)) <> 0
                          OR (COALESCE (MIFloat_AmountReal.ValueData,0)) <> 0
                       GROUP BY MovementItem.MovementId
                             -- , MovementItem.Id
                       )           
      , tmpDiff AS (SELECT DISTINCT tmpMaster.MovementId
                         , CASE WHEN COALESCE (tmpMaster.AmountReal,0) <> COALESCE (tmpDetail.AmountReal,0) THEN TRUE ELSE FALSE END AS isReal
                         , CASE WHEN COALESCE (tmpMaster.AmountOut,0) <> COALESCE (tmpDetail.AmountOut,0) THEN TRUE ELSE FALSE END   AS isOut 
                    FROM tmpMaster
                        LEFT JOIN tmpDetail ON tmpDetail.MovementId = tmpMaster.MovementId
                                           --AND tmpDetail.ParentId = tmpMaster.Id 
                    --GROUP BY tmpMI_Master.MovementId
                    WHERE COALESCE (tmpMaster.AmountReal,0) <> COALESCE (tmpDetail.AmountReal,0)
                       OR COALESCE (tmpMaster.AmountOut,0) <> COALESCE (tmpDetail.AmountOut,0)                      
                    )
                  

      SELECT tmpMovement.Id        ::Integer
           , tmpMovement.OperDate  ::TDateTime
           , tmpMovement.InvNumber ::Integer
           , tmpDiff.isOut         ::Boolean
           , tmpDiff.isReal        ::Boolean
           , CASE WHEN Movement_Promo.StartSale <= Movement_Promo.OperDateStart THEN TRUE ELSE FALSE END ::Boolean AS isOperDate
      FROM tmpMovement
           INNER JOIN tmpDiff ON tmpDiff.MovementId = tmpMovement.Id
           LEFT JOIN Movement_Promo_View AS Movement_Promo ON Movement_Promo.Id = tmpMovement.Id
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.25         *
*/

-- тест
-- SELECT * FROM gpReport_Promo_DetailError (inStartDate:= ('01.04.2024')::TDateTime , inEndDate:= ('01.04.2024')::TDateTime , inSession := '5'::TVarchar) 