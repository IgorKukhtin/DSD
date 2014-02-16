-- Function: lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement (INOUT ioId Integer, IN inDescId Integer, IN inInvNumber tvarchar, IN inOperDate tdatetime, IN inParentId Integer, IN inAccessKeyId Integer DEFAULT NULL)
  RETURNS Integer AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN
  IF COALESCE (ioId, 0) = 0 THEN
     INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, ParentId, AccessKeyId)
            VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId, inAccessKeyId) RETURNING Id INTO ioId;
  ELSE
     --
     UPDATE Movement SET InvNumber = inInvNumber, OperDate = inOperDate, ParentId = inParentId/*, AccessKeyId = inAccessKeyId*/ WHERE Id = ioId
            RETURNING StatusId INTO vbStatusId;

     --
     IF vbStatusId <> zc_Enum_Status_UnComplete() AND COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     --
     IF vbStatusId = zc_Enum_Status_Complete() AND COALESCE (inParentId, 0) <> 0
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.13                                        * add inAccessKeyId
 07.12.13                                        * !!! add UPDATE Movement SET ... ParentId = inParentId ...
 31.10.13                                        * AND COALESCE (inParentId, 0) = 0
 06.10.13                                        * 1251Cyr
*/

-- ����
-- 
