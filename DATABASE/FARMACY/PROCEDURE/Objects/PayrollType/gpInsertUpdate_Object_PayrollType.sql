-- Function: gpInsertUpdate_Object_PayrollType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PayrollType(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PayrollType (
  INOUT ioId integer,
     IN inCode integer,
     IN inName TVarChar,
     IN inPayrollGroupID integer,
     IN inPercent TFloat,
     IN inMinAccrualAmount TFloat,
     IN inSession TVarChar
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PayrollType());
   vbUserId := inSession;
  
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PayrollType());

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PayrollType(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PayrollType(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PayrollType(), vbCode_calc, inName);
   
   -- ��������� ����� � <������ ������� ���������� �����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PayrollType_PayrollGroup(), ioId, inPayrollGroupID);
   
   -- ������� �� ����
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollType_Percent(), ioId, inPercent);
   -- % ������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollType_MinAccrualAmount(), ioId, inMinAccrualAmount);

   -- ��� ����� ����������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.08.19                                                        *

*/

-- ����
