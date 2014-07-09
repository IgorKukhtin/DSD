-- Function: gpInsertUpdate_ObjectHistory_JuridicalDetails ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_JuridicalDetails (Integer, Integer,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_JuridicalDetails(
 INOUT ioId                     Integer,    -- ���� ������� <������� ������� ���������� ��. ���>
    IN inJuridicalId            Integer,    -- ��. ����
    IN inFullName               TVarChar,   -- ��. ���� ������ ������������
    IN inJuridicalAddress	TVarChar,   -- ����������� �����
    IN inOKPO                   TVarChar,   -- ����
    IN inINN	                TVarChar,   -- ���
    IN inNumberVAT	        TVarChar,   -- ����� ������������� ����������� ���
    IN inAccounterName	        TVarChar,   -- ��� ����.
    IN inBankAccount	        TVarChar,   -- �.����
    IN inPhone      	        TVarChar,   -- �������
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS integer AS
$BODY$
DECLARE
  vbJuridicalId_find Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());


   -- �������� ������������ <����>
   IF inOKPO <> ''
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


   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_JuridicalDetails(), inJuridicalId, inOperDate);

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
   -- �.����
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_BankAccount(), ioId, inBankAccount);
   -- �������
   PERFORM lpInsertUpdate_ObjectHistoryString(zc_ObjectHistoryString_JuridicalDetails_Phone(), ioId, inPhone);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.07.14         *

*/
