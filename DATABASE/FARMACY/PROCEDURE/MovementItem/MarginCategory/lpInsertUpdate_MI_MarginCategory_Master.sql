-- Function: lpInsertUpdate_MI_MarginCategory_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Master (Integer, Integer, Integer, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_MarginCategory_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_MarginCategory_Master(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inAmountAnalys	     TFloat    , -- 
    IN inAmountMin	     TFloat    , -- 
    IN inAmountMax	     TFloat    , -- 
    IN inNumberMin	     TFloat    , -- 
    IN inNumberMax	     TFloat    , -- 
    IN inRemains             TFloat    , 
    IN inPrice               TFloat    , 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbIsInsert Boolean;
BEGIN
   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.�� ���������� �������� ��������� <�����>.';
   END IF;

   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Amount(), ioId, inAmountAnalys);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_AmountMin(), ioId, inAmountMin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_AmountMax(), ioId, inAmountMax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_NumberMin(), ioId, inNumberMin);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_NumberMax(), ioId, inNumberMax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Remains(), ioId, inRemains);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Price(), ioId, inPrice);  

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.11.17         *
*/

-- ����
-- 