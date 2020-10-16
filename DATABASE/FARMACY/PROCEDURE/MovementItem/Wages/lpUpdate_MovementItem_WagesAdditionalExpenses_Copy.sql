-- Function: lpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy (Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesAdditionalExpenses_Copy(
 INOUT ioId                       Integer   , -- ���� ������� <������� ���������>
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inUnitID                   Integer   , -- �������������
    IN inSummaCleaning            TFloat    , -- ������
    IN inSummaOther               TFloat    , -- ������
    IN inComment                  TVarChar  , -- ����������
    IN inUserId                   Integer     -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    IF vbIsInsert = TRUE
    THEN
       -- ������� <������� ���������>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, 0, 0);
    END IF;
    
     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaCleaning(), ioId, inSummaCleaning);

     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaOther(), ioId, inSummaOther);
    
    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, lpGet_MovementItem_WagesAE_TotalSum (ioId, inUserId), 0);

    -- ��������� �������� <����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);    

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.10.20                                                        *
*/

-- ����
-- 
