-- Function: gpSelect_MovementItem_TestingTuning_Master()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_TestingTuning_Master (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_TestingTuning_Master(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, TopicsTestingTuningId Integer, TopicsTestingTuningCode Integer, TopicsTestingTuningName TVarChar
             , Question Integer, TestQuestions Integer, MandatoryQuestion Integer
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Loss());
    vbUserId:= lpGetUserBySession (inSession);
         
    IF inShowAll THEN
    -- Результат
        RETURN QUERY
        WITH 
        tmpTopicsTestingTuning AS (SELECT Object_TopicsTestingTuning.Id         AS Id
                                        , Object_TopicsTestingTuning.ObjectCode AS Code
                                        , Object_TopicsTestingTuning.ValueData  AS Name
                                        , Object_TopicsTestingTuning.isErased   AS isErased
                                   FROM Object AS Object_TopicsTestingTuning
                                   WHERE Object_TopicsTestingTuning.DescId = zc_Object_TopicsTestingTuning()
                                   ),
        tmpQuestions AS (SELECT MovementItem.ParentId         AS Id
                              , count(*)                      AS Questions
                              , SUM(CASE WHEN COALESCE (MIBoolean_MandatoryQuestion.ValueData, FALSE) = True THEN 1 ELSE 0 END) AS MandatoryQuestion
                         FROM MovementItem
                         
                              LEFT JOIN MovementItemBoolean AS MIBoolean_MandatoryQuestion
                                                            ON MIBoolean_MandatoryQuestion.MovementItemId = MovementItem.Id
                                                           AND MIBoolean_MandatoryQuestion.DescId = zc_MIBoolean_MandatoryQuestion()
                                                           
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Child()
                           AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                         GROUP BY MovementItem.ParentId 
                         )


            -- результат
            SELECT COALESCE(MovementItem.Id,0)                         AS Id
                 , tmpTopicsTestingTuning.Id                           AS TopicsTestingTuningId
                 , tmpTopicsTestingTuning.Code                         AS TopicsTestingTuningCode
                 , tmpTopicsTestingTuning.Name                         AS TopicsTestingTuningName
                 , tmpQuestions.Questions::Integer                     AS Questions 
                 , MovementItem.Amount::Integer                        AS TestQuestions
                 , tmpQuestions.MandatoryQuestion::Integer             AS MandatoryQuestion
                 , COALESCE(MovementItem.IsErased, FALSE)                                       AS isErased
            FROM tmpTopicsTestingTuning
                LEFT JOIN MovementItem ON tmpTopicsTestingTuning.Id = MovementItem.ObjectId 
                                      AND MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Master()
                                      AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                LEFT JOIN tmpQuestions ON tmpQuestions.Id = MovementItem.Id
            WHERE (tmpTopicsTestingTuning.isErased = FALSE OR MovementItem.Id IS NOT NULL)
            ORDER BY tmpTopicsTestingTuning.Name;
    ELSE

       -- Результат
       RETURN QUERY
        WITH
        tmpQuestions AS (SELECT MovementItem.ParentId         AS Id
                              , count(*)                      AS Questions
                              , SUM(CASE WHEN COALESCE (MIBoolean_MandatoryQuestion.ValueData, FALSE) = True THEN 1 ELSE 0 END) AS MandatoryQuestion
                         FROM MovementItem

                              LEFT JOIN MovementItemBoolean AS MIBoolean_MandatoryQuestion
                                                            ON MIBoolean_MandatoryQuestion.MovementItemId = MovementItem.Id
                                                           AND MIBoolean_MandatoryQuestion.DescId = zc_MIBoolean_MandatoryQuestion()

                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId = zc_MI_Child()
                           AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
                         GROUP BY MovementItem.ParentId 
                         )


            -- результат
            SELECT COALESCE(MovementItem.Id,0)                         AS Id
                 , Object_TopicsTestingTuning.Id                       AS TopicsTestingTuningId
                 , Object_TopicsTestingTuning.ObjectCode               AS TopicsTestingTuningCode
                 , Object_TopicsTestingTuning.ValueData                AS TopicsTestingTuningName
                 , tmpQuestions.Questions::Integer                     AS Questions 
                 , MovementItem.Amount::Integer                        AS TestQuestions
                 , tmpQuestions.MandatoryQuestion::Integer             AS MandatoryQuestion
                 , COALESCE(MovementItem.IsErased, FALSE)                                       AS isErased
            FROM MovementItem 
            
                LEFT JOIN Object AS Object_TopicsTestingTuning
                                 ON Object_TopicsTestingTuning.ID = MovementItem.ObjectId 
                                 
                LEFT JOIN tmpQuestions ON tmpQuestions.Id = MovementItem.Id
                
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId = zc_MI_Master()
              AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
            ORDER BY Object_TopicsTestingTuning.ValueData;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_TestingTuning_Master (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- 
select * from gpSelect_MovementItem_TestingTuning_Master(inMovementId := 23977600  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');