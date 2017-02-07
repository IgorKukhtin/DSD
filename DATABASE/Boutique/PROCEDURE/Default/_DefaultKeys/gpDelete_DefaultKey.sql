-- Function: gpDelete_DefaultKey(integer, tvarchar)

-- DROP FUNCTION gpDelete_DefaultKey(tvarchar, tvarchar);

CREATE OR REPLACE FUNCTION gpDelete_DefaultKey(
IN inKey   TVarChar, 
IN Session TVarChar)
  RETURNS void AS
$BODY$
BEGIN

  DELETE FROM DefaultValue WHERE DefaultKeyId in (SELECT Id FROM DefaultKeys WHERE Key = inKey);

  DELETE FROM DefaultKeys WHERE Key = inKey;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpDelete_DefaultKey(tvarchar, tvarchar) OWNER TO postgres;