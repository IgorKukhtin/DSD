
DROP FUNCTION IF EXISTS gpUpdate_Object_DiscountPeriod (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_DiscountPeriod(
    IN inId             Integer,       -- ���� ������� <�������� ������������� ������>            
    IN inUnitId         Integer,       -- ���� ������� <>
    IN inPeriodId       Integer,       -- ���� ������� <>
    IN inStartDate      TDateTime ,
    IN inEndDate        TDateTime ,
    IN inSession        TVarChar       -- ������ ������������                     
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountPeriod());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inId, 0) = 0 
   THEN
        RAISE EXCEPTION '������. ������� �� ��������.';
   END IF;
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Unit(), inId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Period(), inId, inPeriodId);

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_StartDate(), inId, inStartDate);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_EndDate(), inId, inEndDate);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
23.02.18          *
*/

-- ����
-- 