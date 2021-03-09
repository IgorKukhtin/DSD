-- Function: gpInsertUpdate_MovementItem_ProfitLossResult()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProfitLossResult (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProfitLossResult(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inAccountId             Integer   , -- ������
    IN inContainerId           TFloat    , -- ������ ��
    IN inAmount                TFloat    , -- ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ProfitLossResult());

     -- ���������
     ioId := lpInsertUpdate_MovementItem_ProfitLossResult (ioId          := ioId
                                                         , inMovementId  := inMovementId
                                                         , inAccountId   := inAccountId
                                                         , inAmount      := inAmount
                                                         , inContainerId := inContainerId
                                                         , inUserId      := vbUserId
                                                          ) ;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.03.21         *
*/

-- ����
--