-- Function: gpUpdate_Movement_Check_BuyerForSale()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_BuyerForSale (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_BuyerForSale(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inBuyerForSaleId    Integer   , -- ������������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BuyerForSale(), inId, inBuyerForSaleId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.06.22                                                       *
*/
-- ����
-- select * from gpUpdate_Movement_Check_BuyerForSale(inId := 7784533 , inBuyerForSaleId := 183294 ,  inSession := '3');