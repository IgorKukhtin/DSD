-- Function: gpUpdate_IncomeHouseholdInventory_CountForPrice()

DROP FUNCTION IF EXISTS gpUpdate_IncomeHouseholdInventory_CountForPrice (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_IncomeHouseholdInventory_CountForPrice(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inHouseholdInventoryId  Integer   , -- ������������� ���������
    IN inCountForPrice         TFloat    , -- ������������� 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbUnitId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeHouseholdInventory());

    IF COALESCE (inId, 0) = 0 OR COALESCE (inCountForPrice, 0) <> 0
    THEN
        RETURN;    
    END IF;
    
    inCountForPrice := COALESCE ((SELECT ObjectFloat_CountForPrice.ValueData FROM ObjectFloat AS ObjectFloat_CountForPrice
                                  WHERE ObjectFloat_CountForPrice.ObjectId = inHouseholdInventoryId
                                    AND ObjectFloat_CountForPrice.DescId = zc_ObjectFloat_HouseholdInventory_CountForPrice()), 0);

    IF COALESCE (inCountForPrice, 0) = 0
    THEN
        RETURN;    
    END IF;

    -- ��������� <�������������>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), inId, inCountForPrice);
      
    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);
     
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_IncomeHouseholdInventory_CountForPrice (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      *
*/

-- ����
-- select * from gpUpdate_IncomeHouseholdInventory_CountForPrice(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');
