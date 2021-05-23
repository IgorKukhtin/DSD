-- Function: gpInsertUpdate_Object_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SheetWorkTime(Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SheetWorkTime(
 INOUT ioId                  Integer   ,    -- ���� ������� < �������� ��������>
    IN inCode                Integer   ,    -- ��� ������� 
    IN inStartTime           TDateTime ,    -- ����� ������
    IN inWorkTime            TDateTime ,    -- ���������� ������� �����
    IN inDayOffPeriodDate    TDateTime ,    -- ������� � ������ ����� ������ �������������
    IN inDayOffPeriod        TVarChar  ,    -- ������������� � ����
    IN inComment             TVarChar  ,    -- ����������
    IN inValue1              Boolean   ,    -- �����������
    IN inValue2              Boolean   ,    -- �������
    IN inValue3              Boolean   ,    -- �����
    IN inValue4              Boolean   ,    -- �������
    IN inValue5              Boolean   ,    -- �������
    IN inValue6              Boolean   ,    -- �������
    IN inValue7              Boolean   ,    -- �����������
    IN inDayKindId           Integer   ,    -- ������ �� ��� ���
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbName TVarChar;
   DECLARE vbDayOffWeek TVarChar;
   DECLARE vbDayOffPeriod TVarChar;
   DECLARE vbStartTime TDateTime;
   DECLARE vbEndTime TDateTime;
   DECLARE vbWorkTime TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);


    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
    vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SheetWorkTime()); 

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SheetWorkTime(), vbCode_calc);
    
   vbStartTime:= ( '' ||CURRENT_DATE::Date || ' '||inStartTime ::Time):: TDateTime ;
   vbEndTime  := (vbStartTime + inWorkTime ::Time):: TDateTime ;
   vbWorkTime := ( '' ||CURRENT_DATE::Date || ' '||inWorkTime  ::Time):: TDateTime ;
 

   IF COALESCE (inDayKindId,0) =0 THEN

	RAISE EXCEPTION '�� ������ �������� - ��� ���.';

   ELSEIF COALESCE (inDayKindId,0) = zc_Enum_DayKind_Calendar() THEN

         vbName:= '������� ��� - �������� �����������, � ' ||
                  lpad (EXTRACT (HOUR FROM inStartTime)::tvarchar ,2, '0')||':'||lpad (EXTRACT (MINUTE FROM inStartTime)::tvarchar,2, '0') ||  --inStartTime ::Time || 
         ' �� ' ||lpad (EXTRACT (HOUR FROM vbEndTime) ::tvarchar ,2, '0') ||':'||lpad (EXTRACT (MINUTE FROM vbEndTime) ::tvarchar ,2, '0') ; -- inWorkTime ::Time;
         -- ��������� <������>
         ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, '');
         -- ��������� �������� <>
         vbDayOffWeek:= ('0,' || '0,' || '0,' || '0,' || '0,' ||'0,' || '0' ) ::TVarChar;
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, vbDayOffWeek);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, zc_DateStart());

   ELSEIF COALESCE (inDayKindId,0) = zc_Enum_DayKind_Week() THEN

         vbName:= '������� ��� - ������ 7 ����, � ' ||
                    lpad (EXTRACT (HOUR FROM inStartTime)::tvarchar, 2, '0')||':' ||lpad (EXTRACT (MINUTE FROM inStartTime)::tvarchar, 2, '0') ||  --inStartTime ::Time || 
           ' �� '|| lpad (EXTRACT (HOUR FROM vbEndTime)  ::tvarchar, 2, '0')||':' ||lpad (EXTRACT (MINUTE FROM vbEndTime)  ::tvarchar, 2, '0')||
           ', �������� '||(CASE WHEN inValue1 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue2 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue3 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue4 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue5 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue6 = FALSE THEN 0 ELSE 1 END +
                           CASE WHEN inValue7 = FALSE THEN 0 ELSE 1 END)||
            ' ��. '   ;
         -- ��������� <������>
         ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, '');
         -- ��������� �������� <>
         vbDayOffWeek:= (CASE WHEN inValue1 = TRUE THEN '1, ' ELSE '0,' END ||
                         CASE WHEN inValue2 = TRUE THEN '2, ' ELSE '0,' END ||
                         CASE WHEN inValue3 = TRUE THEN '3, ' ELSE '0,' END ||
                         CASE WHEN inValue4 = TRUE THEN '4, ' ELSE '0,' END ||
                         CASE WHEN inValue5 = TRUE THEN '5, ' ELSE '0,' END ||
                         CASE WHEN inValue6 = TRUE THEN '6, ' ELSE '0,' END ||
                         CASE WHEN inValue7 = TRUE THEN '7 '  ELSE '0'  END  ) ::TVarChar;
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, vbDayOffWeek);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, zc_DateStart());

   ELSEIF COALESCE (inDayKindId,0) = zc_Enum_DayKind_Period() THEN
         IF COALESCE (inDayOffPeriod, '') =  '' THEN
            RAISE EXCEPTION '�� �������� �������� - ������������� � ����.';
         END IF;
         vbDayOffPeriod:= (SELECT EXTRACT (DAY FROM inDayOffPeriodDate)||'.'||EXTRACT (MONTH FROM inDayOffPeriodDate)||'.'||EXTRACT (YEAR FROM inDayOffPeriodDate));
         vbName:= '������� ��� - �������� ' ||inDayOffPeriod||' ������� � '||vbDayOffPeriod||
         ', � ' || lpad (EXTRACT (HOUR FROM inStartTime)::tvarchar ,2, '0')||':' ||lpad (EXTRACT (MINUTE FROM inStartTime)::tvarchar,2, '0') ||  --inStartTime ::Time || 
          ' �� '|| lpad (EXTRACT (HOUR FROM vbEndTime)::tvarchar ,2, '0')  ||':' ||lpad (EXTRACT (MINUTE FROM vbEndTime) ::tvarchar ,2, '0') ;
         -- ��������� <������>
         ioId := lpInsertUpdate_Object(ioId, zc_Object_SheetWorkTime(), vbCode_calc, vbName);

         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriod);
         -- ��������� �������� <>
         vbDayOffWeek:= ('0,' || '0,' || '0,' || '0,' || '0,' ||'0,' || '0' ) ::TVarChar;
         PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_DayOffWeek(), ioId, vbDayOffWeek);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_DayOffPeriod(), ioId, inDayOffPeriodDate);
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SheetWorkTime_Comment(), ioId, inComment);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Start(), ioId, vbStartTime);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_SheetWorkTime_Work(), ioId, vbWorkTime);
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
-- select * from gpInsertUpdate_Object_SheetWorkTime(ioId := 736960 , inCode := 1 , inStartTime := ('01.01.2000 3:00:00')::TDateTime , inWorkTime := ('01.01.2000 20:00:00')::TDateTime , inDayOffPeriodDate := ('16.11.2016')::TDateTime , inDayOffPeriod := '3' , inComment := '����������' , inValue1 := 'False' , inValue2 := 'True' , inValue3 := 'True' , inValue4 := 'True' , inValue5 := 'False' , inValue6 := 'False' , inValue7 := 'False' , inDayKindId := 736944 ,  inSession := '5');
