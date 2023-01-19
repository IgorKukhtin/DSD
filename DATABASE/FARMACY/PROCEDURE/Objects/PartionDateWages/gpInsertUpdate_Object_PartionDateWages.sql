-- Function: gpInsertUpdate_Object_PartionDateWages()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionDateWages (Integer, Integer, TDateTime, TFloat, Boolean, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionDateWages(
 INOUT ioId                 Integer   ,    -- ���� ������� <>
    IN inPartionDateKindId  Integer   ,    -- ��� ����/�� ����
    IN inDateStart          TDateTime ,    -- ���� ������ ��������
    IN inPercent            TFloat    ,    -- ����������� ����������� ��� ����������	
    IN inisNotCharge        Boolean   ,    -- �� ��������� ��
    IN inSession            TVarChar       -- ������ ������������
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
   
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;
   
   -- �������� ����� ���
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_PartionDateWages());

   IF COALESCE(inPartionDateKindId, 0) = 0
   THEN
     RAISE EXCEPTION '�� ��������� <��� ����/�� ����>';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PartionDateWages(), vbCode_calc, '');

   -- ��������� ����� � <������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PartionDateWages_PartionDateKind(), ioId, inPartionDateKindId);

   -- ��������� �������� <���� ������ ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_PartionDateWages_DateStart(), ioId, inDateStart);

   -- ��������� �������� <����������� ����������� ��� ����������>
   PERFORM lpInsertUpdate_ObjecTFloat(zc_ObjectFloat_PartionDateWages_Percent(), ioId, inPercent);

   -- ��������� �������� <�� ��������� ��>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PartionDateWages_NotCharge(), ioId, inisNotCharge);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.01.23                                                       *
*/

-- ����
-- select * from gpInsertUpdate_Object_PartionDateWages(ioId := 0 , inPartionDateKindId := 11648988 , inDateStart := ('01.02.2023')::TDateTime , inPercent := 0 , inisNotCharge := True ,  inSession := '3');