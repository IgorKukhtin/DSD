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
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
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
                                                                      
     SELECT tmpMaster.TopicsTestingTuningId
          , tmpMaster.TopicsTestingTuningName
          , tmpMaster.Question 
          , tmpChild.Orders
          , tmpChild.Question
          , tmpSecond.PossibleAnswer
     FROM tmpMaster
     
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