-- Function: gpInsertUpdate_Object_MemberMinus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberMinus(
 INOUT ioId                  Integer   ,    -- ���� ������� < >
    IN inName                TVarChar  ,    -- ���������� 
    IN inBankAccountTo       TVarChar  ,    -- � ����� ���������� �������
    IN inDetailPayment       TVarChar  ,    -- ���������� �������
    IN inINN_to              TVarChar  ,    -- ����/��� ����������
    IN inFromId              Integer   ,    -- ���������� ����
    IN inToId                Integer   ,    -- ���������� ����(���������) / ����������� ����
    IN inBankAccountFromId   Integer   ,    -- IBAN ����������� �������
    IN inBankAccountToId     Integer   ,    -- IBAN ���������� �������
    IN inTotalSumm           TFloat    ,     -- ����� �����
    IN inSumm                TFloat    ,     -- ����� � ��������� ����������
    IN inSession             TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId_to Integer;
   DECLARE vbINN_to TVarChar;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberMinus());
   vbUserId:= inSession;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberMinus(), 0, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_DetailPayment(), ioId, inDetailPayment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_BankAccountTo(), ioId, inBankAccountTo);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_From(), ioId, inFromId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_To(), ioId, inToId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountFrom(), ioId, inBankAccountFromId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountTo(), ioId, inBankAccountToId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_TotalSumm(), ioId, inTotalSumm);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Summ(), ioId, inSumm);

   vbINN_to := (SELECT ObjectString_INN_to.ValueData
                FROM ObjectString AS ObjectString_INN_to
                WHERE ObjectString_INN_to.ObjectId = inToId
                  AND ObjectString_INN_to.DescId = zc_ObjectString_Member_INN()
               );
   vbDescId_to := (SELECT Object.DescId FROM Object WHERE Object.Id = inToId);
               
   IF COALESCE (vbDescId_to,0) <> zc_Object_MemberExternal() AND COALESCE (vbINN_to,'') <> COALESCE (inINN_to,'')
      THEN
           RAISE EXCEPTION '������.���� ��� ������ ��� �������� ���.���.';
   END IF;
   
   IF vbDescId_to = zc_Object_MemberExternal() AND COALESCE (inINN_to,'') <> '' AND COALESCE (vbINN_to,'') <> COALESCE (inINN_to,'')
      THEN
          -- ��������� �������� <>
          PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_MemberExternal_INN(), inToId, inINN_to);
          -- ��������� ��������
          PERFORM lpInsert_ObjectProtocol (inToId, vbUserId);
   END IF;
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.09.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MemberMinus()
