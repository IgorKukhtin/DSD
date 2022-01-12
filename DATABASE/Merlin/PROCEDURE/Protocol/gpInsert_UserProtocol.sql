DROP FUNCTION IF EXISTS gpInsert_UserProtocol(TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_UserProtocol(
      IN inProtocolData          TBlob, 
      IN inSession               TVarChar)
RETURNS void
AS $BODY$
   DECLARE vbUserId Integer;
BEGIN

  vbUserId := lpGetUserBySession (inSession);

  INSERT INTO UserProtocol (UserId, OperDate, ProtocolData)
       SELECT vbUserId, current_timestamp, inProtocolData;
  
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsert_UserProtocol(TBlob, TVarChar)
  OWNER TO postgres; 