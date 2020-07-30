--- Function: gpReport_Loyalty_Comeback()


DROP FUNCTION IF EXISTS gpReport_Loyalty_Comeback (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Loyalty_Comeback(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE ("Код" Integer
             , "Подразделение" TVarChar
             , "Выдано промокодов" Integer
             , "Сумма промокодов" TFloat
             , "Сумма погашено" TFloat
             , "Процент камбэка" TFloat
             , "Количество чеков за период" Integer
             , "Сумма скидки за период" TFloat
              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    RETURN QUERY
        WITH
        tmpMovement_Check AS (SELECT Movement.Id
                                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                                   , ObjectLink_Juridical_Retail.ChildObjectId           AS RetailID
                                   , CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) < MI_PromoCode.Amount THEN
                                             COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE MI_PromoCode.Amount END::TFloat AS LoyaltyChangeSumma
                                   , Movement_PromoCode.ID                               AS PromoCodeID
                              FROM Movement

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                   LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                        ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_Unit.ObjectId
                                                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                   LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                        ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                       AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

                                   -- инфа из документа промо код
                                   LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                                           ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                                          AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
                                   LEFT JOIN MovementItem AS MI_PromoCode
                                                          ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                                         AND MI_PromoCode.isErased = FALSE
                                   LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId

                                   LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                           ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                                          AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
                              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                AND Movement.DescId = zc_Movement_Check()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND Movement_PromoCode.DescId = zc_Movement_Loyalty()
                                AND Movement_PromoCode.InvNumber in ('6')
                           ),
        tmpResult AS ( SELECT Movement_Check.UnitId                           AS UnitId
                            , count(*)::INTEGER                               AS CountCheck
                            , SUM(Movement_Check.LoyaltyChangeSumma)::TFloat  AS LoyaltyChangeSumma
                       FROM tmpMovement_Check AS Movement_Check

                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

                       WHERE Movement_Check.RetailId = vbObjectId
                       GROUP BY  Movement_Check.UnitId),
        tmpMI AS (SELECT MI_Sign.Id
                       , MI_Sign.Amount
                       , MI_Sign.ObjectId                                      AS UnitID
                       , CASE WHEN MI_Sign.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                       , MI_Sign.IsErased

                  FROM MovementItem AS MI_Sign

                       LEFT JOIN MovementItemDate AS MIDate_Insert
                                                  ON MIDate_Insert.MovementItemId = MI_Sign.Id
                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()

                  WHERE MI_Sign.MovementId in (SELECT tmpMovement_Check.PromoCodeID FROM tmpMovement_Check)
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND MIDate_Insert.ValueData < inEndDate + INTERVAL '1 DAY'
                  ),
        tmpMIIssued AS (SELECT MI_Sign.UnitID
                       , SUM(MI_Sign.Amount)::TFloat                           AS Amount
                       , count(*)::Integer                                     AS CountCheck
                  FROM tmpMI AS MI_Sign

                       LEFT JOIN MovementItemDate AS MIDate_Insert
                                                  ON MIDate_Insert.MovementItemId = MI_Sign.Id
                                                 AND MIDate_Insert.DescId = zc_MIDate_Insert()

                  GROUP BY MI_Sign.UnitID
                  ),

         -- для скорости сначала вібираем все zc_MovementFloat_MovementItemId
        tmpMovementFloat AS (SELECT MovementFloat_MovementItemId.MovementId
                                  , MovementFloat_MovementItemId.ValueData :: Integer As MovementItemId
                             FROM MovementFloat AS MovementFloat_MovementItemId
                             WHERE MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                            ),
        -- Документ чек, по идее должен быть 1 , но чтоб не задвоилось берем макс и считаем сколько чеков
        tmpCheck_Mov AS (SELECT tmpMI.UnitID
                              , COUNT (*)::Integer                                                                                       AS Count_Check
                              , SUM(CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) < tmpMI.Amount THEN
                                              COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE tmpMI.Amount END)::TFloat AS Summa_Check
                         FROM tmpMI
                              INNER JOIN tmpMovementFloat AS MovementFloat_MovementItemId
                                                          ON MovementFloat_MovementItemId.MovementItemId = tmpMI.Id

                              INNER JOIN Movement ON Movement.ID = MovementFloat_MovementItemId.MovementId

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                      ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                                     AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
                         WHERE Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                         GROUP BY tmpMI.UnitID
                         )

       SELECT Object_Unit.ObjectCode                          AS UnitCode
            , Object_Unit.ValueData                           AS UnitName
            , MIIssued.CountCheck
            , MIIssued.Amount
            , Check_Mov.Summa_Check
            , CASE WHEN MIIssued.Amount <> 0 THEN Round(Check_Mov.Summa_Check / MIIssued.Amount * 100, 2) END::TFloat
            , Movement_Check.CountCheck                       AS CountCheck
            , Movement_Check.LoyaltyChangeSumma               AS LoyaltyChangeSumma
       FROM tmpResult AS Movement_Check

            FULL JOIN tmpMIIssued AS MIIssued
                                  ON MIIssued.UnitId = Movement_Check.UnitId

            LEFT JOIN tmpCheck_Mov AS Check_Mov
                                   ON Check_Mov.UnitId = Movement_Check.UnitId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE (MIIssued.UnitId, Movement_Check.UnitId)

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.11.19                                                       *
*/

-- select * from gpReport_Loyalty_Comeback(:inStartDate, :inEndDate, '3');
--
 select * from gpReport_Loyalty_Comeback(inStartDate := ('01.07.2020')::TDateTime, inEndDate := ('26.07.2020')::TDateTime, inSession := '3'::TVarChar);