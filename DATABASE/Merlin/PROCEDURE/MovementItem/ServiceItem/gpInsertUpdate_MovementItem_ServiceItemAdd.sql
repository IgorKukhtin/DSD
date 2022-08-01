-- Function: gpInsertUpdate_MovementItem_ServiceItem()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItem (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ServiceItem(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- ����� 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
    IN inDateEnd             TDateTime , --
    IN inAmount              TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inArea                TFloat    , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItem());

     ioId:= lpInsertUpdate_MovementItem_ServiceItem (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inUnitId             := inUnitId
                                                   , inInfoMoneyId        := inInfoMoneyId
                                                   , inCommentInfoMoneyId := inCommentInfoMoneyId
                                                   , inDateEnd            := inDateEnd
                                                   , inAmount             := inAmount
                                                   , inPrice              := inPrice
                                                   , inArea               := inArea
                                                   , inUserId             := vbUserId
                                                    );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         *
*/

-- ����
--