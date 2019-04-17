-- Function: gpInsertUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, TFloat, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternalPromo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartSale             TDateTime  , -- ���� ������ ������
  --  IN inAmount                TFloat     , -- ����� ���-��
    IN inRetailId              Integer    , -- �������� ����
    IN inComment               TVarChar   , -- ����������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternalPromo());
    vbUserId := inSession;
    
    -- ������� ����� ���-��
    vbAmount := COALESCE ( (SELECT SUM(MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = ioId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = FALSE) , 0) :: TFloat;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_OrderInternalPromo (ioId            := ioId
                                                      , inInvNumber     := inInvNumber
                                                      , inOperDate      := inOperDate
                                                      , inStartSale     := inStartSale
                                                      , inAmount        := vbAmount
                                                      , inRetailId      := inRetailId
                                                      , inComment       := inComment
                                                      , inUserId        := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.19         *
*/