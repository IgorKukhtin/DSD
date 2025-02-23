-- Function: gpInsertUpdate_MovementItem_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Invoice (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Invoice(
 INOUT ioId                  Integer   , -- ���� ������� <>
    IN inMovementId          Integer   , -- ���� ������� <>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inOperPrice           TFloat    , --
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIsInsert          Boolean;
   DECLARE vbSummMVAT          TFloat;
           vbSummPVAT          TFloat;
           vbVATPercent        TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     --
     vbVATPercent := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_VATPercent());
     vbSummMVAT := (COALESCE (inAmount,0) * COALESCE (inOperPrice, 0));
     vbSummPVAT := zfCalc_SummWVAT_4 ((COALESCE (inAmount,0) * COALESCE (inOperPrice, 0)) ::TFloat, vbVATPercent);

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_Invoice (ioId
                                                , inMovementId
                                                , inGoodsId
                                                , inAmount
                                                , inOperPrice 
                                                , vbSummMVAT
                                                , vbSummPVAT
                                                , inComment
                                                , vbUserId
                                                );


     --����������� ����� � ��� ��������� � ���������� � zc_MovementFloat_Amount
     PERFORM lpInsertUpdate_Movement_Invoice_Amount (inMovementId, vbUserId);
     
     -- ����������� �������� ����� �� ���������
     --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.04.24         *
 08.02.21         *
*/

-- ����
--