-- Function: gpDelete_Object_UnitLincDriver()

DROP FUNCTION IF EXISTS gpDelete_Object_UnitLincDriver(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_UnitLincDriver(
    IN inUnitId         Integer   ,     -- ��� �������  
    IN inDriverId       Integer   ,     -- ��� ������� 
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Driver());

   IF COALESCE(inUnitId, 0) = 0 OR COALESCE(inDriverId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �� ��������� ������������� ��� ��������!';
   END IF;
 
   
   IF NOT EXISTS(SELECT 1 FROM ObjectLink 
                                       WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Driver()
                                         AND ObjectLink.ObjectId = inUnitId)
   THEN
     RAISE EXCEPTION '������. ����� ������������� <%> � ��������� �� �������!', (SELECT Object.ValueData FROM Object WHERE Object.ID = inUnitId);
   END IF;
   
   -- ��������� ����� � <��������������>
   DELETE FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Driver()
                            AND ObjectLink.ObjectId = inUnitId;
   
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.08.19                                                       *
*/

-- ����
-- 
