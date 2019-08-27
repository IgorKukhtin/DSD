-- Function: gpInsertUpdate_MovementItem_Wages_Summa()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Wages_Summa(INTEGER, INTEGER, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Wages_Summa(
    IN ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAmountCard          TFloat    , -- �� �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (ioId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� ��������.';
    END IF;

     -- ��������� �������� <�� �����>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountCard(), ioId, inAmountCard);
    --
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.19                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Wages_Summa (, inSession:= '2')

