-- Function: lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement (Integer, Integer, TVarChar, TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement (
 INOUT ioId        Integer   , --
    IN inDescId    Integer   , --
    IN inInvNumber TVarChar  , --
    IN inOperDate  TDateTime , --
    IN inParentId  Integer   , --
    IN inUserId    Integer     -- 
  )
RETURNS Integer
AS
$BODY$
  DECLARE vbStatusId Integer;
  DECLARE vbDescId   Integer;
BEGIN
     -- ��������
     IF inOperDate <> DATE_TRUNC('DAY', inOperDate) THEN
        RAISE EXCEPTION '������.inOperDate = <%>', inOperDate;
     END IF;

     -- ��������
     IF inOperDate < DATE_TRUNC ('YEAR', CURRENT_DATE - INTERVAL '3 YEAR')
     THEN
        RAISE EXCEPTION '������.���� = <%>', inOperDate;
     END IF;


     -- ������ ��������
     IF inParentId = 0
     THEN
         inParentId := NULL;
     END IF;


     IF COALESCE (ioId, 0) = 0 THEN
        INSERT INTO Movement (DescId, InvNumber, OperDate, StatusId, ParentId)
                      VALUES (inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId)
                      RETURNING Id INTO ioId;
     ELSE
        --
        UPDATE Movement SET InvNumber = inInvNumber
                          , OperDate  = inOperDate
                          , ParentId  = inParentId
                       -- , DescId    = inDescId
        WHERE Id = ioId
        RETURNING StatusId, DescId INTO vbStatusId, vbDescId
       ;

        -- ��������
        IF vbStatusId <> zc_Enum_Status_UnComplete() THEN
           RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', inInvNumber, lfGet_Object_ValueData_sh (vbStatusId);
        END IF; 
        
        -- ��������
        IF vbStatusId = zc_Enum_Status_Complete() THEN
           RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', inInvNumber, lfGet_Object_ValueData_sh (vbStatusId);
        END IF;

        -- ���� ����� ������� �� ��� ������
        IF NOT FOUND THEN
           -- ������
           RAISE EXCEPTION '������. ��������� �������� ������ � ������������ ������ <%>', ioId;
           --
           INSERT INTO Movement (Id, DescId, InvNumber, OperDate, StatusId, ParentId)
                         VALUES (ioId, inDescId, inInvNumber, inOperDate, zc_Enum_Status_UnComplete(), inParentId)
                         RETURNING Id INTO ioId;
        END IF;

        -- �������� - �.�. DescId - !!!�� ��������!!!
        IF COALESCE (inDescId, -1) <> COALESCE (vbDescId, -2)
        THEN
            RAISE EXCEPTION '������ ��������� DescId � <%>(<%>) �� <%>(<%>)', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), vbDescId
                                                                            , (SELECT ItemName FROM MovementDesc WHERE Id = inDescId), inDescId
                                                                             ;
        END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 09.06.17                                                       *  add inUserId
 05.06.17                                        * all
*/

-- ����
--
