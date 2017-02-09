-- Function: gpInsertUpdate_Object_ConditionPromo(Integer,Integer,TVarChar,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ConditionPromo(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ConditionPromo(
 INOUT ioId	                 Integer,       -- ���� ������� < ����>
    IN inCode                Integer,       -- ��� ������� <����>
    IN inName                TVarChar,      -- �������� ������� <����>
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ConditionPromo());
   vbUserId := lpGetUserBySession(inSession);
   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ConditionPromo());


   -- �������� ���� ������������ ��� �������� <������������ ���� �����>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ConditionPromo(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ConditionPromo(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ConditionPromo(), vbCode_calc, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ConditionPromo (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 31.10.15                                                                      *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ConditionPromo ()
                            