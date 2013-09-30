-- Function: gpInsertUpdate_DefaultValue()

-- DROP FUNCTION gpInsertUpdate_DefaultValue();

CREATE OR REPLACE FUNCTION gpInsertUpdate_DefaultValue(
    IN inDefaultKey      TVarChar   ,   -- Ключ дефолта
    IN inUserKey         Integer   ,    -- Ключ 
    IN inDefaultValue    TBlob     ,    -- Данные дефолта
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS void 
  AS
$BODY$
  DECLARE vbDefaultKeyId Integer;
BEGIN
  vbDefaultKeyId := (SELECT Id FROM DefaultKeys WHERE Key = inDefaultKey);

  UPDATE DefaultValue SET DefaultValue = inDefaultValue WHERE DefaultKeyId = vbDefaultKeyId AND UserKeyId = inUserKey;
  IF NOT FOUND THEN 
     INSERT INTO DefaultValue(DefaultKeyId, UserKeyId, DefaultValue) VALUES(vbDefaultKeyId, inUserKey, inDefaultValue);
  END IF;
 
END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            