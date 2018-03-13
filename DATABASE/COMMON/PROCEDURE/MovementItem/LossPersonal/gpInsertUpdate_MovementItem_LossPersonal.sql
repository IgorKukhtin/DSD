-- Function: gpInsertUpdate_MovementItem_LossPersonal ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossPersonal (Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossPersonal(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ���������
    IN inPersonalId             Integer   , -- ��������� 
    IN inAmount                 TFloat    , -- ����� �������������
    IN inBranchId              Integer   , -- ������
    IN inInfoMoneyId            Integer   , -- ������ ����������
    IN inPositionId             Integer   , -- ���������
    IN inPersonalServiceListId  Integer   , -- ��������� ����������
    IN inUnitId                 Integer   , -- �������������
    IN inComment                TVarChar  , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossPersonal());

    -- ��������� <������� ���������>
     ioId:= lpInsertUpdate_MovementItem_LossPersonal (ioId                    := ioId
                                                    , inMovementId            := inMovementId
                                                    , inPersonalId            := inPersonalId
                                                    , inAmount                := inAmount
                                                    , inBranchId              := inBranchId
                                                    , inInfoMoneyId           := inInfoMoneyId
                                                    , inPositionId            := inPositionId
                                                    , inPersonalServiceListId := inPersonalServiceListId
                                                    , inUnitId                := inUnitId
                                                    , inComment               := inComment
                                                    , inUserId                := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.02.18         *
*/

-- ����
-- 