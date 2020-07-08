-- Function: gpInsertUpdate_ObjectHistory_JuridicalDetails ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_JuridicalDetails(
 INOUT ioId                     Integer,    -- ���� ������� <������� ������� ���������� ��. ���>
    IN inJuridicalId            Integer,    -- ��. ����
    IN inOperDate               TDateTime,  -- ���� �������� �����-�����
    IN inBankId                 Integer,    -- ����
    IN inFullName               TVarChar,   -- ��. ���� ������ ������������
    IN inJuridicalAddress	TVarChar,   -- ����������� �����
    IN inOKPO                   TVarChar,   -- ����
    IN inINN	                TVarChar,   -- ���
    IN inNumberVAT	        TVarChar,   -- ����� ������������� ����������� ���
    IN inAccounterName	        TVarChar,   -- ��� ����.
    IN inMainName	        TVarChar,   -- ��� ���������
    IN inBankAccount	        TVarChar,   -- �.����
    IN inPhone      	        TVarChar,   -- �������
    IN inInvNumberBranch        TVarChar,   -- � �������
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbJuridicalId_find Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);


   -- �������� ������������ <����>, ����� "�����������"
   IF inOKPO <> '' AND NOT (LENGTH (inOKPO) = 5 AND (SUBSTRING (inOKPO, 3, 1) = '-' OR SUBSTRING (inOKPO, 3, 1) = '*'))
   THEN
       -- ������� ��. ����
       SELECT MAX (ObjectHistory.ObjectId) INTO vbJuridicalId_find
       FROM ObjectHistoryString
            JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString.ObjectHistoryId
                              AND ObjectHistory.ObjectId <> inJuridicalId
                              AND ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
       WHERE ObjectHistoryString.ValueData = inOKPO
         AND ObjectHistoryString.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO();
       --
       IF vbJuridicalId_find > 0
       THEN
           RAISE EXCEPTION '������.�������� ���� <%> ��� ����������� � <%>.', inOKPO, lfGet_Object_ValueData (vbJuridicalId_find);
       END IF;
   END IF;

   -- �������� ������������ <��. ���� ������ ������������>
   IF inFullName <> '' AND inFullName <> '�� "������������� ��������"'
   THEN
       -- ������� ��. ����
       SELECT MAX (ObjectHistory.ObjectId) INTO vbJuridicalId_find
       FROM ObjectHistoryString
            JOIN ObjectHistory ON ObjectHistory.Id = ObjectHistoryString.ObjectHistoryId
                              AND ObjectHistory.ObjectId <> inJuridicalId
                              AND ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
       WHERE ObjectHistoryString.ValueData = inFullName
         AND ObjectHistoryString.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName();
       --
       IF vbJuridicalId_find > 0
       THEN
           RAISE EXCEPTION '������.�������� ������ ������������ <%> ��� ����������� � <%>.', inFullName, lfGet_Object_ValueData (vbJuridicalId_find);
       END IF;
   END IF;

   -- ��������
   IF COALESCE (inJuridicalId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� <����������� ����>.';
   END IF;
   -- ��������
   IF TRIM (COALESCE (inOKPO, '')) = '' AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin() AND ObjectLink_UserRole_View.UserId = vbUserId)
   THEN
       RAISE EXCEPTION '������.��� ���� ��������� � ������ <����>.';
   END IF;
   


   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_JuridicalDetails(), inJuridicalId, inOperDate, vbUserId);

   -- ����
   PERFORM lpInsertUpdate_ObjectHistoryLink(zc_ObjectHistoryLink_JuridicalDetails_Bank(), ioId, inBankId);

   -- ��. ���� ������ ��������
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_FullName(), ioId, inFullName);
   -- ����������� �����
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress(), ioId, inJuridicalAddress);
   -- ����
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_OKPO(), ioId, inOKPO);
   -- ���
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_INN(), ioId, inINN);
   -- ����� ������������� ����������� ���
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_NumberVAT(), ioId, inNumberVAT);
   -- ��� ����.
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_AccounterName(), ioId, inAccounterName);
   -- ��� ���������
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_MainName(), ioId, inMainName);
   -- �.����
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_BankAccount(), ioId, inBankAccount);
   -- �������
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_Phone(), ioId, inPhone);
   -- � �������
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_InvNumberBranch(), ioId, inInvNumberBranch);

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, 0)
   FROM ObjectHistory WHERE Id = ioId;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07,04,16         * add InvNumberBranch
 26.11.15         * add MainName
 03.08.14                                        * add ����� "�����������"
 12.02.14                                                       * add phone
 06.01.14                                        * add �������� ������������  <��. ���� ������ ������������>
 05.01.14                                        * add �������� ������������ <����>
 03.01.14                                        *Cyr1251
 28.11.13                        *
*/
