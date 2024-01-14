-- Function: gpInsertUpdate_MovementItem_Invoice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_BankAccount_Child (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_BankAccount_Child(
 INOUT ioId                  Integer   , -- ���� ������� <> 
    IN inParentId            Integer   ,
    IN inMovementId          Integer   , 
    IN inMovementId_invoice  Integer   , -- 
    IN inObjectId            Integer   , -- 
    IN inAmount              TFloat    , -- 
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Invoice());
     vbUserId := lpGetUserBySession (inSession);

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MI_BankAccount_Child (ioId
                                                , inParentId
                                                , inMovementId
                                                , inMovementId_invoice
                                                , inObjectId
                                                , inAmount
                                                , inComment
                                                , vbUserId
                                                 );

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.24         *
*/

-- ����
--