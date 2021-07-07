-- Function: gpInsertUpdate_MovementItem_TestingTuning()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TestingTuning (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TestingTuning(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inTopicsTestingTuningId Integer   , -- ���� ������������ �����������
    IN inTestQuestions         Integer   , -- ���������� �������� �� ���� ��� �����
    IN inSession               TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession::Integer;

     -- ��������� ������ ����������� � ������� ������    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��� ��������� �������� ��������� ������������';
    END IF;

    --��������� �� ������������ ���-��
    IF (inTestQuestions <= 0)
    THEN
      RAISE EXCEPTION '������. ���������� �������� �� ���� <%> �� ����� ���� ������ ��� ����� ����.', inTestQuestions;
    END IF;    

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inTopicsTestingTuningId, inMovementId, inTestQuestions, NULL);

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_TestingTuning (Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 06.07.21                                                                     *  
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_TestingTuning(ioId := 0 , inMovementId := 23977600 , inTopicsTestingTuningId := 17419465 , inTestQuestions := 2 ,  inSession := '3');