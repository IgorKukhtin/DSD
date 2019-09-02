-- Function: gpInsertUpdate_MovementItem_WagesAdditionalExpenses()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesAdditionalExpenses(Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesAdditionalExpenses(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitID              Integer   , -- �������������
    IN inSummaCleaning       TFloat    , -- ������
    IN inSummaSP             TFloat    , -- ��
    IN inSummaOther          TFloat    , -- ������
    IN inisIssuedBy          Boolean   , -- ������
    IN inComment             TVarChar  , -- ����������
   OUT outSummaTotal         TFloat    , -- �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUnitID
                  AND MovementItem.DescId = zc_MI_Sign())
      THEN
        SELECT MovementItem.ID
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.ObjectID = inUnitID
          AND MovementItem.DescId = zc_MI_Sign();
      END IF;
    ELSE
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUnitID
                  AND MovementItem.ID <> ioId
                  AND MovementItem.DescId = zc_MI_Sign())
      THEN
        RAISE EXCEPTION '������. ������������ ������������� ���������.';
      END IF;
    END IF;

    -- ���������
    ioId := lpInsertUpdate_MovementItem_WagesAdditionalExpenses (ioId                  := ioId                  -- ���� ������� <������� ���������>
                                                               , inMovementId          := inMovementId          -- ���� ���������
                                                               , inUnitID              := inUnitID              -- �������������
                                                               , inSummaCleaning       := inSummaCleaning       -- ������
                                                               , inSummaSP             := inSummaSP             -- ��
                                                               , inSummaOther          := inSummaOther          -- ������
                                                               , inisIssuedBy          := inisIssuedBy          -- ������
                                                               , inComment             := inComment             -- ����������
                                                               , inUserId              := vbUserId              -- ������������
                                                                 );

   outSummaTotal := COALESCE((SELECT Amount FROM MovementItem WHERE MovementItem.ID = ioId), 0);
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.09.19                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesAdditionalExpenses (, inSession:= '2')

