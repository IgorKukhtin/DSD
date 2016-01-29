-- Function: gpUpdate_MI_TaxCorrective_AmountSign (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_TaxCorrective_AmountSign (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_TaxCorrective_AmountSign(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TaxCorrective());

     -- ���������
     PERFORM lpInsertUpdate_MovementItem (ioId           := MovementItem.Id
                                        , inDescId       := zc_MI_Master()
                                        , inObjectId     := MovementItem.ObjectId
                                        , inMovementId   := inMovementId
                                        , inAmount       := -1 * MovementItem.Amount
                                        , inParentId     := NULL)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE;
       
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.12.15         * 
*/

-- ����
-- SELECT * FROM gpUpdate_MI_TaxCorrective_AmountSign
