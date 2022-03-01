-- Function: gpUpdate_MI_PriceList_SupplierFailures()

DROP FUNCTION IF EXISTS gpUpdate_MI_PriceList_SupplierFailures(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PriceList_SupplierFailures(
    IN inId                   Integer ,     -- �����
    IN inisSupplierFailures   Boolean ,
    IN inSession              TVarChar      -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE (inId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �� ���������� ������.';   
   END IF;
   
   -- ��������� �������� <����� ����������>
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_SupplierFailures(), inId, NOT inisSupplierFailures);
   
   -- ��������� �������� <���������>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);

   -- ��������� ����� � <����/����� �������������>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inId, vbUserId);
   
   -- ��������� ��������
   -- PERFORM lpInsert_MovementItemProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.02.22                                                       *
*/

-- select * from gpUpdate_MI_PriceList_SupplierFailures(inId := 495365270 , inisSupplierFailures := 'True' ,  inSession := '3');

-- select * from gpUpdate_MI_PriceList_SupplierFailures(inId := 495608342 , inisSupplierFailures := 'True' ,  inSession := '3');