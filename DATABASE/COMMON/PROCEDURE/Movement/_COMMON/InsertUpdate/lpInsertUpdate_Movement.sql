-- Function: lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement (INOUT ioId Integer, IN inDescId Integer, IN inInvNumber tvarchar, IN inOperDate tdatetime, IN inParentId Integer, IN inAccessKeyId Integer DEFAULT NULL)
  RETURNS Integer AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN

     -- меняем параметр
     IF inParentId = 0
     THEN
         inParentId := NULL;
     END IF;


     -- Проверка
     IF COALESCE (inOperDate, zc_DateStart()) < '01.01.2015'
     THEN
         RAISE EXCEPTION 'Ошибка.Создание документа с датой <%> невозможно.', zfConvert_DateToString (COALESCE (inOperDate, zc_DateStart()));
     END IF;


  IF COALESCE (ioId, 0) = 0 THEN
     INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, ParentId, AccessKeyId)
            VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId, inAccessKeyId) RETURNING Id INTO ioId;
  ELSE
     --
     UPDATE Movement SET DescId = inDescId, InvNumber = inInvNumber, OperDate = inOperDate, ParentId = inParentId
                       , AccessKeyId = CASE WHEN inDescId = zc_Movement_OrderExternal() THEN inAccessKeyId ELSE AccessKeyId END
     WHERE Id = ioId
     RETURNING StatusId INTO vbStatusId;

     --
     IF vbStatusId <> zc_Enum_Status_UnComplete() AND COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> невозможно.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     --
     IF vbStatusId = zc_Enum_Status_Complete() AND COALESCE (inParentId, 0) <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> невозможно.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     --
     IF NOT FOUND
     THEN
         INSERT INTO Movement (Id, DescId, InvNumber, OperDate, StatusId, ParentId, AccessKeyId)
                       VALUES (ioId, inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId, inAccessKeyId) RETURNING Id INTO ioId;
     END IF;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Movement(Integer, Integer, tvarchar, tdatetime, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.14                                        * add inParentId
 23.08.14                                        * add inAccessKeyId
 07.12.13                                        * add inAccessKeyId
 07.12.13                                        * !!! add UPDATE Movement SET ... ParentId = inParentId ...
 31.10.13                                        * AND COALESCE (inParentId, 0) = 0
 06.10.13                                        * 1251Cyr
*/

-- тест
-- 
