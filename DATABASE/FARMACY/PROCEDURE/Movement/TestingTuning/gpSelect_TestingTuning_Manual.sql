-- Function: gpSelect_TestingTuning_Manual()

DROP FUNCTION IF EXISTS gpSelect_TestingTuning_Manual (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TestingTuning_Manual(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (TopicsTestingTuningId Integer
             , TopicsTestingTuningName TVarChar
             , Questions Integer
             , Orders Integer
             , Question TBLOB
             , PossibleAnswer TBLOB
             , PropertiesId Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbPositionCode Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TestingTuning());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT Movement.Id
          , ROW_NUMBER()OVER(ORDER BY Movement.StatusId DESC, Movement.OperDate DESC) as ORD
     INTO vbMovementId
     FROM Movement 
     WHERE Movement.OperDate <= CURRENT_DATE
       AND Movement.DescId = zc_Movement_TestingTuning()
       AND Movement.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
     ORDER BY 2
     LIMIT 1;
       
     IF COALESCE (vbMovementId, 0) = 0
     THEN
       RAISE EXCEPTION 'Не найден активный документ настройки тестирования.';     
     END IF;                

     SELECT COALESCE(Object_Position.ObjectCode, 1)
     INTO vbPositionCode
     FROM Object AS Object_User

          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                               ON ObjectLink_User_Member.ObjectId = Object_User.Id
                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                               ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                              AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
                                           
     WHERE Object_User.Id = vbUserId
       AND Object_User.DescId = zc_Object_User();
       
     RETURN QUERY
     WITH tmpMaster AS (SELECT * 
                        FROM gpSelect_MovementItem_TestingTuning_Master(inMovementId := vbMovementId 
                                                                      , inShowAll := 'False' 
                                                                      , inIsErased := 'False' 
                                                                      , inSession := inSession))
        , tmpChild AS (SELECT *                
                       FROM gpSelect_MovementItem_TestingTuning_Child(inMovementId := vbMovementId 
                                                                    , inShowAll := 'False' 
                                                                    , inIsErased := 'False' 
                                                                    , inSession := inSession))
        , tmpSecond AS (SELECT *                
                        FROM gpSelect_MovementItem_TestingTuning_Second(inMovementId := vbMovementId 
                                                                      , inShowAll := 'False' 
                                                                      , inIsErased := 'False' 
                                                                      , inSession := inSession))
        , tmpTopicsTesting AS (SELECT DISTINCT Object_TopicsTestingTuning.Id                           AS TopicsTestingTuningId
                               FROM Object AS Object_TopicsTestingTuning
                                
                                    INNER JOIN MovementItem ON MovementItem.ObjectId = Object_TopicsTestingTuning.Id
                                                           AND MovementItem.MovementId = vbMovementId
                                                           AND MovementItem.DescId = zc_MI_Master()
                                                           AND MovementItem.isErased = FALSE

                                    LEFT JOIN MovementItemFloat AS MIFloat_TestQuestionsStorekeeper
                                                                ON MIFloat_TestQuestionsStorekeeper.MovementItemId = MovementItem.Id
                                                               AND MIFloat_TestQuestionsStorekeeper.DescId = zc_MIFloat_AmountStorekeeper()
                                                               
                                WHERE Object_TopicsTestingTuning.DescId = zc_Object_TopicsTestingTuning()
                                  AND Object_TopicsTestingTuning.isErased = False
                                  AND (vbPositionCode = 1 AND MovementItem.Amount > 0 OR
                                       vbPositionCode = 2 AND COALESCE (MIFloat_TestQuestionsStorekeeper.ValueData, 0) > 0 ) OR
                                       COALESCE (vbPositionCode, 0) NOT IN (1, 2))
                                                                      
     SELECT tmpMaster.TopicsTestingTuningId
          , tmpMaster.TopicsTestingTuningName
          , tmpMaster.Question 
          , tmpChild.Orders
          , tmpChild.Question
          , tmpSecond.PossibleAnswer
          , tmpSecond.PropertiesId
     FROM tmpMaster
     
          INNER JOIN tmpTopicsTesting ON tmpTopicsTesting.TopicsTestingTuningId = tmpMaster.TopicsTestingTuningId
          
          INNER JOIN tmpChild ON tmpChild.ParentId = tmpMaster.Id

          INNER JOIN tmpSecond ON tmpSecond.ParentId = tmpChild.Id
                              AND tmpSecond.isCorrectAnswer = True
          
     ORDER BY tmpMaster.TopicsTestingTuningName, tmpChild.Orders
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_TestingTuning_Manual(TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- 

select * from gpSelect_TestingTuning_Manual(inSession:= '3');