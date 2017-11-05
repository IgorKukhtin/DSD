-- Function: lpInsertUpdate_Object_GoodsReportSaleInf  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsReportSaleInf (Integer, TDateTime, TDateTime, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsReportSaleInf(
    IN inId                       Integer   ,    -- ���� ������� <> 
    IN inStartDate                TDateTime ,    -- 
    IN inEndDate                  TDateTime ,    -- 
    IN inWeek                     TFloat    ,    -- 
    IN inUserId                   Integer        -- ������ ������������
)
 RETURNS VOID AS
$BODY$
BEGIN
   
   -- ��������� <������>
   inId := lpInsertUpdate_Object (inId, zc_Object_GoodsReportSaleInf(), 0, '');

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsReportSaleInf_Week(), inId, inWeek);
   
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_GoodsReportSaleInf_Start(), inId, inStartDate);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_GoodsReportSaleInf_End(), inId, inEndDate);
  
   -- ��������� �������� <���� ����.>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
   -- ��������� �������� <������������ (����.)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.11.17         *
*/

-- ����
-- 