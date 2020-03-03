-- Function: lpInsertUpdate_MovementItem_WagesAdditionalExpenses ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesAdditionalExpenses (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesAdditionalExpenses(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitID              Integer   , -- �������������
    IN inSummaCleaning       TFloat    , -- ������
    IN inSummaSP             TFloat    , -- ��
    IN inSummaOther          TFloat    , -- ������
    IN inValidationResults   TFloat    , -- ���������� ��������
    IN inisIssuedBy          Boolean   , -- ������
    IN inComment             TVarChar  , -- ����������
    IN inUserId              Integer   -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbSummaSUN1 TFloat;
BEGIN
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    IF vbIsInsert = FALSE
    THEN
      vbSummaSUN1 := (SELECT MIFloat_SummaSUN1.ValueData
                      FROM MovementItemFloat AS MIFloat_SummaSUN1
                      WHERE MIFloat_SummaSUN1.MovementItemId = ioId
                        AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaSUN1(),
                                                         zc_MIFloat_SummaTechnicalRediscount()));
    ELSE
      vbSummaSUN1 := 0;
    END IF;

     -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, COALESCE (inSummaCleaning, 0) + 
                                                                                     COALESCE (inSummaSP, 0) + 
                                                                                     COALESCE (inSummaOther, 0) + 
                                                                                     COALESCE (inValidationResults, 0) + 
                                                                                     COALESCE (vbSummaSUN1, 0), 0);
    
     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaCleaning(), ioId, inSummaCleaning);

     -- ��������� �������� <��>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSP(), ioId, inSummaSP);

     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaOther(), ioId, inSummaOther);

     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ValidationResults(), ioId, inValidationResults);

    -- ��������� �������� <����������>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� �������� <���� ������>
    IF vbIsInsert AND inisIssuedBy OR 
      NOT vbIsInsert AND inisIssuedBy <> COALESCE (
      (SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId) , FALSE)
    THEN
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
    END IF;
    
     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
    

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.20                                                        *
 02.10.19                                                        *
 01.09.19                                                        *
*/

-- ����
-- 