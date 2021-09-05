-- Function: gpUpdate_Movement_Check_SummaReceivedFact()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_SummaReceivedFact(TFloat, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_SummaReceivedFact(
    IN inSummaReceivedFact         TFloat    , --Сумма получено по факту
    IN inJSON        Text      , -- json     
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE curTmp refcursor;
   DECLARE vbID Integer;
   DECLARE vbTotalSumm TFloat;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 6534523))
  THEN
    RAISE EXCEPTION 'Изменение признака <Сумма получено по факту> вам запрещено.';
  END IF;
      
  IF COALESCE(inSummaReceivedFact, 0) < 0
  THEN
    RAISE EXCEPTION 'Сумма <Сумма получено по факту> должна быть положительной.';
  END IF;
  
  -- из JSON в таблицу
  CREATE TEMP TABLE tblRetrievedAccountingJSON
  (
     Id                       Integer,
     isRetrievedAccounting    Boolean,
     TotalSumm			      TFloat,
     SummaReceivedFact        TFloat
  ) ON COMMIT DROP;

  INSERT INTO tblRetrievedAccountingJSON
  SELECT *
  FROM json_populate_recordset(null::tblRetrievedAccountingJSON, replace(replace(replace(inJSON, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
  raise notice 'Value 05: %', (select Count(*) from tblRetrievedAccountingJSON);      
  
  
  

    
  IF COALESCE(inSummaReceivedFact, 0) > COALESCE((SELECT SUM(tblRetrievedAccountingJSON.TotalSumm) FROM  tblRetrievedAccountingJSON), 0)
  THEN
    RAISE EXCEPTION 'Сумма получено по факту <%> должна быть меньше или равна сумме чекаов <%>.', 
          COALESCE(inSummaReceivedFact, 0), COALESCE((SELECT SUM(tblRetrievedAccountingJSON.TotalSumm) FROM  tblRetrievedAccountingJSON), 0);
  END IF;
  
  IF COALESCE(inSummaReceivedFact, 0) = COALESCE((SELECT SUM(tblRetrievedAccountingJSON.TotalSumm) FROM  tblRetrievedAccountingJSON), 0)
  THEN
     PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), tblRetrievedAccountingJSON.Id, 0)
     FROM  tblRetrievedAccountingJSON
     WHERE COALESCE (tblRetrievedAccountingJSON.SummaReceivedFact, 0) > 0;

     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_RetrievedAccounting(), tblRetrievedAccountingJSON.Id, True)
     FROM  tblRetrievedAccountingJSON;

     PERFORM lpInsert_MovementProtocol (tblRetrievedAccountingJSON.Id, vbUserId, False)
     FROM  tblRetrievedAccountingJSON;
  ELSEIF COALESCE(inSummaReceivedFact, 0) = 0
  THEN
     PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), tblRetrievedAccountingJSON.Id, 0)
     FROM  tblRetrievedAccountingJSON
     WHERE COALESCE (tblRetrievedAccountingJSON.SummaReceivedFact, 0) > 0;

     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_RetrievedAccounting(), tblRetrievedAccountingJSON.Id, False)
     FROM  tblRetrievedAccountingJSON
     WHERE isRetrievedAccounting = TRUE;

     PERFORM lpInsert_MovementProtocol (tblRetrievedAccountingJSON.Id, vbUserId, False)
     FROM  tblRetrievedAccountingJSON 
     WHERE COALESCE (tblRetrievedAccountingJSON.SummaReceivedFact, 0) > 0
        OR isRetrievedAccounting = TRUE;
  ELSEIF COALESCE(inSummaReceivedFact, 0) <> 
         COALESCE((SELECT SUM(CASE WHEN COALESCE(tblRetrievedAccountingJSON.isRetrievedAccounting, False) = True 
                                   THEN tblRetrievedAccountingJSON.TotalSumm
                                   ELSE tblRetrievedAccountingJSON.SummaReceivedFact END)::TFloat 
                   FROM tblRetrievedAccountingJSON), 0)
  THEN 
     PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), tblRetrievedAccountingJSON.Id, 0)
     FROM  tblRetrievedAccountingJSON
     WHERE COALESCE (tblRetrievedAccountingJSON.SummaReceivedFact, 0) > 0;

     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_RetrievedAccounting(), tblRetrievedAccountingJSON.Id, False)
     FROM  tblRetrievedAccountingJSON
     WHERE isRetrievedAccounting = TRUE;
     
     PERFORM lpInsert_MovementProtocol (tblRetrievedAccountingJSON.Id, vbUserId, False)
     FROM  tblRetrievedAccountingJSON  
     WHERE COALESCE (tblRetrievedAccountingJSON.SummaReceivedFact, 0) > 0
        OR isRetrievedAccounting = TRUE;  
        
      -- Заполняем подразделение

     OPEN curTmp FOR SELECT tblRetrievedAccountingJSON.Id  
                          , tblRetrievedAccountingJSON.TotalSumm 
                     FROM tblRetrievedAccountingJSON 
                     ORDER BY tblRetrievedAccountingJSON.Id;
     LOOP
         FETCH curTmp INTO vbID, vbTotalSumm;
         IF NOT FOUND THEN EXIT; END IF;
         
         IF inSummaReceivedFact >= vbTotalSumm
         THEN
            PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_RetrievedAccounting(), vbID, TRUE);
            
            PERFORM lpInsert_MovementProtocol (vbID, vbUserId, False);
            
            inSummaReceivedFact := inSummaReceivedFact - vbTotalSumm;
            
         ELSEIF inSummaReceivedFact > 0 
         THEN
         
           PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), vbID, inSummaReceivedFact);
           
           PERFORM lpInsert_MovementProtocol (vbID, vbUserId, False);
            
           inSummaReceivedFact := 0;
           
           EXIT;

         ELSE
           EXIT;   
         END IF;


     END LOOP;
     CLOSE curTmp;        
        
        
  END IF;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 29.07.21                                                                    *
*/

-- тест 
select * from gpUpdate_Movement_Check_SummaReceivedFact(inSummaReceivedFact := 100 , inJson := '[{"id":24363804,"isretrievedaccounting":"False","totalsumm":306.2,"summareceivedfact":0},{"id":24254544,"isretrievedaccounting":"False","totalsumm":396,"summareceivedfact":0}]' ,  inSession := '3');


