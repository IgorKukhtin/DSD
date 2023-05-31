-- Function: gpBranchService_ReserveAllId (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_ReserveAllId (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_ReserveAllId(
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementCountInvNumber Integer, MovementCount Integer, MovementItemCount Integer, ErrorText TBlob) 
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
   DECLARE vbRecord    record;
   DECLARE text_var1   Text;
   DECLARE vbMovementCountInvNumber Integer; 
   DECLARE vbMovementCount Integer; 
   DECLARE vbMovementItemCount Integer;
   DECLARE vbQueryText TEXT;
   DECLARE vbMin       Integer;
   DECLARE vbId_Seq    Text;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;
   
   text_var1 := '';
   vbMovementCountInvNumber := 0;
   vbMovementCount := 0;
   vbMovementItemCount := 0;

   -- Результат
   RETURN QUERY
   SELECT 1, vbMovementCountInvNumber, vbMovementCount, vbMovementItemCount, 'Резервирование отключено'::TBlob;

   RETURN;
   
   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpBranchService_Select_MasterConnectParams(inSession);

   -- Пробигаемся по потребности
             
   FOR vbRecord IN
      SELECT DM.DescId, DM.MovementDescMax, DM.MovementDescMin    
      FROM _replica.BranchService_DescId_Movement AS DM
      WHERE DM.isInsert = TRUE OR DM.DescId = 0
   LOOP
         
     BEGIN
     
       IF vbRecord.DescId > 0 
       THEN
       
         vbId_Seq := (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.id = vbRecord.DescId)||'_Seq';
         vbId_Seq := SUBSTRING(vbId_Seq, 4, length(vbId_Seq));
         
         IF EXISTS(SELECT *
                   FROM information_schema.sequences AS S
                   WHERE S.sequence_catalog = current_database() 
                     AND S.sequence_schema = current_schema()  
                     AND s.sequence_name ILIKE vbId_Seq)         
         THEN

           vbMin := (SELECT count(*)
                     FROM _replica.BranchService_Reserve_Movement
                     WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                       AND _replica.BranchService_Reserve_Movement.DescId = vbRecord.DescId); 
                      
           IF vbMin < vbRecord.MovementDescMax
           THEN

             vbMovementCountInvNumber := vbMovementCountInvNumber + (vbRecord.MovementDescMax - vbMin);
                      
             vbQueryText := 'INSERT INTO _replica.BranchService_Reserve_Movement (DescId, Id) '||
                            'SELECT '||vbRecord.DescId::Text||' AS DescId, q.Id '||
                            'FROM dblink(''host='||vbHost||
                                          ' dbname='||vbDBName||
                                          ' port='||vbPort::Text|| 
                                          ' user='||vbUserName||
                                          ' password='||vbPassword||'''::text,'''|| 
                                         'SELECT GENERATE_SERIES (1, '||(vbRecord.MovementDescMax - vbMin)::Text||', 1) AS Ord '||
                                         ', CAST (NEXTVAL ('''''||vbId_Seq||''''') AS Integer) AS Id;''::text) AS '||
                                         'q(Ord Integer, Id Integer)';
                                           
             
             EXECUTE vbQueryText;
           END IF;

           PERFORM setval(vbId_Seq, (SELECT min(_replica.BranchService_Reserve_Movement.Id)
                                     FROM _replica.BranchService_Reserve_Movement
                                     WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                                       AND _replica.BranchService_Reserve_Movement.DescId = vbRecord.DescId), false);         
           
         END IF;
       ELSEIF vbRecord.DescId = 0 
       THEN

         vbId_Seq := 'Movement_Id_Seq';

         vbMin := (SELECT count(*)
                   FROM _replica.BranchService_Reserve_Movement
                   WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                     AND _replica.BranchService_Reserve_Movement.DescId = vbRecord.DescId); 
                    
         IF vbMin < vbRecord.MovementDescMax
         THEN

           vbMovementCount := vbMovementCount + (vbRecord.MovementDescMax - vbMin);
                    
           vbQueryText := 'INSERT INTO _replica.BranchService_Reserve_Movement (DescId, Id) '||
                          'SELECT '||vbRecord.DescId::Text||' AS DescId, q.Id '||
                          'FROM dblink(''host='||vbHost||
                                        ' dbname='||vbDBName||
                                        ' port='||vbPort::Text|| 
                                        ' user='||vbUserName||
                                        ' password='||vbPassword||'''::text,'''|| 
                                       'SELECT GENERATE_SERIES (1, '||(vbRecord.MovementDescMax - vbMin)::Text||', 1) AS Ord '||
                                       ', CAST (NEXTVAL ('''''||vbId_Seq||''''') AS Integer) AS Id;''::text) AS '||
                                       'q(Ord Integer, Id Integer)';
           
           EXECUTE vbQueryText;
         END IF;

         PERFORM setval(vbId_Seq, (SELECT min(_replica.BranchService_Reserve_Movement.Id)
                                   FROM _replica.BranchService_Reserve_Movement
                                   WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                                     AND _replica.BranchService_Reserve_Movement.DescId = vbRecord.DescId), false);

       ELSEIF vbRecord.DescId = -1
       THEN

         vbId_Seq := 'MovementItem_Id_Seq';

         vbMin := (SELECT count(*)
                   FROM _replica.BranchService_Reserve_Movement
                   WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                     AND _replica.BranchService_Reserve_Movement.DescId = vbRecord.DescId); 
                    
         IF vbMin < vbRecord.MovementDescMax
         THEN
         
           vbMovementItemCount := vbMovementItemCount + (vbRecord.MovementDescMax - vbMin);
         
           vbQueryText := 'INSERT INTO _replica.BranchService_Reserve_Movement (DescId, Id) '||
                          'SELECT -1, q.Id '||
                          'FROM dblink(''host='||vbHost||
                                        ' dbname='||vbDBName||
                                        ' port='||vbPort::Text|| 
                                        ' user='||vbUserName||
                                        ' password='||vbPassword||'''::text,'''|| 
                                       'SELECT GENERATE_SERIES (1, '||(vbRecord.MovementDescMax - vbMin)::Text||', 1) AS Ord '||
                                       ', CAST (NEXTVAL ('''''||vbId_Seq||''''') AS Integer) AS Id;''::text) AS '||
                                       'q(Ord Integer, Id Integer)';
           
           EXECUTE vbQueryText;
         END IF;

         PERFORM setval(vbId_Seq, (SELECT min(_replica.BranchService_Reserve_Movement.Id)
                                   FROM _replica.BranchService_Reserve_Movement
                                   WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                                     AND _replica.BranchService_Reserve_Movement.DescId = vbRecord.DescId), false);
       
       END IF;

     EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     END;         
     
     IF text_var1 <> '' THEN EXIT; END IF;
                          
   END LOOP;  

   -- Результат
   RETURN QUERY
   SELECT 1, vbMovementCountInvNumber, vbMovementCount, vbMovementItemCount, text_var1::TBlob;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/

-- Тест
-- select * from _replica.gpBranchService_ReserveAllId('0');