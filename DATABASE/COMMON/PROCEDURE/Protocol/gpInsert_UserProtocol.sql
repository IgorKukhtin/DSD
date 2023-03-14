DROP FUNCTION IF EXISTS gpInsert_UserProtocol(TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_UserProtocol(
      IN inProtocolData          TBlob, 
      IN inSession               TVarChar)
RETURNS void
AS $BODY$
   DECLARE vbUserId Integer;
BEGIN
  --
  vbUserId := lpGetUserBySession (inSession);

  IF (SELECT COUNT(*) FROM pg_stat_activity WHERE state ILIKE 'active') < 15
--IF 1=1
  THEN
    -- Протокол пользователя - ошибки raise error и т.п.
    INSERT INTO UserProtocol (UserId, OperDate, ProtocolData)
         SELECT vbUserId, current_timestamp, inProtocolData;
  END IF;
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsert_UserProtocol(TBlob, TVarChar)
  OWNER TO postgres; 