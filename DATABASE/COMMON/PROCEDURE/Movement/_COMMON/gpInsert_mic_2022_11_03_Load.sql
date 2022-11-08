-- Function: gpInsert_mic_2022_11_03_Load()

DROP FUNCTION IF EXISTS gpInsert_mic_2022_11_03_Load (Integer, Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_mic_2022_11_03_Load (TVarChar, Integer, Integer, Integer, TFloat, TDateTime, Integer, Integer, Boolean, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_mic_2022_11_03_Load(
    IN inId                      TVarChar    ,
    IN inDescId                  Integer   ,
    IN inMovementId              Integer   ,
    IN inContainerId             Integer   , 
    IN inAmount                  TFloat    ,
    IN inOperDate                TDateTime ,
    IN inMovementItemId          Integer   ,
    IN inParentId                Integer   ,
    IN inisActive                Boolean   ,
    IN inMovementDescId          Integer   ,
    IN inAnalyzerId              Integer   ,
    IN inAccountId               Integer   ,
    IN inObjectId_Analyzer       Integer   ,
    IN inWhereObjectId_Analyzer  Integer   ,
    IN inContainerId_Analyzer    Integer   ,
    IN inObjectIntId_Analyzer    Integer   ,
    IN inObjectExtId_Analyzer    Integer   ,
    IN inContainerIntId_Analyzer Integer   ,
    IN inAccountId_Analyzer      Integer   ,     
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId BigInt;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Insert_mic_2022_11_03_load());
     vbUserId := lpGetUserBySession (inSession);

     vbId:= inId :: BigInt;

     -- IF COALESCE (inId,0) = 0 THEN RETURN; END IF;
     IF COALESCE (vbId, 0) = 0
     THEN RAISE EXCEPTION 'Ошибка.Id = <%>  MovementId = <%> MovementItemId = <%> ContainerId = <%>.'
                        , inId, inMovementId, inMovementItemId, inContainerId
                         ;
     END IF;
     
     IF EXISTS (SELECT 1 FROM mic_2022_11_03 WHERE mic_2022_11_03.Id = vbId) THEN RETURN; END IF;
     
     INSERT INTO mic_2022_11_03 (Id, DescId, MovementId, ContainerId, Amount
                               , OperDate, MovementItemId, ParentId, isActive
                               , MovementDescId, AnalyzerId, AccountId
                               , ObjectId_Analyzer, WhereObjectId_Analyzer
                               , ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer
                               , ContainerIntId_Analyzer, AccountId_Analyzer)
      VALUES (vbId, inDescId, inMovementId, inContainerId, inAmount
            , inOperDate, inMovementItemId, inParentId, inisActive
            , inMovementDescId, inAnalyzerId, inAccountId
            , inObjectId_Analyzer, inWhereObjectId_Analyzer
            , inContainerId_Analyzer, inObjectIntId_Analyzer, inObjectExtId_Analyzer
            , inContainerIntId_Analyzer, inAccountId_Analyzer)
     ;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.22         *
*/

-- тест
-- TRUNCATE TABLE mic_2022_11_03;
