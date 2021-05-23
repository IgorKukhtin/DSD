-- Function: gpInsertUpdate_Object_Founder()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Founder (Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Founder (Integer, Integer, TVarChar, Integer, Tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Founder(
 INOUT ioId             Integer   ,     -- ���� ������� <����������>
    IN inCode           Integer   ,     -- ��� �������
    IN inName           TVarChar  ,     -- �������� �������
    IN inInfoMoneyId    Integer   ,     -- ������ ����������
    IN inLimitMoney     Tfloat    ,     -- ����� ���
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Founder());


   -- ��������
   IF COALESCE (inInfoMoneyId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<�� ������ ����������> �� �������.';
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Founder());

   -- �������� ������������ ��� �������� <������������> + <�������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Founder(), inName);

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Founder(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Founder(), vbCode_calc, inName);
  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Founder_InfoMoney(), ioId, inInfoMoneyId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Founder_Limit(), ioId, inLimitMoney);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Founder (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 01.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Founder (ioId:= NULL, inCode:= NULL, inName:= '���������� 1', inInfoMoneyId:= NULL, inSession:='2')
