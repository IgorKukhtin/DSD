-- Function: gpUpdate_Movement_Check_MedicForSale()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_MedicForSale (Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_MedicForSale(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inMedicForSaleId    Integer   , -- ������������
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
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicForSale(), inId, inMedicForSaleId);
    
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
-- select * from gpUpdate_Movement_Check_MedicForSale(inId := 7784533 , inMedicForSaleId := 183294 ,  inSession := '3');
