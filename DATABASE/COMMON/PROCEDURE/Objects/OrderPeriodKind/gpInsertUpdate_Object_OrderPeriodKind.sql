-- Function: gpUpdate_Object_OrderPeriodKind

DROP FUNCTION IF EXISTS gpUpdate_Object_OrderPeriodKind (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_OrderPeriodKind(
    IN inId             Integer,       -- 
    IN inWeek           TFloat ,       -- 
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_OrderPeriodKind());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderPeriodKind_Week(), inId, inWeek);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.21         *

*/

-- ����
--