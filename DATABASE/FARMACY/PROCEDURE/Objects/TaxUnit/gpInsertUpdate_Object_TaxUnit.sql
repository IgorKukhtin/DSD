-- Function: gpInsertUpdate_Object_ContractCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TaxUnit (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TaxUnit(
 INOUT ioId                      Integer ,    -- ���� ������� <>
    IN inUnitId                  Integer ,    -- ������ �� �������������
    IN inPrice                   TFloat  ,    --  
    IN inValue                   TFloat  ,    --  
    IN inSession                 TVarChar     -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TaxUnit());
   vbUserId := inSession;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TaxUnit(), 0, '');
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_TaxUnit_Unit(), ioId, inUnitId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_TaxUnit_Price(), ioId, inPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_TaxUnit_Value(), ioId, inValue);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.19         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_TaxUnit ()                            
