-- Function: gpInsertUpdate_DefaultKey()

DROP FUNCTION IF EXISTS gpInsertUpdate_DefaultKey(TVarChar, TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_DefaultKey(Integer, TVarChar, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_DefaultKey(
 INOUT ioId          Integer   , 
    IN inKey         TVarChar  ,    -- Ключ
    IN inKeyData     TBlob     ,    -- Развернутые данные ключа
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS Integer 
  AS
$BODY$
BEGIN

  UPDATE DefaultKeys SET KeyData = inKeyData, Key = inKey WHERE Id = ioId;
  IF NOT FOUND THEN 
     INSERT INTO DefaultKeys(Key, KeyData) VALUES(inKey, inKeyData) RETURNING Id INTO ioId;
  END IF;
 
END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            