-- Function: gpUpdate_Object_Unit_HistoryCost

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_HistoryCost (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_HistoryCost(
    IN inId                    Integer   , -- ���� ������� <�������������>
    IN inUnitId_HistoryCost    Integer   , -- 
    IN inSession               TVarChar    -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_HistoryCost());

   IF inId = 0
   THEN
       RAISE EXCEPTION '������. ������� �� ��������.';
   END IF;
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_HistoryCost(), inId, inUnitId_HistoryCost);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.04.19         *            
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Unit_HistoryCost ()                            
