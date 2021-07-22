-- Function: gpSelect_TestingTuning_Task()

DROP FUNCTION IF EXISTS gpSelect_TestingTuning_Task (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_TestingTuning_Task(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id              Integer
             , TopicsId        Integer
             , TopicsName      TVarChar
             , QuestionId      Integer
             , QuestionOrd     Integer
             , Question        TBLOB
             , PossibleAnswer1 TBLOB
             , isGraphics1     Boolean
             , PossibleAnswer2 TBLOB
             , isGraphics2     Boolean
             , PossibleAnswer3 TBLOB
             , isGraphics3     Boolean
             , PossibleAnswer4 TBLOB
             , isGraphics4     Boolean
             , CorrectAnswer   Integer
             , Response        Integer
             , StartTime       TDateTime
             , EndTime         TDateTime
              )
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbMovementId    Integer;

  DECLARE curTuning       refcursor;
  DECLARE vbId            Integer;
  DECLARE vbTopicsName    TVarChar; 
  DECLARE vbQuestions     Integer;
  DECLARE vbTestQuestions Integer;
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

     -- таблица
     CREATE TEMP TABLE _tmpData (Id              Integer 
                               , TopicsId        Integer
                               , TopicsName      TVarChar
                               , QuestionId      Integer
                               , QuestionOrd     Integer
                               , Question        TBLOB
                               , PossibleAnswer1 TBLOB
                               , isGraphics1     Boolean
                               , PossibleAnswer2 TBLOB
                               , isGraphics2     Boolean
                               , PossibleAnswer3 TBLOB
                               , isGraphics3     Boolean
                               , PossibleAnswer4 TBLOB
                               , isGraphics4     Boolean
                               , CorrectAnswer   Integer
                               , Response        Integer
                               , StartTime       TDateTime
                               , EndTime         TDateTime        
                               ) ON COMMIT DROP;


     -- курсор1 - по темам
     OPEN curTuning FOR SELECT Master.Id
                             , Master.TopicsTestingTuningName
                             , Master.Question
                             , Master.TestQuestions 
                        FROM gpSelect_MovementItem_TestingTuning_Master(inMovementId := vbMovementId 
                                                                      , inShowAll := 'False' 
                                                                      , inIsErased := 'False' 
                                                                      , inSession := inSession) AS Master
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curTuning INTO vbId, vbTopicsName, vbQuestions, vbTestQuestions;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;
         
         WITH tmpSecond AS (SELECT *    
                                 , PropertiesId = 2   AS isGraphics            
                            FROM gpSelect_MovementItem_TestingTuning_Second(inMovementId := vbMovementId 
                                                                          , inShowAll := 'False' 
                                                                          , inIsErased := 'False' 
                                                                          , inSession := inSession))
         
         INSERT INTO _tmpData (Id
                             , TopicsId
                             , TopicsName
                             , QuestionId
                             , QuestionOrd
                             , Question
                             , PossibleAnswer1
                             , isGraphics1
                             , PossibleAnswer2
                             , isGraphics2
                             , PossibleAnswer3
                             , isGraphics3
                             , PossibleAnswer4
                             , isGraphics4
                             , CorrectAnswer
                             , Response
                             , StartTime
                             , EndTime)
         SELECT Child.Id   
              , vbId   
              , vbTopicsName   
              , Child.ID
              , Child.Orders
              , Child.Question  
              , Second1.PossibleAnswer     
              , Second1.isGraphics     
              , Second2.PossibleAnswer     
              , Second2.isGraphics     
              , Second3.PossibleAnswer
              , Second3.isGraphics     
              , Second4.PossibleAnswer
              , Second4.isGraphics     
              , CASE WHEN Second1.isCorrectAnswer = TRUE THEN 1    
                     WHEN Second2.isCorrectAnswer = TRUE THEN 2
                     WHEN Second3.isCorrectAnswer = TRUE THEN 3
                     WHEN Second4.isCorrectAnswer = TRUE THEN 4 END
              , 0     
              , Null     
              , Null     
         FROM gpSelect_MovementItem_TestingTuning_Child(inMovementId := vbMovementId 
                                                      , inShowAll := 'False' 
                                                      , inIsErased := 'False' 
                                                      , inSession := inSession) AS Child
                                                      
              LEFT JOIN tmpSecond AS Second1 
                                  ON Second1.ParentId = Child.Id
                                 AND Second1.RandomID = 1
              
              LEFT JOIN tmpSecond AS Second2 
                                  ON Second2.ParentId = Child.Id
                                 AND Second2.RandomID = 2
              
              LEFT JOIN tmpSecond AS Second3 
                                  ON Second3.ParentId = Child.Id
                                 AND Second3.RandomID = 3
              
              LEFT JOIN tmpSecond AS Second4 
                                  ON Second4.ParentId = Child.Id
                                 AND Second4.RandomID = 4
              
         WHERE Child.RandomID <= vbTestQuestions
           AND Child.ParentId = vbId;

     END LOOP; -- финиш цикла по курсору1
     CLOSE curTuning; -- закрыли курсор1

     RETURN QUERY                                                                  
     SELECT ROW_NUMBER()OVER(ORDER BY random())::Integer AS Id
          , _tmpData.TopicsId
          , _tmpData.TopicsName
          , _tmpData.QuestionId
          , _tmpData.QuestionOrd
          , _tmpData.Question
          , _tmpData.PossibleAnswer1
          , _tmpData.isGraphics1
          , _tmpData.PossibleAnswer2
          , _tmpData.isGraphics2
          , _tmpData.PossibleAnswer3
          , _tmpData.isGraphics3
          , _tmpData.PossibleAnswer4
          , _tmpData.isGraphics4
          , _tmpData.CorrectAnswer
          , _tmpData.Response
          , _tmpData.StartTime
          , _tmpData.EndTime
     FROM _tmpData
     ORDER BY 1
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_TestingTuning_Task(TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 15.07.21                                                                     *  
*/

-- тест
-- 

select * from gpSelect_TestingTuning_Task(inSession:= '3');