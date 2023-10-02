-- Function: gpRewiring_Slave_SendMovement (TVarChar, TVarChar)

DROP FUNCTION IF EXISTS _replica.gpRewiring_Slave_SendMovement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpRewiring_Slave_SendMovement(
    IN inId              Integer   , --
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, Error Text) 
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
      
   DECLARE vbMovementId Integer;
   DECLARE vbTransaction_Id BIGINT;
   DECLARE vbisComplete Boolean;

   DECLARE text_var1   Text;
   DECLARE text_var2   Text;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= inSession::Integer;

   SELECT Host, DBName, Port, UserName, Password
   INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
   FROM _replica.gpSelect_MasterConnectParams(inSession);  

   SELECT RewiringProtocol.MovementId
        , RewiringProtocol.Transaction_Id
   INTO vbMovementId, vbTransaction_Id
   FROM _replica.RewiringProtocol 
   WHERE RewiringProtocol.Id = inId
     AND RewiringProtocol.isErrorRewiring = False
     AND RewiringProtocol.isProcessed = False;
        
   -- !!!проверка!!!
   IF COALESCE (vbMovementId, 0) = 0
   THEN
       RAISE EXCEPTION 'NOT FIND, RewiringProtocol.Id = %', inId;
   END IF;
                     
   vbisComplete := False;
   
   BEGIN
   
     PERFORM Q.Id
     FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                 'SELECT Id
                  FROM _replica.gpRewiring_Master_LoadMovement(inMovementId := '||vbMovementId::TEXT||',
                         inTransaction_Id := '||vbTransaction_Id::TEXT||',
                         inSession := '''||inSession||''')') AS 
                   q(Id Integer);  
     
     vbisComplete := True;

   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT, text_var2 = PG_EXCEPTION_DETAIL;
   END;
   

   -- Отметили что загрузили
   UPDATE _replica.RewiringProtocol SET isProcessed = TRUE
                                      , DateProcessed = CURRENT_TIMESTAMP 
                                      , isErrorRewiring = NOT vbisComplete
                                      , ErrorData = 'Ошибка отправки. '||text_var1||COALESCE('; '||text_var2, '')
   WHERE RewiringProtocol.Id = inId;

      -- Результат
   RETURN QUERY
   SELECT inId AS Id, text_var1||COALESCE('; '||text_var2, '');
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.23                                                       * 
*/

-- Тест

-- select * from _replica.gpRewiring_Slave_SendMovement(inId := 62, inSession:= zfCalc_UserAdmin());