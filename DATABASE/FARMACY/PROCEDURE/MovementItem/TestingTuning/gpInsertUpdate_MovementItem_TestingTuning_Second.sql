-- Function: gpInsertUpdate_MovementItem_TestingTuning_Second()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TestingTuning_Second (Integer, Integer, Integer, Boolean, TBLOB, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Second(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ���� ������� <��������>
    IN inisCorrectAnswer       Boolean   , -- ���������� �����
    IN inPossibleAnswer        TBLOB     , -- ������� ������
    IN inisPhoto               Boolean   , -- ���� �����
    IN inSession               TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_lTestingTuning);
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession::Integer;

     -- ��������� ������ ����������� � ������� ������    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_TestingTuning()))
    THEN
      RAISE EXCEPTION '��� ��������� �������� ��������� ������������';
    END IF;

    --��������� �� ������������ ���-��
    IF COALESCE(inMovementId, 0) = 0 or COALESCE(inParentId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �� �������� ��������.';
    END IF;    


    --��������� �� ������������ ���-��
    IF COALESCE(inPossibleAnswer, '') = ''
    THEN
      RAISE EXCEPTION '������. �� �������� ������.';
    END IF;    

    --��������� �� ������������ ���-��
    IF (SELECT count(*)
        FROM MovementItem 
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ParentId = inParentId
          AND MovementItem.DescId = zc_MI_Second()) >= 4
       AND COALESCE(ioId, 0) = 0 
    THEN
      RAISE EXCEPTION '������. ��������� ������� ������ ���� �� ����� 4.';
    END IF;    
    
    IF inisCorrectAnswer = TRUE 
       AND EXISTS(SELECT 1
                  FROM MovementItem 
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.ParentId = inParentId
                    AND MovementItem.DescId = zc_MI_Second()
                    AND MovementItem.Amount <> 0
                    AND MovementItem.Id <> COALESCE(ioId, 0))
    THEN
      UPDATE MovementItem SET Amount = 0
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.ParentId = inParentId
        AND MovementItem.DescId = zc_MI_Second()
        AND MovementItem.Amount <> 0
        AND MovementItem.Id <> COALESCE(ioId, 0);
    END IF;

    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Second(), Null, inMovementId, CASE WHEN inisCorrectAnswer = TRUE THEN 1 ELSE 0 END , inParentId);

    -- ��������� �������� <������� ������>
    PERFORM lpInsertUpdate_MovementItemBLOB (zc_MIBLOB_PossibleAnswer(), ioId, inPossibleAnswer);

    -- ��������� �������� <���� �����>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Photo(), ioId, inisPhoto);

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSummTestingTuning (inMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_TestingTuning_Second (Integer, Integer, Integer, Boolean, TBLOB, Boolean, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 06.07.21                                                                     *  
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_TestingTuning_Second(ioId := 0 , inMovementId := 23977600 , inParentId := 440869114 , inisCorrectAnswer := 'True' , inPossibleAnswer := ' ��� ������ Z- �������.' ,  inSession := '3');