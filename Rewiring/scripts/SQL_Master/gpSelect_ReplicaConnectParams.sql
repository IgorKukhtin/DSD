-- Function: _replica.gpSelect_ReplicaConnectParams()

DROP FUNCTION IF EXISTS _replica.gpSelect_ReplicaConnectParams (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_ReplicaConnectParams (
  IN inSession   TVarChar
)
RETURNS TABLE (
  Host          TVarChar,
  DBName        TVarChar,
  Port          Integer,
  UserName      TVarChar,
  Password      TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession::Integer;

   -- Результат
   RETURN QUERY 
     SELECT '%s'::TVarChar            AS Host
          , '%s'::TVarChar            AS DBName
          , %s                        AS Port
          , '%s'::TVarChar            AS UserName
          , '%s'::TVarChar            AS Password;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- 
SELECT * FROM _replica.gpSelect_ReplicaConnectParams (zfCalc_UserAdmin());