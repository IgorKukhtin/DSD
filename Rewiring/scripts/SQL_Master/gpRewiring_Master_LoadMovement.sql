-- Function: gpRewiring_Master_LoadMovement (Integer, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpRewiring_Master_LoadMovement (Integer, BOOLEAN, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpRewiring_Master_LoadMovement(
    IN inMovementId      INTEGER,
    IN inTransaction_Id  BIGINT,
    IN inisErrorRewiring BOOLEAN,
    IN inSession         TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, ProcessedCount Integer) 
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
      
   DECLARE vbCount Integer;
   DECLARE vbProcessedCount Integer;
   
   DECLARE vbStatusId Integer;  
   
   DECLARE vbRecord Record;
   DECLARE vbId Integer;  
   DECLARE vbParentId Integer;  
   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;

   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpSelect_ReplicaConnectParams(inSession);     

   -- нашли
   SELECT Movement.StatusId
   INTO vbStatusId
   FROM Movement WHERE Movement.Id = inMovementId;
   
   -- !!!проверка!!!
   IF COALESCE (vbStatusId, 0) = 0
   THEN
       RAISE EXCEPTION 'NOT FIND, inMovementId = %', inMovementId;
   END IF;

   -- Если документ непроведен то ничего не делаем и отмечаем на слейве что выполнили
   IF vbStatusId <> zc_Enum_Status_Complete()
   THEN
       RAISE EXCEPTION 'NOT Complete, inMovementId = %', inMovementId;
   END IF;
   
   IF inisErrorRewiring = FALSE
   THEN

     -- Получим новые движения
     CREATE TEMP TABLE tmpMIContainer ON COMMIT DROP AS
     SELECT q.Id, q.DescId, q.MovementId, q.ContainerId, q.Amount, 
            q.OperDate, q.MovementItemId, q.ParentId, q.isActive,  
            q.MovementDescId, q.AnalyzerId, q.AccountId, q.ObjectId_analyzer,
            q.WhereObjectId_analyzer, q.ContainerId_analyzer, q.ObjectIntId_analyzer,
            q.ObjectExtId_analyzer, q.ContainerIntId_analyzer, q.AccountId_analyzer
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT Id, DescId, MovementId, ContainerId, Amount, 
                         OperDate, MovementItemId, ParentId, isActive,  
                         MovementDescId, AnalyzerId, AccountId, ObjectId_analyzer,
                         WhereObjectId_analyzer, ContainerId_analyzer, ObjectIntId_analyzer,
                         ObjectExtId_analyzer, ContainerIntId_analyzer, AccountId_analyzer
                  FROM _replica.MovementItemContainer_Rewiring
                  WHERE MovementItemContainer_Rewiring.MovementId = '||inMovementId::Text||
                  ' AND MovementItemContainer_Rewiring.Transaction_Id = '||inTransaction_Id::Text) AS 
                   q(Id BIGINT, DescId INTEGER, MovementId INTEGER, ContainerId INTEGER, Amount TFloat, 
                     OperDate TDateTime, MovementItemId Integer, ParentId BigInt, isActive Boolean,  
                     MovementDescId integer, AnalyzerId integer, AccountId integer, ObjectId_analyzer integer,
                     WhereObjectId_analyzer integer, ContainerId_analyzer integer, ObjectIntId_analyzer integer,
                     ObjectExtId_analyzer integer, ContainerIntId_analyzer integer, AccountId_analyzer integer);  
                     
     IF NOT EXISTS(SELECT tmpMIContainer.Id FROM tmpMIContainer)
     THEN
       RAISE EXCEPTION 'Нет данных для перепроведения документа, inMovementId = %', inMovementId;   
     END IF;

     -- Добавим протокол
     INSERT INTO MovementProtocol (MovementId, UserId, OperDate, ProtocolData, isInsert)
     SELECT q.MovementId, q.UserId, q.OperDate, q.ProtocolData, q.isInsert
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT MovementId, UserId, OperDate, ProtocolData, isInsert
                  FROM _replica.MovementProtocol_Rewiring
                  WHERE MovementProtocol_Rewiring.MovementId = '||inMovementId::Text||
                  ' AND MovementProtocol_Rewiring.Transaction_Id = '||inTransaction_Id::Text) AS 
                   q(MovementId INTEGER, UserId INTEGER, OperDate TDateTime, ProtocolData TBlob, isInsert Boolean)
     WHERE NOT EXISTS(SELECT MP.Id FROM MovementProtocol AS MP WHERE MP.MovementId = q.MovementId AND MP.OperDate = q.OperDate);  
                     
     GET DIAGNOSTICS vbProcessedCount = ROW_COUNT; 
     
     -- Получим изменившихся свойств
     CREATE TEMP TABLE tmpMovementProperties ON COMMIT DROP AS
     SELECT q.Table_Name, q.ValueId, q.DescId, q.ValueData
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT Table_Name, ValueId, DescId, ValueData
                  FROM _replica.gpSelect_Slave_MovementProperties(
                      inTransaction_Id := '||inTransaction_Id::Text||
                      ', inSession := '''||inSession::Text||''')') AS 
                   q(Table_Name TVarChar, ValueId Integer, DescId Integer, ValueData TEXT);     
                     
     -- Отнемаем с контейнеров текущие контейнера
     WITH tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                  , SUM(MovementItemContainer.Amount)::TFloat AS Amount
                             FROM MovementItemContainer
                             WHERE MovementItemContainer.MovementID = inMovementId
                             GROUP BY MovementItemContainer.ContainerId
                             HAVING SUM(MovementItemContainer.Amount) <> 0)
     
     UPDATE Container SET Amount = Container.Amount - tmpMIContainer.Amount
     FROM tmpMIContainer
     WHERE tmpMIContainer.ContainerId = Container.Id;
                     
     GET DIAGNOSTICS vbCount = ROW_COUNT; 
     vbProcessedCount := vbProcessedCount + vbCount;

     raise notice 'Отнемаем с контейнеров удаленные : %', vbCount;

     -- Удаляем движения по документу
     DELETE FROM MovementItemContainer
     WHERE MovementItemContainer.MovementID = inMovementId;
                     
     GET DIAGNOSTICS vbCount = ROW_COUNT; 
     vbProcessedCount := vbProcessedCount + vbCount;

     raise notice 'Удаляем движения по документу : %', vbCount;
              
     -- Создаем проводки без ParentId
     vbCount := 0;
     FOR vbRecord IN SELECT * FROM tmpMIContainer ORDER BY tmpMIContainer.Id
     LOOP
     
       
       IF COALESCE (vbRecord.ParentId, 0) <> 0
       THEN
         SELECT tmpMIContainer.ParentId
         INTO vbParentId
         FROM tmpMIContainer 
         WHERE tmpMIContainer.Id = vbRecord.Id; 
       ELSE
         vbParentId := Null;
       END IF;

       INSERT INTO MovementItemContainer (DescId, MovementId, ContainerId, Amount, OperDate, MovementItemId, ParentId, isActive,  
                                          MovementDescId, AnalyzerId, AccountId, ObjectId_analyzer, WhereObjectId_analyzer, ContainerId_analyzer,
                                          ObjectIntId_analyzer, ObjectExtId_analyzer, ContainerIntId_analyzer, AccountId_analyzer)
       VALUES (vbRecord.DescId, vbRecord.MovementId, vbRecord.ContainerId, vbRecord.Amount, vbRecord.OperDate, 
              vbRecord.MovementItemId, vbParentId, vbRecord.isActive, vbRecord.MovementDescId, vbRecord.AnalyzerId, 
              vbRecord.AccountId, vbRecord.ObjectId_analyzer, vbRecord.WhereObjectId_analyzer, vbRecord.ContainerId_analyzer,
              vbRecord.ObjectIntId_analyzer, vbRecord.ObjectExtId_analyzer, vbRecord.ContainerIntId_analyzer, vbRecord.AccountId_analyzer)
       RETURNING MovementItemContainer.Id INTO vbID;
       
       UPDATE tmpMIContainer SET ParentId = vbID
       WHERE tmpMIContainer.ParentId = vbRecord.Id;
       
       vbCount := vbCount + 1;
     END LOOP;  
             
     vbProcessedCount := vbProcessedCount + vbCount;

     raise notice 'Создаем проводки : %', vbCount;
     
     -- Добавляем в контейнера новые проводки
     WITH tmpMIContainer AS (SELECT MovementItemContainer.ContainerId
                                  , SUM(MovementItemContainer.Amount)::TFloat AS Amount
                             FROM MovementItemContainer
                             WHERE MovementItemContainer.MovementID = inMovementId
                             GROUP BY MovementItemContainer.ContainerId
                             HAVING SUM(MovementItemContainer.Amount) <> 0)
     
     UPDATE Container SET Amount = Container.Amount + tmpMIContainer.Amount
     FROM tmpMIContainer
     WHERE tmpMIContainer.ContainerId = Container.Id;
                     
     GET DIAGNOSTICS vbCount = ROW_COUNT; 
     vbProcessedCount := vbProcessedCount + vbCount;

     raise notice 'Добавляем в контейнера новые : %', vbCount;
     
     PERFORM CASE WHEN MP.Table_Name ILIKE 'MovementBLOB' 
                  THEN lpInsertUpdate_MovementBLOB(MP.DescId, MP.ValueId, MP.ValueData::TBlob)
                  WHEN MP.Table_Name ILIKE 'MovementBoolean' 
                  THEN lpInsertUpdate_MovementBoolean(MP.DescId, MP.ValueId, MP.ValueData::Boolean)
                  WHEN MP.Table_Name ILIKE 'MovementDate' 
                  THEN lpInsertUpdate_MovementDate(MP.DescId, MP.ValueId, MP.ValueData::TDateTime)
                  WHEN MP.Table_Name ILIKE 'MovementFloat' 
                  THEN lpInsertUpdate_MovementFloat(MP.DescId, MP.ValueId, MP.ValueData::TFloat)
                  WHEN MP.Table_Name ILIKE 'MovementString' 
                  THEN lpInsertUpdate_MovementString(MP.DescId, MP.ValueId, MP.ValueData::TVarChar)
                  WHEN MP.Table_Name ILIKE 'MovementLinkMovement' 
                  THEN lpInsertUpdate_MovementLinkMovement(MP.DescId, MP.ValueId, MP.ValueData::Integer)
                  WHEN MP.Table_Name ILIKE 'MovementLinkObject' 
                  THEN lpInsertUpdate_MovementLinkObject(MP.DescId, MP.ValueId, MP.ValueData::Integer)
                  WHEN MP.Table_Name ILIKE 'MovementItemBoolean' 
                  THEN lpInsertUpdate_MovementItemBoolean(MP.DescId, MP.ValueId, MP.ValueData::Boolean)
                  WHEN MP.Table_Name ILIKE 'MovementItemDate' 
                  THEN lpInsertUpdate_MovementItemDate(MP.DescId, MP.ValueId, MP.ValueData::TDateTime)
                  WHEN MP.Table_Name ILIKE 'MovementItemFloat' 
                  THEN lpInsertUpdate_MovementItemFloat(MP.DescId, MP.ValueId, MP.ValueData::TFloat)
                  WHEN MP.Table_Name ILIKE 'MovementItemString' 
                  THEN lpInsertUpdate_MovementItemString(MP.DescId, MP.ValueId, MP.ValueData::TVarChar)
                  WHEN MP.Table_Name ILIKE 'MovementItemLinkObject' 
                  THEN lpInsertUpdate_MovementItemLinkObject(MP.DescId, MP.ValueId, MP.ValueData::Integer)
                  END
     FROM tmpMovementProperties AS MP;
     
     vbCount := (SELECT COUNT(*) FROM tmpMovementProperties); 
     vbProcessedCount := vbProcessedCount + vbCount;

     raise notice 'Добавляем свойства : %', vbCount;
   ELSE
   
     PERFORM gpComplete_All_Sybase (inMovementId:= inMovementId, inIsNoHistoryCost := False, inSession:= inSession);   
     
   END IF;
   
      
      -- Результат
   RETURN QUERY
   SELECT 1 AS Id, COALESCE(vbProcessedCount, 0) AS ProcessedCount;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.23                                                       * 
*/

-- Тест

-- select * from _replica.gpRewiring_Master_LoadMovement(inMovementId:= 26072948, inTransaction_Id:= 15025815, inSession:= zfCalc_UserAdmin());
