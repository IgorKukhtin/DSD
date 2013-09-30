-- Function: gpInsertUpdate_DefaultKey()

-- DROP FUNCTION gpInsertUpdate_DefaultKey();

CREATE OR REPLACE FUNCTION gpInsertUpdate_DefaultKey(
    IN inKey         TVarChar  ,    -- Ключ
    IN inKeyData     TBlob     ,    -- Развернутые данные ключа
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS void 
  AS
$BODY$
BEGIN

  UPDATE DefaultKeys SET KeyData = inKeyData WHERE Key = inKey;
  IF NOT FOUND THEN 
     INSERT INTO DefaultKeys(Key, KeyData) VALUES(inKey, inKeyData);
  END IF;
 
END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            