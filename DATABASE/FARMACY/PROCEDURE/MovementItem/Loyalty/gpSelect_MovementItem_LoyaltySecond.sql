--- Function: gpSelect_MovementItem_LoyaltySecond()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_LoyaltySecond (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LoyaltySecond(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , OperDate   TDateTime
             , Amount     TFloat
             , Accrued    TFloat
             , SummChange TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

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

      , tmpSign  AS (SELECT
                            CASE WHEN date_part('DAY', MIDate_OperDate.ValueData )::Integer = 1
                            THEN DATE_TRUNC ('MONTH', MIDate_OperDate.ValueData - INTERVAL '2 DAY')
                            ELSE DATE_TRUNC ('MONTH', MIDate_OperDate.ValueData) END                 AS OperDate
                          , Sum(MI_Sign.Amount)                                                     AS Amount
                          , Sum(tmpCheckSale.TotalSummChangePercent)                                AS SummChange

                     FROM tmpMI AS MI_Sign

                         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                                    ON MIDate_OperDate.MovementItemId = MI_Sign.Id
                                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

                         LEFT JOIN tmpCheck ON tmpCheck.Id = MI_Sign.Id
                                           AND tmpCheck.isIssue = True

                         LEFT JOIN tmpCheck AS tmpCheckSale
                                            ON tmpCheckSale.Id = MI_Sign.Id
                                           AND tmpCheckSale.isIssue = False
                     GROUP BY CASE WHEN date_part('DAY', MIDate_OperDate.ValueData )::Integer = 1
                              THEN DATE_TRUNC ('MONTH', MIDate_OperDate.ValueData - INTERVAL '2 DAY')
                              ELSE DATE_TRUNC ('MONTH', MIDate_OperDate.ValueData) END
                     )



    SELECT MI_Loyalty.Id
         , MIDate_OperDate.ValueData                                AS OperDate
         , MI_Loyalty.Amount
         , tmpSign.Amount::TFloat                                   AS Accrued
         , tmpSign.SummChange::TFloat                               AS SummChange
    FROM MovementItem AS MI_Loyalty

       LEFT JOIN MovementItemDate AS MIDate_OperDate
                                  ON MIDate_OperDate.MovementItemId =  MI_Loyalty.Id
                                  AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

       LEFT JOIN tmpSign ON tmpSign.OperDate = MIDate_OperDate.ValueData

    WHERE MI_Loyalty.MovementId = inMovementId
      AND MI_Loyalty.DescId = zc_MI_Second()
    ORDER BY MIDate_OperDate.ValueData DESC
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.11.19                                                       *
*/

-- select * from gpSelect_MovementItem_LoyaltySecond(inMovementId := 16406918,  inSession := '3'::TVarChar);