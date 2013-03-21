CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement(
INOUT ioId integer, 
IN inDescId integer, 
IN inInvNumber tvarchar, 
IN inOperDate TDateTime)
 AS
$BODY$BEGIN
  IF COALESCE(ioId, 0) = 0 THEN
     INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId)
            VALUES (inDescId, inInvNumber, inOperDate, zc_Object_Status_UnComplete()) RETURNING Id INTO ioId;
  ELSE
     UPDATE Movement SET InvNumber = inInvNumber, OperDate = inOperDate WHERE Id = ioId;
     IF NOT found THEN
     INSERT INTO Movement (Id, DescId, InvNumber, OperDate, StatusId)
            VALUES (ioId, inDescId, inInvNumber, inOperDate, zc_Object_Status_UnComplete()) RETURNING Id INTO ioId;
     END IF;
  END IF;
END;           $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_Object(integer, integer, integer, tvarchar)
  OWNER TO postgres; 