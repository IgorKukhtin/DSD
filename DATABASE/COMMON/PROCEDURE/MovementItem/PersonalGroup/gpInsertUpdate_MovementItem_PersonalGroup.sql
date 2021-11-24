-- Function: gpInsertUpdate_MovementItem_PersonalGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalGroup(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inAmount                TFloat    , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroup());

     --��������   ����� ������ inAmount �� �� ������ ��� ���� ��������
     IF COALESCE (ioId,0) <> 0
     THEN
         vbAmount := (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId);
         IF COALESCE (inAmount,0) > COALESCE (vbAmount,0) AND COALESCE (vbAmount,0) <> 0
         THEN
             RAISE EXCEPTION '������.������� ���� �� ����� ��������� <%>', vbAmount;
         END IF;
     END IF;
     
     
     
     -- ���������
     ioId := lpInsertUpdate_MovementItem_PersonalGroup (ioId             := ioId
                                                      , inMovementId      := inMovementId
                                                      , inPersonalId      := inPersonalId
                                                      , inPositionId      := inPositionId
                                                      , inPositionLevelId := inPositionLevelId
                                                      , inAmount          := inAmount
                                                      , inUserId          := vbUserId
                                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
--