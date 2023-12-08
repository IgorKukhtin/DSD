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
                                                , inComment
                                                , vbUserId
                                                );


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.02.21         *
*/

-- ����
--