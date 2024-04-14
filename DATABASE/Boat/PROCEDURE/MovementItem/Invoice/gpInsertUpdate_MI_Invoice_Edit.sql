-- Function: gpInsertUpdate_MI_Invoice_Edit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Invoice_Edit (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Invoice_Edit(
 INOUT ioId                  Integer   , -- ���� ������� <>
    IN inMovementId          Integer   , -- ���� ������� <>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inOperPrice           TFloat    , --
    IN inSummMVAT            TFloat    , --
    IN inSummPVAT            TFloat    , --     
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbIsInsert          Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem_Invoice (ioId
                                                , inMovementId
                                                , inGoodsId
                                                , inAmount
                                                , inOperPrice 
                                                , inSummMVAT
                                                , inSummPVAT
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
*/

-- ����
--