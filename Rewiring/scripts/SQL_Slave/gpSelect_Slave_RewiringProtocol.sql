-- Function: _replica.gpSelect_Slave_RewiringProtocol()

DROP FUNCTION IF EXISTS _replica.gpSelect_Slave_RewiringProtocol (TVarChar);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Slave_RewiringProtocol (
  IN inSession   TVarChar
)
RETURNS TABLE (Id             Integer
             , MovementId     Integer
             , Transaction_Id BIGINT
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession::Integer;

   -- Результат
   RETURN QUERY 
   SELECT RewiringProtocol.Id
        , RewiringProtocol.MovementId
        , RewiringProtocol.Transaction_Id
   FROM _replica.RewiringProtocol 
   WHERE RewiringProtocol.isErrorRewiring = False
     AND RewiringProtocol.isProcessed = False
   ORDER BY Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-- SELECT * FROM _replica.gpSelect_Slave_RewiringProtocol (zfCalc_UserAdmin());
