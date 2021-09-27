-- Function: gpInsertUpdate_Object_CorrectWagesPercentage()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CorrectWagesPercentage (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CorrectWagesPercentage(
 INOUT ioId              Integer   ,   	-- ���� ������� <>
    IN inCode            Integer   ,    -- ��� �������  
    IN inUserId          Integer   ,    -- ���������
    IN inUnitId          Integer   ,    -- ������
    IN inDateStart       TDateTime ,    -- ���� ������ ��������
    IN inDateEnd         TDateTime ,    -- ���� ����� ��������
    IN inPercent         TFloat    ,    -- ������� �� ���������
    IN inisCheck         Boolean   ,    -- ������ �� �����
    IN inisStore         Boolean   ,    -- ������ �� ��������
    IN inSession         TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectWagesPercentage());
   vbUserId := lpGetUserBySession (inSession); 

   inDateStart := DATE_TRUNC ('DAY', inDateStart);
   inDateEnd := DATE_TRUNC ('DAY', inDateEnd);
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_CorrectWagesPercentage());

   IF COALESCE(inUserId, 0) = 0 OR COALESCE(inUnitId, 0) = 0 
   THEN
     RAISE EXCEPTION '�� ��������� <���������> ��� <�������������>';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CorrectWagesPercentage(), vbCode_calc, '');

   -- ��������� ����� � <������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrectWagesPercentage_User(), ioId, inUserId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_CorrectWagesPercentage_Unit(), ioId, inUnitId);

   -- ��������� �������� <���� ������ ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CorrectWagesPercentage_DateStart(), ioId, inDateStart);
   -- ��������� �������� <���� ��������� ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_CorrectWagesPercentage_DateEnd(), ioId, inDateEnd);

   -- ��������� �������� <������� �� ���������>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_CorrectWagesPercentage_Percent(), ioId, inPercent);

   -- ��������� �������� <������ �� �����>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CorrectWagesPercentage_Check(), ioId, inisCheck);
   -- ��������� �������� <������ �� ��������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_CorrectWagesPercentage_Store(), ioId, inisStore);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.09.21                                                       *
*/

-- ����
--