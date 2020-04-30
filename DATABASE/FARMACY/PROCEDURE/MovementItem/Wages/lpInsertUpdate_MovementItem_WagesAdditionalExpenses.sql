-- Function: lpInsertUpdate_MovementItem_WagesAdditionalExpenses ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesAdditionalExpenses (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesAdditionalExpenses(
 INOUT ioId                       Integer   , -- ���� ������� <������� ���������>
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inUnitID                   Integer   , -- �������������
    IN inSummaCleaning            TFloat    , -- ������
    IN inSummaSP                  TFloat    , -- ��
    IN inSummaOther               TFloat    , -- ������
    IN inSummaValidationResults   TFloat    , -- ���������� ��������
    IN inSummaFullChargeFact      TFloat    , -- ������ �������� ����
    IN inisIssuedBy               Boolean   , -- ������
    IN inComment                  TVarChar  , -- ����������
    IN inUserId                   Integer   -- ������������
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbSumma TFloat;   
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

     -- ��������� �������� <��>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSP(), ioId, inSummaSP);

     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaOther(), ioId, inSummaOther);

     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ValidationResults(), ioId, inSummaValidationResults);
    
    vbSumma := COALESCE((SELECT SUM(MovementItemFloat.ValueData)
                              FROM MovementItemFloat 
                              WHERE MovementItemFloat.MovementItemId = ioId
                                AND MovementItemFloat.DescId in (zc_MIFloat_SummaFullChargeMonth(), zc_MIFloat_SummaFullCharge())), 0);      
        
    IF inSummaFullChargeFact = vbSumma
    THEN
      IF EXISTS(SELECT 1 FROM MovementItemFloat 
                WHERE MovementItemFloat.MovementItemId = ioId
                  AND MovementItemFloat.DescId = zc_MIFloat_SummaFullChargeFact())
      THEN
        DELETE FROM MovementItemFloat 
        WHERE MovementItemFloat.MovementItemId = ioId
          AND MovementItemFloat.DescId = zc_MIFloat_SummaFullChargeFact();
      END IF;    
    ELSE
     
      -- ��������� �������� <������ �������� ����>
      IF inSummaFullChargeFact = 0
      THEN
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullChargeFact(), ioId, vbSumma);      
      END IF;
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullChargeFact(), ioId, inSummaFullChargeFact);
    END IF;
    

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, lpGet_MovementItem_WagesAE_TotalSum (ioId, inUserId), 0);

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

/*

SELECT * FROM MovementItemFloat 
                WHERE MovementItemFloat.MovementItemId = 333326971
                  AND MovementItemFloat.DescId = zc_MIFloat_SummaFullChargeFact()
                  
*/                  
