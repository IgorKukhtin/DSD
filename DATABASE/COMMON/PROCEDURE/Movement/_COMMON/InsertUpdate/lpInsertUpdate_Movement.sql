-- Function: lpInsertUpdate_Movement (Integer, Integer, tvarchar, tdatetime, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement (
 INOUT ioId           Integer, 
    IN inDescId       Integer,
    IN inInvNumber    TVarChar,
    IN inOperDate     TDateTime,
    IN inParentId     Integer,
    IN inAccessKeyId  Integer DEFAULT NULL,
    IN inUserId       Integer DEFAULT 0 -- ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN

     -- ������ ��������
     IF inParentId = 0
     THEN
         inParentId := NULL;
     END IF;


     -- ��������
     IF COALESCE (inOperDate, zc_DateStart()) < '01.01.2015'
     THEN
         RAISE EXCEPTION '������.�������� ��������� � ����� <%> ����������.', zfConvert_DateToString (COALESCE (inOperDate, zc_DateStart()));
     END IF;


     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (NULL, NULL, ioId, NULL, NULL, inUserId);


     -- �������� - �������� �.�.
     IF inUserId IN (9031170) OR inDescId = zc_Movement_Cash()
        -- ����������� 7 ���� ��-�� (��������)
        OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  AS UserRole_View WHERE UserRole_View.UserId = inUserId AND UserRole_View.RoleId = 11841068)
     THEN
         PERFORM lpCheckPeriodClose_local (inOperDate, ioId, inDescId, inUserId);
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, StatusId_next, ParentId, AccessKeyId)
               VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), zc_Enum_Status_UnComplete(), inParentId, inAccessKeyId) RETURNING Id INTO ioId;
     ELSE
        --
        UPDATE Movement SET DescId = inDescId, InvNumber = inInvNumber, OperDate = inOperDate, ParentId = inParentId
                          , AccessKeyId = CASE WHEN inDescId = zc_Movement_OrderExternal() THEN inAccessKeyId ELSE AccessKeyId END
        WHERE Id = ioId
        RETURNING StatusId INTO vbStatusId;

        --
        IF vbStatusId <> zc_Enum_Status_UnComplete() AND COALESCE (inParentId, 0) = 0 AND ioId <> 24400262
        THEN
            RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> ����������.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
        END IF;
        --
        IF vbStatusId = zc_Enum_Status_Complete() AND COALESCE (inParentId, 0) <> 0 AND ioId <> 24400262
        THEN
            RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> ����������.', inInvNumber, lfGet_Object_ValueData (vbStatusId);
        END IF;

        --
        IF NOT FOUND
        THEN
            INSERT INTO Movement (Id, DescId, InvNumber, OperDate, StatusId, StatusId_next, ParentId, AccessKeyId)
                          VALUES (ioId, inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), zc_Enum_Status_UnComplete(), inParentId, inAccessKeyId) RETURNING Id INTO ioId;
        END IF;

        --
        IF ioId <=0
        THEN
            RAISE EXCEPTION '��������� ������.���� <%> <= 0. <%> � <%> �� <%>.'
                          , ioId
                          , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inDescId)
                          , inInvNumber
                          , zfConvert_DateToString (inOperDate)
                           ;
        END IF;


     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.14                                        * add inParentId
 23.08.14                                        * add inAccessKeyId
 07.12.13                                        * add inAccessKeyId
 07.12.13                                        * !!! add UPDATE Movement SET ... ParentId = inParentId ...
 31.10.13                                        * AND COALESCE (inParentId, 0) = 0
 06.10.13                                        * 1251Cyr
*/

-- ����
--
