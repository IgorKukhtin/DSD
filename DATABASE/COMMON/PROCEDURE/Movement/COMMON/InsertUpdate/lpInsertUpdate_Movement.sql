-- Function: lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer)

-- DROP FUNCTION lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement (INOUT ioId Integer, IN inDescId Integer, IN inInvNumber tvarchar, IN inOperDate tdatetime, IN inParentId Integer)
  RETURNS Integer AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN
  IF COALESCE(ioId, 0) = 0 THEN
     INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, ParentId)
            VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId) RETURNING Id INTO ioId;
  ELSE
     --
     UPDATE Movement SET InvNumber = inInvNumber, OperDate = inOperDate WHERE Id = ioId
            RETURNING StatusId INTO vbStatusId;

     --
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
     END IF;

     --
     IF NOT FOUND
     THEN
         INSERT INTO Movement (Id, DescId, InvNumber, OperDate, StatusId, ParentId)
                       VALUES (ioId, inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId) RETURNING Id INTO ioId;
     END IF;

  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Movement(Integer, Integer, tvarchar, tdatetime, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.10.13                                        * 1251Cyr
*/

-- тест
-- 
