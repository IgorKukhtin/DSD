-- Function: gpInsertUpdate_Object_MemberSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, Integer, Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSP (Integer, Integer, TVarChar, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberSP(
 INOUT ioId	             Integer   ,    -- ���� ������� <����������� ����� ���������� ������ (���. ������)> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� <>
    IN inPartnerMedicalId    Integer   ,    -- ���. ������.
    IN inGroupMemberSPId     Integer   ,    -- ��������� ���.
--    IN inHappyDate           TDateTime ,    -- ���� ��������
    IN inHappyDate           TVarChar ,     -- ���� ��������
    IN inAddress             TVarChar ,     -- �����
    IN inINN                 TVarChar ,     -- ���
    IN inPassport            TVarChar ,     -- ����� � ����� ��������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
   DECLARE vbHappyDate TDateTime;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSP());
   vbUserId := inSession;
   
    -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MemberSP());
   
   -- �������� ���������� ���.������.
   IF COALESCE (inPartnerMedicalId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <����������� ����������> �� �����������.';
   END IF;
   IF COALESCE (inGroupMemberSPId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� <��������� ��������> �� �����������.';
   END IF;
   
   --�������� ��� ���.������ � 5 ������ ���� ��������� �����, ���, ����� � ����� ��������   
   IF inPartnerMedicalId = 3751525               ----3751525 - "����������� ������ "������ �5""
   THEN
       IF COALESCE (inAddress, '') = ''
       THEN
           RAISE EXCEPTION '������.�������� <����� ��������> �� �����������.';
       END IF;
       IF COALESCE (inINN, '') = ''
       THEN
           RAISE EXCEPTION '������.�������� <��� ��������> �� �����������.';
       END IF;
       IF COALESCE (inPassport, '') = ''
       THEN
           RAISE EXCEPTION '������.�������� <����� � ����� �������� ��������> �� �����������.';
       END IF;       
   END IF;
   
   -- �������� ������������ <������������>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_MemberSP(), inName);
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberSP
                   LEFT JOIN ObjectLink AS OL_PartnerMedical
                                        ON OL_PartnerMedical.ObjectId = Object_MemberSP.Id
                                       AND OL_PartnerMedical.DescId = zc_ObjectLink_MemberSP_PartnerMedical()
                   LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                        ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = Object_MemberSP.Id
                                       AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
              WHERE Object_MemberSP.DescId = zc_Object_MemberSP()
                AND Object_MemberSP.ValueData = TRIM(inName)
                AND OL_PartnerMedical.ChildObjectId = inPartnerMedicalId
                AND ObjectLink_MemberSP_GroupMemberSP.ChildObjectId = inGroupMemberSPId
                AND Object_MemberSP.Id <> ioId
              )
   THEN
       RAISE EXCEPTION '������.�������� <%> �� ��������� ��� �����������' , inName;
   END IF;
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MemberSP(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberSP(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MemberSP_PartnerMedical(), ioId, inPartnerMedicalId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MemberSP_GroupMemberSP(), ioId, inGroupMemberSPId);   

   -- ��������� �������� <>
   IF COALESCE (inHappyDate, '') <> ''
      THEN
          vbHappyDate := ('01.01.' || TRIM (inHappyDate)) :: TDatetime;   -- ������ ������ ��� ��������, ������� ��� ���� ��������� 01,01
          PERFORM lpInsertUpdate_ObjectDate( zc_ObjectDate_MemberSP_HappyDate(), ioId, vbHappyDate);
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberSP_Address(), ioId, inAddress);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberSP_INN(), ioId, inINN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberSP_Passport(), ioId, inPassport);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.02.18         *
 18.01.18         *
 14.02.17         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MemberSP()
