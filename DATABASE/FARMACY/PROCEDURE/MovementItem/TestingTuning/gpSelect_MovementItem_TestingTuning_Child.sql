-- Function: gpSelect_MovementItem_TestingTuning_Child()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TestingTuning_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TestingTuning_Child(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , Orders Integer, Replies Integer, CorrectAnswer Integer, isMandatoryQuestion Boolean, isStorekeeper Boolean
             , Question TBLOB
             , RandomID Integer, RandomStorekeeperID Integer
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
   vbUserId:= lpGetUserBySession (inSession);
         
   -- Результат
   RETURN QUERY
    WITH
    tmpReplies AS (SELECT MovementItem.ParentId         AS Id
                        , count(*)                      AS Replies
                        , SUM(MovementItem.Amount)      AS CorrectAnswer
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId = zc_MI_Second()
                     AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                   GROUP BY MovementItem.ParentId 
                   )


        -- результат
        SELECT MovementItem.Id                                     AS Id
             , MovementItem.ParentId                               AS ParentId
             , ROW_NUMBER()OVER(PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id)::Integer as Orders
             , tmpReplies.Replies::Integer                         AS Replies 
             , tmpReplies.CorrectAnswer::Integer                   AS CorrectAnswer 
             , COALESCE (MIBoolean_MandatoryQuestion.ValueData, FALSE) AS isMandatoryQuestion
             , COALESCE (MIBoolean_Storekeeper.ValueData, FALSE)   AS isStorekeeper
             , MIBLOB_Question.ValueData                           AS Question
             , ROW_NUMBER()OVER(PARTITION BY MovementItem.ParentId ORDER BY COALESCE (MIBoolean_MandatoryQuestion.ValueData, FALSE) DESC, random())::Integer AS RandomID
             , ROW_NUMBER()OVER(PARTITION BY MovementItem.ParentId ORDER BY random())::Integer AS RandomStorekeeperID
             , COALESCE(MovementItem.IsErased, FALSE)              AS isErased
        FROM MovementItem 
            
            LEFT JOIN tmpReplies ON tmpReplies.Id = MovementItem.Id
                
            -- Вопрос
            LEFT JOIN MovementItemBLOB AS MIBLOB_Question
                                       ON MIBLOB_Question.MovementItemId = MovementItem.Id
                                      AND MIBLOB_Question.DescId = zc_MIBLOB_Question()

            LEFT JOIN MovementItemBoolean AS MIBoolean_MandatoryQuestion
                                          ON MIBoolean_MandatoryQuestion.MovementItemId = MovementItem.Id
                                         AND MIBoolean_MandatoryQuestion.DescId = zc_MIBoolean_MandatoryQuestion()

            LEFT JOIN MovementItemBoolean AS MIBoolean_Storekeeper
                                          ON MIBoolean_Storekeeper.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Storekeeper.DescId = zc_MIBoolean_Storekeeper()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId = zc_MI_Child()
          AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
        ORDER BY MovementItem.ParentId, MovementItem.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TestingTuning_Child (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
--
 select * from gpSelect_MovementItem_TestingTuning_Child(inMovementId := 23977600 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');