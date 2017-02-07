-- Function: gpInsertUpdate_DefaultValue()

DROP FUNCTION IF EXISTS gpInsertUpdate_DefaultValue(Integer, Integer, Integer, TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_DefaultValue(Integer, Integer, TBlob, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_DefaultValue(TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_DefaultValue(
 INOUT ioId              Integer   , 
    IN inDefaultKeyId    Integer   ,    -- Ключ дефолта
    IN inUserKey         Integer   ,    -- Ключ 
    IN inDefaultValue    TBlob     ,    -- Данные дефолта
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS Integer 
  AS
$BODY$
BEGIN
  
  IF COALESCE(inUserKey, 0) = 0 THEN
    inUserKey := NULL;
  END IF;

  UPDATE DefaultValue SET DefaultValue = inDefaultValue, DefaultKeyId = inDefaultKeyId, UserKeyId = inUserKey WHERE Id = ioId;
  IF NOT FOUND THEN 
     INSERT INTO DefaultValue(DefaultKeyId, UserKeyId, DefaultValue) VALUES(inDefaultKeyId, inUserKey, inDefaultValue) RETURNING Id INTO ioId;
  END IF;
 
END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            