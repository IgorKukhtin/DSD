-- Function: lpinsertupdate_movement(integer, integer, tvarchar, tdatetime, integer)

-- DROP FUNCTION lpinsertupdate_movement(integer, integer, tvarchar, tdatetime, integer);

CREATE OR REPLACE FUNCTION lpinsertupdate_movement(INOUT ioid integer, IN indescid integer, IN ininvnumber tvarchar, IN inoperdate tdatetime, IN inparentid integer)
  RETURNS integer AS
$BODY$
DECLARE  vbStatusId INTEGER;
BEGIN
  IF COALESCE(ioId, 0) = 0 THEN
     INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, ParentId)
            VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId) RETURNING Id INTO ioId;
  ELSE
     UPDATE Movement SET InvNumber = inInvNumber, OperDate = inOperDate WHERE Id = ioId
          RETURNING StatusId INTO vbStatusId;
     IF vbStatusId <> zc_Enum_Status_Uncomplete() THEN
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
ALTER FUNCTION lpinsertupdate_movement(integer, integer, tvarchar, tdatetime, integer)
  OWNER TO postgres;
