-- Function: gpSelect_MovementItem_WagesTechnicalRediscount()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WagesTechnicalRediscount (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WagesTechnicalRediscount(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id integer
             , UnitId integer, UnitCode integer, UnitName public.tvarchar
             , SummaTechnicalRediscount TFloat
             , SummWages TFloat
             , isIssuedBy Boolean, MIDateIssuedBy TDateTime
             , Comment TVarChar
             , isErased Boolean
             , Color_Calc Integer
             ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate   TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TechnicalRediscount());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT Movement.OperDate
     INTO vbStartDate
     FROM Movement 
     WHERE Movement.ID = inMovementId;

    -- Результат другой
    RETURN QUERY
       WITH tmpTechnicalRediscount AS (SELECT  MovementLinkObject_Unit.ObjectId                                       AS UnitId
                                             , Sum(MovementFloat_TotalDiffSumm.ValueData)                             AS TotalDiffSumm
                                             , SUM(CASE WHEN MovementFloat_SummaManual.ValueData IS NULL THEN 0 ELSE 1 END) AS TotalManual
                                         FROM Movement

                                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                              LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiffSumm
                                                                            ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                                                           AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()
                                              LEFT OUTER JOIN MovementFloat AS MovementFloat_SummaManual
                                                                            ON MovementFloat_SummaManual.MovementId = Movement.Id
                                                                           AND MovementFloat_SummaManual.DescId = zc_MovementFloat_SummaManual()

                                              LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                                                        ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                                                       AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()

                                              LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                                                        ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                                                       AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()

                                         WHERE Movement.OperDate BETWEEN date_trunc('month', vbStartDate) AND date_trunc('month', vbStartDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                                           AND Movement.DescId = zc_Movement_TechnicalRediscount()
                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                                           AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = False
                                           AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = False
                                         GROUP BY MovementLinkObject_Unit.ObjectId)
    
        SELECT MovementItem.Id                           AS Id
             , MovementItem.ObjectId                     AS UnitID
             , Object_Unit.ObjectCode                    AS UnitCode
             , Object_Unit.ValueData                     AS UnitName

             , tmpTechnicalRediscount.TotalDiffSumm::TFloat AS SummaTechnicalRediscount 
             , MIFloat_SummaTechnicalRediscount.ValueData   AS SummWages

             , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
             , MIDate_IssuedBy.ValueData                 AS DateIssuedBy
             , MIS_Comment.ValueData                     AS Comment

             , MovementItem.isErased                     AS isErased
             , CASE WHEN COALESCE(tmpTechnicalRediscount.TotalManual, 0) = 0
                  THEN zc_Color_White() ELSE zc_Color_Yelow() END AS Color_Calc
        FROM  MovementItem

              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
              
              LEFT JOIN tmpTechnicalRediscount ON tmpTechnicalRediscount.UnitId = MovementItem.ObjectId 

              LEFT JOIN MovementItemFloat AS MIFloat_SummaTechnicalRediscount
                                          ON MIFloat_SummaTechnicalRediscount.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaTechnicalRediscount.DescId = zc_MIFloat_SummaTechnicalRediscount()

              LEFT JOIN MovementItemBoolean AS MIBoolean_isIssuedBy
                                            ON MIBoolean_isIssuedBy.MovementItemId = MovementItem.Id
                                           AND MIBoolean_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

              LEFT JOIN MovementItemDate AS MIDate_IssuedBy
                                         ON MIDate_IssuedBy.MovementItemId = MovementItem.Id
                                        AND MIDate_IssuedBy.DescId = zc_MIDate_IssuedBy()

              LEFT JOIN MovementItemString AS MIS_Comment
                                           ON MIS_Comment.MovementItemId = MovementItem.Id
                                          AND MIS_Comment.DescId = zc_MIString_Comment()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Sign()
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_WagesTechnicalRediscount (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_WagesTechnicalRediscount (inMovementId := 17449644 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');

