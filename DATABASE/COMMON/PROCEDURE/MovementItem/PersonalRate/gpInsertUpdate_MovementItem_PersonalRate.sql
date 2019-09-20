-- Function: gpInsertUpdate_MovementItem_PersonalRate()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalRate (Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalRate (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalRate(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalRate());

     -- ���������
     ioId := lpInsertUpdate_MovementItem_PersonalRate (ioId                    := ioId
                                                     , inMovementId            := inMovementId
                                                     , inPersonalId            := inPersonalId
                                                     , inAmount                := inAmount
                                                     , inComment               := inComment
                                                     , inUserId                := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.19         *
*/

-- ����
--