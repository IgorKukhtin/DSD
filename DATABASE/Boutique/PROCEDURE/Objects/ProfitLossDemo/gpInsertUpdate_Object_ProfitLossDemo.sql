-- Function: gpInsertUpdate_Object_ProfitLossDemo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProfitLossDemo(Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProfitLossDemo(
 INOUT ioId                Integer,    -- ���� ������� <>
    IN inProfitLossId      Integer,    -- 
    IN inUnitId            Integer,    --  
    IN inValue             TFloat ,    --
    IN inSession           TVarChar    -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ProfitLoss());
    vbUserId := inSession;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ProfitLossDemo(), 0, '');

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ProfitLossDemo_Value(), ioId, inValue);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLossDemo_ProfitLoss(), ioId, inProfitLossId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ProfitLossDemo_Unit(), ioId, inUnitId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.04.14         *
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProfitLossDemo()