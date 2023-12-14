-- Function: lpInsertUpdate_Movement_Invoice()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Invoice_Amount (Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Invoice_Amount(
    IN inId               Integer  ,  --
   OUT outAmount          TFloat   ,  --
    IN inUserId           Integer      -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
BEGIN

    outAmount := (SELECT zfCalc_SummWVAT (tmp.Summ�_WVAT, tmp.VATPercent)
                  FROM (SELECT SUM (COALESCE (MovementItem.Amount, 0) * COALESCE (MIFloat_OperPrice.ValueData, 0)) AS Summ�_WVAT
                             , MovementFloat_VATPercent.ValueData AS VATPercent
                        FROM Movement
                           LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
 
                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
 
                           LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                       ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                      AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                        WHERE Movement.Id = inId
                        GROUP BY MovementFloat_VATPercent.ValueData
                       ) AS tmp
                 );


    -- ��������� �������� <����� �����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), inId, outAmount);


    -- !!!�������� ����� �������� ����������� �������!!!
    -- ��������� �������� <���� �������������>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inId, CURRENT_TIMESTAMP);
    -- ��������� �������� <������������ (�������������)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inId, inUserId);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.12.23         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_Invoice_Amount
