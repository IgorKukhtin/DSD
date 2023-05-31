-- Function: _replica.lpBranchService_Get_MovementId (integer)

DROP FUNCTION IF EXISTS _replica.lpBranchService_Get_MovementId (integer, integer, TVarChar);

CREATE OR REPLACE FUNCTION _replica.lpBranchService_Get_MovementId(
      IN inDescId     integer  ,   -- DescId 
   INOUT ioId         Integer  ,   -- Id документа        
   INOUT ioInvNumber  TVarChar    -- InvNumber документа
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbInvNumber        Integer;
   DECLARE vbMovementDescMax  Integer;
   DECLARE vbMovementDescMin  Integer;
   DECLARE vbMovementIdMax  Integer;
   DECLARE vbMovementIdMin  Integer;

   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
   DECLARE text_var1   Text;

   DECLARE vbQueryText TEXT;
   DECLARE vbId_Seq TEXT;
   DECLARE vbInvNumber_Seq TEXT;
BEGIN

   IF NOT EXISTS(SELECT _replica.BranchService_DescId_Movement.DescId
                 FROM _replica.BranchService_DescId_Movement
                 WHERE _replica.BranchService_DescId_Movement.isInsert = True
                   AND _replica.BranchService_DescId_Movement.DescId = inDescId)
   THEN
     RAISE EXCEPTION 'Не предусмотрено создание документов <%>...', 
                     (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.id = inDescId);
   END IF;
      
   BEGIN
     vbInvNumber := ioInvNumber::Integer;
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
      vbInvNumber := Null;
   END;
   
   SELECT _replica.BranchService_DescId_Movement.MovementDescMax
        , _replica.BranchService_DescId_Movement.MovementDescMin
   INTO vbMovementDescMax, vbMovementDescMin
   FROM _replica.BranchService_DescId_Movement
   WHERE _replica.BranchService_DescId_Movement.isInsert = True
     AND _replica.BranchService_DescId_Movement.DescId = inDescId;

   SELECT _replica.BranchService_DescId_Movement.MovementDescMax
        , _replica.BranchService_DescId_Movement.MovementDescMin
   INTO vbMovementIdMax, vbMovementIdMin
   FROM _replica.BranchService_DescId_Movement
   WHERE _replica.BranchService_DescId_Movement.isInsert = True
     AND _replica.BranchService_DescId_Movement.DescId = 0;
   
   vbId_Seq := 'Movement_Id_Seq';
   vbInvNumber_Seq := (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.id = inDescId)||'_Seq';
   vbInvNumber_Seq := SUBSTRING(vbInvNumber_Seq, 4, length(vbInvNumber_Seq));
         
   IF NOT EXISTS(SELECT *
                 FROM information_schema.sequences AS S
                 WHERE S.sequence_catalog = current_database() 
                   AND S.sequence_schema = current_schema()  
                   AND s.sequence_name ILIKE vbInvNumber_Seq)         
   THEN
     vbInvNumber_Seq := '';
   END IF;

   -- Резервируем Id
   /*IF (SELECT count(*)
       FROM _replica.BranchService_Reserve_Movement
       WHERE _replica.BranchService_Reserve_Movement.isUsed = False
         AND _replica.BranchService_Reserve_Movement.DescId = 0) <= vbMovementIdMin 
   THEN

     BEGIN
       SELECT Host, DBName, Port, UserName, Password
       INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
       FROM _replica.gpBranchService_Select_MasterConnectParams('0');

       vbMovementIdMin :=  (SELECT count(*)
                            FROM _replica.BranchService_Reserve_Movement
                            WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                              AND _replica.BranchService_Reserve_Movement.DescId = 0); 

       vbQueryText := 'INSERT INTO _replica.BranchService_Reserve_Movement (DescId, Id) '||
                      'SELECT 0 AS DescId, q.Id '||
                      'FROM dblink(''host='||vbHost||
                                    ' dbname='||vbDBName||
                                    ' port='||vbPort::Text|| 
                                    ' user='||vbUserName||
                                    ' password='||vbPassword||'''::text,'''|| 
                                   'SELECT GENERATE_SERIES (1, '||(vbMovementIdMax - vbMovementIdMin)::Text||', 1) AS Ord '||
                                   ', CAST (NEXTVAL ('''''||vbId_Seq||''''') AS Integer) AS Id;''::text) AS '||
                                   'q(Ord Integer, Id Integer)';
       
       EXECUTE vbQueryText;

     EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     END;

   END IF;

   -- Резервируем InvNumber
   IF COALESCE ( vbInvNumber_Seq, '') <> '' AND
      (SELECT count(*)
       FROM _replica.BranchService_Reserve_Movement
       WHERE _replica.BranchService_Reserve_Movement.isUsed = False
         AND _replica.BranchService_Reserve_Movement.DescId = inDescId) <= vbMovementDescMin 
   THEN

     BEGIN
       SELECT Host, DBName, Port, UserName, Password
       INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
       FROM _replica.gpBranchService_Select_MasterConnectParams('0');

       vbMovementDescMin :=  (SELECT count(*)
                              FROM _replica.BranchService_Reserve_Movement
                              WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                                AND _replica.BranchService_Reserve_Movement.DescId = inDescId); 

       vbQueryText := 'INSERT INTO _replica.BranchService_Reserve_Movement (DescId, Id) '||
                      'SELECT '||inDescId::Text||' AS DescId, q.Id '||
                      'FROM dblink(''host='||vbHost||
                                    ' dbname='||vbDBName||
                                    ' port='||vbPort::Text|| 
                                    ' user='||vbUserName||
                                    ' password='||vbPassword||'''::text,'''|| 
                                   'SELECT GENERATE_SERIES (1, '||(vbMovementDescMax - vbMovementDescMin)::Text||', 1) AS Ord '||
                                   ', CAST (NEXTVAL ('''''||vbInvNumber_Seq||''''') AS Integer) AS Id;''::text) AS '||
                                   'q(Ord Integer, Id Integer)';
                                     
       EXECUTE vbQueryText;

     EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     END;

   END IF; */


   -- Обрабатіваем ID
   IF COALESCE(ioId, 0) <> 0 AND
      NOT EXISTS(SELECT _replica.BranchService_Reserve_Movement.Id
                 FROM _replica.BranchService_Reserve_Movement
                 WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                   AND _replica.BranchService_Reserve_Movement.Id = ioId
                   AND _replica.BranchService_Reserve_Movement.DescId = 0)
   THEN
     ioId := 0;
   END IF;

   IF COALESCE(ioId, 0) = 0
   THEN
     SELECT _replica.BranchService_Reserve_Movement.Id
     INTO ioId
     FROM _replica.BranchService_Reserve_Movement
     WHERE _replica.BranchService_Reserve_Movement.isUsed = False
       AND _replica.BranchService_Reserve_Movement.DescId = 0
     ORDER BY _replica.BranchService_Reserve_Movement.Id
     LIMIT 1;
   END IF;
   
   IF COALESCE(ioId, 0) = 0
   THEN
     RAISE EXCEPTION 'Не осталось зарезервированных номеров для документов <%> попробуйте позже, как будет связь с основным сервером...', 
                     (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.id = inDescId);
   END IF;
   
   UPDATE _replica.BranchService_Reserve_Movement SET isUsed = True
   WHERE _replica.BranchService_Reserve_Movement.Id = ioId
     AND _replica.BranchService_Reserve_Movement.DescId = 0;

   -- Установим последовательность Id
   PERFORM setval(vbId_Seq, (SELECT min(_replica.BranchService_Reserve_Movement.Id)
                             FROM _replica.BranchService_Reserve_Movement
                             WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                               AND _replica.BranchService_Reserve_Movement.DescId = 0), false);

   -- Обрабатываем InvNumber
   IF COALESCE (vbInvNumber_Seq, '') <> ''
   THEN

     -- Обрабатіваем ID
     IF COALESCE(vbInvNumber, 0) <> 0 AND
        EXISTS(SELECT _replica.BranchService_Reserve_Movement.Id
               FROM _replica.BranchService_Reserve_Movement
               WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                 AND _replica.BranchService_Reserve_Movement.Id = vbInvNumber
                 AND _replica.BranchService_Reserve_Movement.DescId = inDescId)
     THEN
       UPDATE _replica.BranchService_Reserve_Movement SET isUsed = True
       WHERE _replica.BranchService_Reserve_Movement.Id = vbInvNumber
         AND _replica.BranchService_Reserve_Movement.DescId = inDescId;
         
     ELSEIF COALESCE(vbInvNumber, 0) <> 0 AND
        NOT EXISTS(SELECT _replica.BranchService_Reserve_Movement.Id
                   FROM _replica.BranchService_Reserve_Movement
                   WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                     AND _replica.BranchService_Reserve_Movement.DescId = inDescId) 
     THEN
       RAISE EXCEPTION 'Не осталось зарезервированных номеров для документов <%> попробуйте позже, как будет связь с основным сервером...', 
                       (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.id = inDescId);
     ELSE
       -- Установим последовательность InvNumber
       PERFORM setval(vbInvNumber_Seq, (SELECT min(_replica.BranchService_Reserve_Movement.Id)
                                        FROM _replica.BranchService_Reserve_Movement
                                        WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                                          AND _replica.BranchService_Reserve_Movement.DescId = inDescId), false);         

       RAISE EXCEPTION 'Номер документа <%> не соответствует допустимому по последовательности...', 
                       (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.id = inDescId);
     END IF;

     -- Установим последовательность InvNumber
     PERFORM setval(vbInvNumber_Seq, (SELECT min(_replica.BranchService_Reserve_Movement.Id)
                                      FROM _replica.BranchService_Reserve_Movement
                                      WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                                        AND _replica.BranchService_Reserve_Movement.DescId = inDescId), false);         
   END IF;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.05.23                                                       * 
*/

-- SELECT * FROM _replica.lpBranchService_Get_MovementId (zc_Movement_Sale(), , '');