-- Function: gpInsertUpdate_Object_MemberIC()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberIC (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberIC(
 INOUT ioId	              Integer   ,    -- ���� �������
    IN inCode                 Integer   ,    -- ��� ������� 
    IN inName                 TVarChar  ,    -- �������� ������� <��� ���������� (��������� ��������)>
    IN inInsuranceCompaniesId Integer   ,    -- ��������� ��������
    IN inInsuranceCardNumber  TVarChar ,     -- ����� ��������� �����	
    IN inSession              TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberIC());
   vbUserId := inSession;
   
    -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MemberIC());
   
   -- �������� ���������� ��������� ��������
   IF COALESCE (inInsuranceCompaniesId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <��������� ��������> �� �����������.';
   END IF;
   
   IF COALESCE (TRIM(inInsuranceCardNumber)	, '') = ''
   THEN
       RAISE EXCEPTION '������.�������� <����� ��������� �����> �� �����������.';
   END IF;
   
   -- �������� ������������ <������������>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_MemberIC(), inName);
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberIC
                   LEFT JOIN ObjectString AS ObjectString_InsuranceCardNumber	
                                          ON ObjectString_InsuranceCardNumber.ObjectId = Object_MemberIC.Id
                                         AND ObjectString_InsuranceCardNumber.DescId = zc_ObjectString_MemberIC_InsuranceCardNumber	()

                   LEFT JOIN ObjectLink AS ObjectLink_MemberIC_InsuranceCompanies
                                        ON ObjectLink_MemberIC_InsuranceCompanies.ObjectId = Object_MemberIC.Id
                                       AND ObjectLink_MemberIC_InsuranceCompanies.DescId = zc_ObjectLink_MemberIC_InsuranceCompanies()
              WHERE Object_MemberIC.DescId = zc_Object_MemberIC()
                AND ObjectLink_MemberIC_InsuranceCompanies.ChildObjectId = inInsuranceCompaniesId
                AND ObjectString_InsuranceCardNumber.ValueData = TRIM(inInsuranceCardNumber)
                AND Object_MemberIC.Id <> ioId
              )
   THEN
       RAISE EXCEPTION '������.����� ��������� ����� <%> �� ��������� ��� ����������� �� ��������� ��������' , inInsuranceCardNumber;
   END IF;
   
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MemberIC(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberIC(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MemberIC_InsuranceCompanies(), ioId, inInsuranceCompaniesId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberIC_InsuranceCardNumber	(), ioId, inInsuranceCardNumber	);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.09.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MemberIC()

