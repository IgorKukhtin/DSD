-- Function: _replica.lpBranchService_Get_MovementItemId ()

DROP FUNCTION IF EXISTS _replica.lpBranchService_Get_MovementItemId (Integer);

CREATE OR REPLACE FUNCTION _replica.lpBranchService_Get_MovementItemId(
   INOUT ioId         Integer    -- Id записи        
)
RETURNS Integer
AS
$BODY$
   DECLARE vbMovementItemMax  Integer;
   DECLARE vbMovementItemMin  Integer;

   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
   DECLARE text_var1   Text;

   DECLARE vbQueryText TEXT;
   DECLARE vbId_Seq TEXT;
BEGIN

   SELECT _replica.BranchService_DescId_Movement.MovementDescMax
        , _replica.BranchService_DescId_Movement.MovementDescMin
   INTO vbMovementItemMax, vbMovementItemMin
   FROM _replica.BranchService_DescId_Movement
   WHERE _replica.BranchService_DescId_Movement.DescId = -1;
   
   /*IF (SELECT count(*)
       FROM _replica.BranchService_Reserve_Movement
       WHERE _replica.BranchService_Reserve_Movement.isUsed = False
         AND _replica.BranchService_Reserve_Movement.DescId = -1) <= vbMovementItemMin 
   THEN

     BEGIN
       SELECT Host, DBName, Port, UserName, Password
       INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
       FROM _replica.gpBranchService_Select_MasterConnectParams('0');
       
       vbMovementItemMin :=  (SELECT count(*)
                              FROM _replica.BranchService_Reserve_Movement
                              WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                                AND _replica.BranchService_Reserve_Movement.DescId = -1); 
       
       vbId_Seq := 'MovementItem_Id_Seq';

       vbQueryText := 'INSERT INTO _replica.BranchService_Reserve_Movement (DescId, Id) '||
                      'SELECT -1 AS DescId, q.Id '||
                      'FROM dblink(''host='||vbHost||
                                    ' dbname='||vbDBName||
                                    ' port='||vbPort::Text|| 
                                    ' user='||vbUserName||
                                    ' password='||vbPassword||'''::text,'''|| 
                                   'SELECT GENERATE_SERIES (1, '||(vbMovementItemMax - vbMovementItemMin)::Text||', 1) AS Ord '||
                                   ', CAST (NEXTVAL ('''''||vbId_Seq||''''') AS Integer) AS Id;''::text) AS '||
                                   'q(Ord Integer, Id Integer)';
       
       EXECUTE vbQueryText;

     EXCEPTION
        WHEN others THEN
          GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     END;

   END IF;*/

   IF COALESCE(ioId, 0) <> 0 AND
      NOT EXISTS(SELECT _replica.BranchService_Reserve_Movement.Id
                 FROM _replica.BranchService_Reserve_Movement
                 WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                   AND _replica.BranchService_Reserve_Movement.Id = ioId
                   AND _replica.BranchService_Reserve_Movement.DescId = -1)
   THEN
     ioId := 0;
   END IF;

   IF COALESCE(ioId, 0) = 0
   THEN
     SELECT _replica.BranchService_Reserve_Movement.Id
     INTO ioId
     FROM _replica.BranchService_Reserve_Movement
     WHERE _replica.BranchService_Reserve_Movement.isUsed = False
       AND _replica.BranchService_Reserve_Movement.DescId = -1
     ORDER BY _replica.BranchService_Reserve_Movement.Id
     LIMIT 1;
   END IF;
   
   IF COALESCE(ioId, 0) = 0
   THEN
     RAISE EXCEPTION 'Не осталось зарезервированных номеров для строк документов опробуйте позже, как будет связь с основным сервером...';
   END IF;
   
   UPDATE _replica.BranchService_Reserve_Movement SET isUsed = True
   WHERE _replica.BranchService_Reserve_Movement.Id = ioId
     AND _replica.BranchService_Reserve_Movement.DescId = -1;
   
   PERFORM setval(vbId_Seq, (SELECT min(_replica.BranchService_Reserve_Movement.Id)
                             FROM _replica.BranchService_Reserve_Movement
                             WHERE _replica.BranchService_Reserve_Movement.isUsed = False
                               AND _replica.BranchService_Reserve_Movement.DescId = -1), false);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.05.23                                                       * 
*/

-- SELECT * FROM _replica.lpBranchService_Get_MovementItemId (0);