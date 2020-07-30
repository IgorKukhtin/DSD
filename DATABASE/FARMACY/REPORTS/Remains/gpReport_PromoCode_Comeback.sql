--- Function: gpReport_Loyalty_Comeback()


DROP FUNCTION IF EXISTS gpReport_PromoCode_Comeback (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PromoCode_Comeback(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE ("Код" Integer
             , "Подразделение" TVarChar
             , "Кол-во чеков Ирина Дирочьян" Integer
             , "Средний чек Ирина Дирочьян" TFloat
             , "Сумма скидки Ирина Дирочьян" TFloat
             , "Кол-во чеков Доктор диагностик" Integer
             , "Средний чек Доктор диагностик" TFloat
             , "Сумма скидки Доктор диагностик" TFloat
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
                                   , Movement_PromoCode.InvNumber                        AS InvNumber
                                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                                   , ObjectLink_Juridical_Retail.ChildObjectId           AS RetailID
                                   , MovementFloat_TotalSumm.ValueData                   AS TotalSumm
                                   , MovementFloat_TotalSummChangePercent.ValueData      AS PromoCodeChangeSumma
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

                                   LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                           ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                          AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                AND Movement.DescId = zc_Movement_Check()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND Movement_PromoCode.DescId = zc_Movement_PromoCode()
                                AND Movement_PromoCode.InvNumber in ('34', '35')
                           ),
        tmpMovement_CheckGroup AS (SELECT Movement_Check.UnitId                                       AS UnitId
                                        , Movement_Check.InvNumber                                    AS InvNumber
                                        , count(*)::INTEGER                                           AS CountCheck
                                        , Round(SUM(Movement_Check.TotalSumm) / count(*), 2)::TFloat  AS AverageCheck
                                        , SUM(Movement_Check.PromoCodeChangeSumma)::TFloat            AS PromoCodeChangeSumma
                                   FROM tmpMovement_Check AS Movement_Check

                                   WHERE Movement_Check.RetailId = vbObjectId
                                   GROUP BY Movement_Check.UnitId
                                          , Movement_Check.InvNumber
                                   )


       SELECT Object_Unit.ObjectCode                          AS UnitCode
            , Object_Unit.ValueData                           AS UnitName
            , Movement_Check34.CountCheck                     AS CountCheck
            , Movement_Check34.AverageCheck                   AS AverageCheck
            , Movement_Check34.PromoCodeChangeSumma           AS PromoCodeChangeSumma
            , Movement_Check35.CountCheck                     AS CountCheck
            , Movement_Check35.AverageCheck                   AS AverageCheck
            , Movement_Check35.PromoCodeChangeSumma           AS PromoCodeChangeSumma
       FROM (SELECT DISTINCT tmpMovement_CheckGroup.UnitId FROM tmpMovement_CheckGroup) AS Movement_Check

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

            LEFT JOIN tmpMovement_CheckGroup AS Movement_Check34
                                             ON Movement_Check34.UnitId = Movement_Check.UnitId
                                            AND Movement_Check34.InvNumber = '34'

            LEFT JOIN tmpMovement_CheckGroup AS Movement_Check35
                                             ON Movement_Check35.UnitId = Movement_Check.UnitId
                                            AND Movement_Check35.InvNumber = '35'
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.11.19                                                       *
*/

-- select * from gpReport_PromoCode_Comeback(:inStartDate, :inEndDate, '3');
--
select * from gpReport_PromoCode_Comeback(inStartDate := ('01.07.2020')::TDateTime, inEndDate := ('26.07.2020')::TDateTime, inSession := '3'::TVarChar);