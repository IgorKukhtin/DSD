-- Function: gpInsertUpdate_Object_SurchargeWages()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SurchargeWages (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SurchargeWages(
 INOUT ioId              Integer   ,   	-- ���� ������� <>
    IN inCode            Integer   ,    -- ��� �������  
    IN inUserId          Integer   ,    -- ���������
    IN inUnitId          Integer   ,    -- ������
    IN inDateStart       TDateTime ,    -- ���� ������ ��������
    IN inDateEnd         TDateTime ,    -- ���� ����� ��������
    IN inSumma           TFloat    ,    -- ����� �������
    IN inDescription     TVarChar  ,    -- ��������
    IN inSession         TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SurchargeWages());
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
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SurchargeWages());

   IF COALESCE(inUserId, 0) = 0 OR COALESCE(inUnitId, 0) = 0 
   THEN
     RAISE EXCEPTION '�� ��������� <���������> ��� <�������������>';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_SurchargeWages(), vbCode_calc, '');

   -- ��������� ����� � <������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SurchargeWages_User(), ioId, inUserId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_SurchargeWages_Unit(), ioId, inUnitId);

   -- ��������� �������� <���� ������ ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_SurchargeWages_DateStart(), ioId, inDateStart);
   -- ��������� �������� <���� ��������� ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_SurchargeWages_DateEnd(), ioId, inDateEnd);

   -- ��������� �������� <����� �������>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_SurchargeWages_Summa(), ioId, inSumma);

   -- ��������� �������� <��������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_SurchargeWages_Description(), ioId, inDescription);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.11.21                                                       *
*/

-- ����
--