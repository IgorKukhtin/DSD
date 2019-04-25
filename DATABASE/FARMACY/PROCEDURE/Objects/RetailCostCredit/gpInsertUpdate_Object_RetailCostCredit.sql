-- Function: gpInsertUpdate_Object_ContractCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RetailCostCredit (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RetailCostCredit(
 INOUT ioId                      Integer ,    -- ���� ������� <>
    IN inRetailId                  Integer ,    -- ������ �� �������������
    IN inMinPrice                   TFloat  ,    --  
    IN inPercent                   TFloat  ,    --  
    IN inSession                 TVarChar     -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RetailCostCredit());
   vbUserId := inSession;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RetailCostCredit(), 0, '');
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_RetailCostCredit_Retail(), ioId, inRetailId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RetailCostCredit_MinPrice(), ioId, inMinPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_RetailCostCredit_Percent(), ioId, inPercent);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.04.19         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_RetailCostCredit ()                            
