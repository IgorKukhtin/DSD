--DROP FUNCTION lpInsertUpdate_Object(INOUT ioId integer, IN inDescId integer, IN inObjectCode integer, IN inValueData tvarchar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object(
INOUT ioId integer, 
IN inDescId integer, 
IN inObjectCode integer, 
IN inValueData tvarchar)
 AS
$BODY$BEGIN
  IF COALESCE(ioId, 0) = 0 THEN
     /* вставить <ключ класса объекта> , <код объекта> , <данные>
        и вернуть значение <ключа> */
     INSERT INTO Object (DescId, ObjectCode, ValueData)
            VALUES (inDescId, inObjectCode, inValueData) RETURNING Id INTO ioId;
  ELSE
     /* изменить <код объекта> и <данные> по значению <ключа> */
     UPDATE Object SET ObjectCode = inObjectCode, ValueData = inValueData WHERE Id = ioId;
     IF NOT found THEN
       /* вставить <ключ класса объекта> , <код объекта> , <данные> со значением <ключа> */
       INSERT INTO Object (Id, DescId, ObjectCode, ValueData)
                    VALUES (ioId, inDescId, inObjectCode, inValueData);
     END IF;
  END IF;
END;           $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_Object(integer, integer, integer, tvarchar)
  OWNER TO postgres; 