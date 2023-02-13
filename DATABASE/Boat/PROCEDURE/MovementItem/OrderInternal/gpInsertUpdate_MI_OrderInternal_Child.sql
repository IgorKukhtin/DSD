-- Function: gpInsertUpdate_MI_OrderInternal_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderInternal_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderInternal_Child(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inObjectId               Integer   , -- ������������� 
    IN inReceiptLevelId         Integer   , -- ���� ������
    IN inColorPatternId         Integer   , -- ������ Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- �����
    IN inUnitId                 Integer   , -- ����� �����
    IN inAmount                 TFloat    , -- ���������� (������ ������)
    IN inAmountReserv           TFloat    , -- ���������� ������
    IN inAmountSend             TFloat    , -- ���-�� ������ �� �������./�����������
    IN inForCount               TFloat    , -- ��� ���-��
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := lpGetUserBySession (inSession);


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MI_OrderInternal_Child (ioId                := ioId
                                               , inParentId          := inParentId
                                               , inMovementId        := inMovementId
                                               , inObjectId          := inObjectId
                                               , inReceiptLevelId    := inReceiptLevelId
                                               , inColorPatternId    := inColorPatternId
                                               , inProdColorPatternId:= inProdColorPatternId
                                               , inProdOptionsId     := inProdOptionsId
                                               , inUnitId            := inUnitId
                                               , inAmount            := inAmount
                                               , inAmountReserv      := inAmountReserv
                                               , inAmountSend        := inAmountSend
                                               , inForCount          := inForCount
                                               , inUserId            := vbUserId
                                                ) AS tmp;

     -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.02.23         *
*/

-- ����
-- SELECT * FROM 