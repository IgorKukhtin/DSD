-- Function: gpInsertUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ProductionUnion_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ProductionUnion_Child(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inObjectId               Integer   , -- �������������
    IN inReceiptLevelId         Integer   , -- ���� ������
    IN inColorPatternId         Integer   , -- ������ Boat Structure 
    IN inProdColorPatternId     Integer   , -- Boat Structure  
    IN inProdOptionsId          Integer   , -- �����
    IN inAmount                 TFloat    , -- ���������� ������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MI_ProductionUnion_Child (ioId                := ioId
                                                 , inParentId          := inParentId
                                                 , inMovementId        := inMovementId
                                                 , inObjectId          := inObjectId
                                                 , inReceiptLevelId    := inReceiptLevelId
                                                 , inColorPatternId    := inColorPatternId
                                                 , inProdColorPatternId:= inProdColorPatternId
                                                 , inProdOptionsId     := inProdOptionsId
                                                 , inAmount            := inAmount
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
 12.07.21         *
*/

-- ����
--