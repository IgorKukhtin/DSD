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
             , isIssuedBy Boolean, MIDateIssuedBy TDateTime
             , Comment TVarChar
             , isErased Boolean
             , Color_Calc Integer
             ) 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TechnicalRediscount());
     vbUserId:= lpGetUserBySession (inSession);

    -- Результат другой
    RETURN QUERY
        SELECT MovementItem.Id                           AS Id
             , MovementItem.ObjectId                     AS UnitID
             , Object_Unit.ObjectCode                    AS UnitCode
             , Object_Unit.ValueData                     AS UnitName

             , MIFloat_SummaTechnicalRediscount.ValueData AS SummaTechnicalRediscount

             , COALESCE(MIBoolean_isIssuedBy.ValueData, FALSE)::Boolean AS isIssuedBy
             , MIDate_IssuedBy.ValueData                 AS DateIssuedBy
             , MIS_Comment.ValueData                     AS Comment

             , MovementItem.isErased                     AS isErased
             , zc_Color_Black()                          AS Color_Calc
        FROM  MovementItem


              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId

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
--
SELECT * FROM gpSelect_MovementItem_WagesTechnicalRediscount (inMovementId := 15414488 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');