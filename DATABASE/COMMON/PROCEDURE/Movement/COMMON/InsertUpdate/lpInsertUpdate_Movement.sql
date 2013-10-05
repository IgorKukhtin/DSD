CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement(
INOUT ioId Integer, 
IN inDescId Integer, 
IN inInvNumber TVarChar, 
IN inOperDate TDateTime,
IN inParentId Integer)
 AS
$BODY$

BEGIN
  IF COALESCE(ioId, 0) = 0 THEN
     INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, ParentId)
            VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId) RETURNING Id INTO ioId;
  ELSE
     IF (UPDATE Movement SET InvNumber = inInvNumber, OperDate = inOperDate WHERE Id = ioId
          RETURNING StatusId) <> zc_Enum_Status_Uncomplete() THEN
          RAISE EXCEPTION 'Можно редактировать документ только в статусе "Не проведен"';
     END IF;
     IF NOT found THEN
     INSERT INTO Movement (Id, DescId, InvNumber, OperDate, StatusId, ParentId)
            VALUES (ioId, inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId) RETURNING Id INTO ioId;
     END IF;
  END IF;
END;           $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_Movement(integer, integer, TVarChar, TDateTime, Integer)
  OWNER TO postgres; 