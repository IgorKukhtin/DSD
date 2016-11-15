-- Function: gpInsertUpdate_Object_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SheetWorkTime(Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SheetWorkTime(
 INOUT ioId                  Integer   ,    -- ���� ������� < �������� ��������>
    IN inCode                Integer   ,    -- ��� ������� 
    --IN inName                TVarChar  ,    -- �������� ������� --������������ ��������� �� ��-���
    IN inStartTime           TDateTime ,    -- ����� ������
    IN inWorkTime            TDateTime ,    -- ���������� ������� �����
    IN inDayOffPeriodDate    TDateTime ,    -- ������� � ������ ����� ������ �������������
    IN inComment             TVarChar  ,    -- ����������
    IN inDayOffPeriod        TVarChar  ,    -- ������������� � ����
    IN inDayOffWeek          TVarChar  ,    -- ��� ������
    IN inDayKindId           Integer   ,    -- ������ �� ��� ���
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
   DECLARE vbName TVarChar; 
BEGIN
   
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_SheetWorkTime());

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
    vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SheetWorkTime()); 

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SheetWorkTime(), vbCode_calc);
    
   vbName:= '';
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriod);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, inDayOffWeek);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_Comment(), ioId, inComment);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Start(), ioId, inStartTime);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Work(), ioId, inWorkTime);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriodDate);


   -- ��������� ����� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SheetWorkTime_DayKind(), ioId, inDayKindId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.11.16         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_SheetWorkTime()
