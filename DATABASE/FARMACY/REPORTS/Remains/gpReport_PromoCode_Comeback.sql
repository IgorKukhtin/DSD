--- Function: gpReport_Loyalty_Comeback()


DROP FUNCTION IF EXISTS gpReport_PromoCode_Comeback (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PromoCode_Comeback(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE ("Код" Integer
             , "Подразделение" TVarChar
             , "Количество чеков" Integer
             , "Сумма скидки" TFloat
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
                              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                AND Movement.DescId = zc_Movement_Check()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                                AND Movement_PromoCode.DescId = zc_Movement_PromoCode()
                           )

       SELECT Object_Unit.ObjectCode                          AS UnitCode
            , Object_Unit.ValueData                           AS UnitName
            , count(*)::INTEGER                               AS CountCheck
            , SUM(Movement_Check.PromoCodeChangeSumma)::TFloat  AS PromoCodeChangeSumma
       FROM tmpMovement_Check AS Movement_Check

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

       WHERE Movement_Check.RetailId = vbObjectId
       GROUP BY Object_Unit.ObjectCode
              , Object_Unit.ValueData
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