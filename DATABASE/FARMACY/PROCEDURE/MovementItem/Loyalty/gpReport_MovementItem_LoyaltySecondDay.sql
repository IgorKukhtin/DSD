--- Function: gpReport_MovementItem_LoyaltySecondDay()


DROP FUNCTION IF EXISTS gpReport_MovementItem_LoyaltySecondDay (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementItem_LoyaltySecondDay(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate      TDateTime
             , Amount        TFloat
             , Accrued       TFloat
             , CountAccrued  TFloat
             , SummChange    TFloat
             , CountChange   TFloat
             , PercentUsed   TFloat
             , SummSale    TFloat
             , CountSale   TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbStartPromo TDateTime;
    DECLARE vbEndPromo TDateTime;
    DECLARE vbChangePercent TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT MovementDate_StartPromo.ValueData,
           MovementDate_EndPromo.ValueData,
           COALESCE(MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent
    INTO vbStartPromo, vbEndPromo, vbChangePercent
    FROM Movement
         LEFT JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement.Id
                               AND MovementDate_StartPromo.DescID = zc_MovementDate_StartPromo()
         LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId = Movement.Id
                               AND MovementDate_EndPromo.DescID = zc_MovementDate_EndPromo()

         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
    WHERE Movement.ID = inMovementId;

    RETURN QUERY
        WITH
        tmpMIF AS (SELECT * FROM MovementFloat AS MovementFloat_MovementItemId
                   WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                  )
      , tmpMI AS (SELECT MI_Sign.Id
                       , MI_Sign.Amount
                       , MI_Sign.ObjectId
                       , MI_Sign.ParentId                                      AS MovementId
                       , MovementFloat_MovementItemId.MovementId               AS MovementSaleId

                  FROM MovementItem AS MI_Sign
                       LEFT JOIN tmpMIF AS MovementFloat_MovementItemId
                                        ON MovementFloat_MovementItemId.ValueData = MI_Sign.Id
                  WHERE MI_Sign.MovementId = inMovementId
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND MI_Sign.isErased = FALSE
                  )
      , tmpCheck AS (SELECT tmpMI.Id                   AS ID
                          , CASE WHEN Movement.ID = tmpMI.MovementId THEN True ELSE FALSE END AS isIssue
                          , Movement.OperDate          AS OperDate
                          , Movement.Invnumber         AS Invnumber
                          , CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) > tmpMI.Amount THEN tmpMI.Amount
                            ELSE COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) END AS TotalSummChangePercent
                     FROM tmpMI

                          LEFT JOIN Movement ON Movement.ID IN (tmpMI.MovementId, tmpMI.MovementSaleId)

                          LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                  ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.ID
                                                 AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
                     )

      , tmpCheckSale AS (SELECT DATE_TRUNC ('DAY', tmpCheck.OperDate) AS OperDate
                              , SUM(tmpCheck.TotalSummChangePercent)  AS SummSale
                              , COUNT(*)                              AS CountSale
                         FROM tmpCheck
                         WHERE tmpCheck.isIssue = False
                         GROUP BY DATE_TRUNC ('DAY', tmpCheck.OperDate)
                         )
      , tmpAmount AS (SELECT DATE_TRUNC ('DAY', Movement.OperDate)                                    AS OperDate
                           , ROUND(SUM(MovementFloat_TotalSumm.ValueData) * vbChangePercent / 100, 2) AS Summ
                      FROM Movement

                           INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                           INNER JOIN MovementItem AS MI_Loyalty
                                                   ON MI_Loyalty.MovementId = inMovementId
                                                  AND MI_Loyalty.DescId = zc_MI_Child()
                                                  AND MI_Loyalty.isErased = FALSE
                                                  AND MI_Loyalty.Amount = 1
                                                  AND MI_Loyalty.ObjectId = MovementLinkObject_Unit.ObjectId

                       WHERE Movement.DescId = zc_Movement_Check()
                         AND Movement.StatusId = zc_Enum_Status_Complete()
                         AND Movement.OperDate >= vbStartPromo - INTERVAL '1 DAY'
                         AND Movement.OperDate < vbEndPromo
                       GROUP BY DATE_TRUNC ('DAY', Movement.OperDate))
      , tmpSign  AS (SELECT
                            MIDate_OperDate.ValueData                                               AS OperDate
                          , Sum(MI_Sign.Amount)                                                     AS Accrued
                          , Count(*)                                                                AS CountAccrued
                          , Sum(tmpCheckSale.TotalSummChangePercent)                                AS SummChange
                          , Sum(CASE WHEN COALESCE(tmpCheckSale.TotalSummChangePercent, 0) = 0 THEN 0 ELSE 1 END)  AS CountChange

                     FROM tmpMI AS MI_Sign

                         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                                    ON MIDate_OperDate.MovementItemId = MI_Sign.Id
                                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

                         LEFT JOIN tmpCheck ON tmpCheck.Id = MI_Sign.Id
                                           AND tmpCheck.isIssue = True

                         LEFT JOIN tmpCheck AS tmpCheckSale
                                            ON tmpCheckSale.Id = MI_Sign.Id
                                           AND tmpCheckSale.isIssue = False
                     GROUP BY MIDate_OperDate.ValueData
                     )


    SELECT COALESCE(tmpSign.OperDate, tmpCheckSale.OperDate)::TDateTime          AS OperDate
         , tmpAmount.Summ::TFloat                                                AS Amount
         , tmpSign.Accrued::TFloat                                               AS Accrued
         , tmpSign.CountAccrued::TFloat                                          AS CountAccrued
         , tmpSign.SummChange::TFloat                                            AS SummChange
         , tmpSign.CountChange::TFloat                                           AS CountChange
         , CASE WHEN tmpSign.CountAccrued = 0 THEN 0
           ELSE (1.0*tmpSign.CountChange/tmpSign.CountAccrued*100) END::TFloat   AS PercentUsed
         , tmpCheckSale.SummSale::TFloat                                         AS SummSale
         , tmpCheckSale.CountSale::TFloat                                        AS CountSale

    FROM tmpSign
         FULL JOIN tmpCheckSale ON tmpCheckSale.OperDate = tmpSign.OperDate
         LEFT JOIN tmpAmount ON tmpAmount.OperDate = tmpSign.OperDate - INTERVAL '1 DAY'
    ORDER BY tmpSign.OperDate
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.11.19                                                       *
*/

-- select * from gpReport_MovementItem_LoyaltySecondDay(inMovementId := 16406918,  inSession := '3'::TVarChar);