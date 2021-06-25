-- Function: gpSelect_MovementItem_WagesMoneyBoxSun()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WagesMoneyBoxSun (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WagesMoneyBoxSun(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , AccrualPeriod TVarChar
             , SummaMoneyBoxMonth TFloat, SummaMoneyBox TFloat, SummaMoneyBoxUsed TFloat, SummaMoneyBoxQuite TFloat
             , isIssuedBy Boolean, MIDateIssuedBy TDateTime
             , Comment TVarChar
             , isErased Boolean
             , Color_Calc Integer
              )
AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Sale());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT Movement.OperDate
    INTO vbOperDate
    FROM Movement
    WHERE Movement.Id = inMovementId;

    -- Результат другой
    RETURN QUERY
        SELECT MovementItem.Id                       AS Id
             , MovementItem.ObjectId                 AS UnitID
             , Object_Unit.ObjectCode                AS UnitCode
             , Object_Unit.ValueData                 AS UnitName
             
             , CASE WHEN Movement.OperDate = '01.03.2020' THEN 'До Апреля 2020 г.'
                    WHEN Movement.OperDate = '01.04.2020' THEN 'Апреля и Март  2020 г.'   
                    ELSE 'За '||zfCalc_MonthName(Movement.OperDate)||' '||to_char(Movement.OperDate, 'YYYY')||' г.' END::TVarChar  AS AccrualPeriod

             , MIFloat_SummaMoneyBoxMonth.ValueData  AS SummaMoneyBoxMonth
             , MIFloat_SummaMoneyBox.ValueData       AS SummaMoneyBox
             , MIFloat_SummaMoneyBoxUsed.ValueData   AS SummaMoneyBoxUsed
             , CASE WHEN COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) +
                         COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) -
                         COALESCE(MIFloat_SummaMoneyBoxUsed.ValueData, 0) > 0 
                    THEN COALESCE(MIFloat_SummaMoneyBox.ValueData, 0) +
                         COALESCE(MIFloat_SummaMoneyBoxMonth.ValueData, 0) -
                         COALESCE(MIFloat_SummaMoneyBoxUsed.ValueData, 0) END::TFloat AS SummaMoneyBoxQuite

             , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
             , MIDate_IssuedBy.ValueData             AS DateIssuedBy
             , MIS_Comment.ValueData                 AS Comment

             , MovementItem.isErased                 AS isErased
             , zc_Color_Black()                      AS Color_Calc
        FROM  Movement


              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                     AND MovementItem.DescId = zc_MI_Sign()
                                     AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)

              INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId


              LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBoxMonth
                                          ON MIFloat_SummaMoneyBoxMonth.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaMoneyBoxMonth.DescId = zc_MIFloat_SummaMoneyBoxMonth()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBox
                                          ON MIFloat_SummaMoneyBox.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaMoneyBox.DescId = zc_MIFloat_SummaMoneyBox()

              LEFT JOIN MovementItemFloat AS MIFloat_SummaMoneyBoxUsed
                                          ON MIFloat_SummaMoneyBoxUsed.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaMoneyBoxUsed.DescId = zc_MIFloat_SummaMoneyBoxUsed()

              LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                            ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                           AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

              LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                         ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                        AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

              LEFT JOIN MovementItemString AS MIS_Comment
                                           ON MIS_Comment.MovementItemId = MovementItem.Id
                                          AND MIS_Comment.DescId = zc_MIString_Comment()

        WHERE Movement.OperDate >= '01.03.2020'
          AND Movement.OperDate <= vbOperDate
          AND Movement.DescId = zc_Movement_Wages()
        ORDER BY Object_Unit.ValueData, Movement.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.03.20                                                        *
*/
-- select * from gpSelect_MovementItem_WagesMoneyBoxSun(inMovementId := 17449644 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');