-- Function: _replica.gpSelect_MasterConnectParams()

DROP FUNCTION IF EXISTS _replica.gpSelect_MasterConnectParams (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_MasterConnectParams (
  IN inSession   TVarChar
)
RETURNS TABLE (
  Host          TVarChar,
  DBName        TVarChar,
  Port          Integer,
  UserName      TVarChar,
  Password      TVarChar,
  UserNameRC    TVarChar,
  PasswordRC    TVarChar
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
          , '%s'::TVarChar            AS Password
          , '%s'::TVarChar            AS UserNameRC
          , '%s'::TVarChar            AS PasswordRC;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- SELECT * FROM _replica.gpSelect_MasterConnectParams (zfCalc_UserAdmin());