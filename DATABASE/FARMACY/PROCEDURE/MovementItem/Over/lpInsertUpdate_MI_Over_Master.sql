-- Function: lpInsertUpdate_MI_ProductionUnion_Master()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionUnion_Master (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionUnion_Master(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
    IN inMinExpirationDate   TDateTime , -- ������ ������
    IN inComment             TVarChar  , --
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
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Remains(), ioId, inRemains);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Price(), ioId, inPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_MCS(), ioId, inMCS);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemString(zc_MIString_Comment(), ioId, inComment);

   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.07.16         *
 
*/

-- ����
-- 