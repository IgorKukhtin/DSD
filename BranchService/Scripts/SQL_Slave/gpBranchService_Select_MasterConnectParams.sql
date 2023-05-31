-- Function: _replica.gpBranchService_Select_MasterConnectParams (TVarChar)

DROP FUNCTION IF EXISTS _replica.gpBranchService_Select_MasterConnectParams (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpBranchService_Select_MasterConnectParams(
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE (Host         TVarChar
             , DBName       TVarChar
             , Port         Integer
             , UserName     TVarChar
             , Password     TVarChar
             , UserNameUpd  TVarChar
             , PasswordUpd  TVarChar
             , UserSlaveUpd TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession::Integer;

   -- Результат
   RETURN QUERY 
     SELECT '%s'::TVarChar             AS Host
          , '%s'::TVarChar             AS DBName
          , %s                         AS Port
          , '%s'::TVarChar             AS UserName
          , '%s'::TVarChar             AS Password
          , '%s'::TVarChar             AS UserNameUpd
          , '%s'::TVarChar             AS PasswordUpd
          , '%s'::TVarChar             AS UserSlaveUpd;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.23                                                       * 
*/ 

