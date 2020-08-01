-- Function: lpInsertUpdate_MI_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_IncomeHouseholdInventory (Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_IncomeHouseholdInventory(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inHouseholdInventoryId  Integer   , -- ������������� ���������
    IN inAmount                TFloat    , -- ����������
    IN inCountForPrice         TFloat    , -- ������������� 
    IN inComment               TVarChar  , -- �����������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

          
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inHouseholdInventoryId, inMovementId, inAmount, NULL);
      
     -- ��������� <�������������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), ioId, inCountForPrice);

     -- ��������� <�����������>
     PERFORM lpInsertUpdate_MovementString (zc_MIString_Comment(), ioId, inComment);
      
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      * 
 */

-- ����
-- SELECT * FROM lpInsertUpdate_MI_IncomeHouseholdInventory (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
