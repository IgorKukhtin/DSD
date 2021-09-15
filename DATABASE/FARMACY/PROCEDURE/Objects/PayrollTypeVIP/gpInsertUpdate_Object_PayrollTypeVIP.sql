-- Function: gpInsertUpdate_Object_PayrollTypeVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PayrollTypeVIP(Integer, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PayrollTypeVIP (
  INOUT ioId integer,
     IN inCode integer,
     IN inName TVarChar,
     IN inShortName TVarChar,
     IN inPercentPhone TFloat,
     IN inPercentOther TFloat,
     IN inSession TVarChar
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PayrollTypeVIP());
   vbUserId := inSession;
  
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PayrollTypeVIP());

   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PayrollTypeVIP(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PayrollTypeVIP(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PayrollTypeVIP(), vbCode_calc, inName);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_PayrollTypeVIP_ShortName(), ioId, inShortName);

   -- ������� �� ����
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollTypeVIP_PercentPhone(), ioId, inPercentPhone);
   -- % ������
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_PayrollTypeVIP_PercentOther(), ioId, inPercentOther);

   -- ��� ����� ����������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.09.21                                                        *

*/

-- ����