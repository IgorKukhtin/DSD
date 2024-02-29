-- Function: gpInsertUpdate_MovementItem_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalGroupSummAdd (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalGroupSummAdd(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPositionId            Integer   , -- 
    IN inPositionLevelId       Integer   , --
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroupSummAdd());

     -- ���������
     ioId := lpInsertUpdate_MovementItem_PersonalGroupSummAdd (ioId              := ioId
                                                             , inMovementId      := inMovementId
                                                             , inPositionId      := inPositionId 
                                                             , inPositionLevelId := inPositionLevelId
                                                             , inAmount          := inAmount
                                                             , inComment         := inComment
                                                             , inUserId          := vbUserId
                                                              ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.02.24         *
*/

-- ����
--