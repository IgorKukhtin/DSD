-- Function: gpInsertUpdate_MovementItem_PersonalTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalTransport (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalTransport(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ���������� 
    IN inInfoMoneyId           Integer   , -- ������ ����������
    IN inUnitId                Integer   , -- �������������
    IN inPositionId            Integer   , -- ���������
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalTransport());

     -- ���������
     ioId := lpInsertUpdate_MovementItem_PersonalTransport (ioId          := ioId
                                                          , inMovementId  := inMovementId
                                                          , inPersonalId  := inPersonalId 
                                                          , inInfoMoneyId := inInfoMoneyId
                                                          , inUnitId      := inUnitId
                                                          , inPositionId  := inPositionId 
                                                          , inAmount      := inAmount
                                                          , inComment     := inComment
                                                          , inUserId      := vbUserId
                                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.08.22         *
*/

-- ����
--