-- Function: gpInsertUpdate_Object_MemberMinus()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberMinus(Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberMinus(
 INOUT ioId                    Integer   ,    -- ���� ������� < >
    IN inName                  TVarChar  ,    -- ���������� 
    IN inBankAccountTo         TVarChar  ,    -- � ����� ���������� �������
    IN inDetailPayment         TVarChar  ,    -- ���������� �������
    IN inINN_to                TVarChar  ,    -- ����/��� ����������
    IN inToShort               TVarChar  ,    -- ��. ���� (����������� ��������) 
    IN inNumber                TVarChar  ,    -- � ��������������� �����
    IN inFromId                Integer   ,    -- ���������� ����
    IN inToId                  Integer   ,    -- ���������� ����(���������) / ����������� ����
 INOUT ioBankAccountFromId     Integer   ,    -- IBAN ����������� �������
    IN inBankAccountToId       Integer   ,    -- IBAN ���������� �������
    IN inBankAccountId_main    Integer   ,    --
   OUT outBankAccountFromName  TVarChar  ,    --
    IN inTotalSumm             TFloat    ,     -- ����� �����
    IN inSumm                  TFloat    ,     -- ����� � ��������� ����������
    IN inTax                   TFloat    ,     -- % ���������
   OUT outisToShort            Boolean   ,     -- > 36 ��������
    IN inisChild               Boolean   ,     -- �������� (��/���)
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId_to Integer;
   DECLARE vbINN_to TVarChar;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberMinus());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- inBankAccountFromId ��������� �� �������� �������� (inBankAccountId_main) ��� ����������, ��� ����� ������ � ����� � "IBAN �����������" �� ��������
   IF COALESCE (ioBankAccountFromId,0) = 0 AND COALESCE (inBankAccountId_main,0) <> 0
   THEN
       ioBankAccountFromId := inBankAccountId_main;
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberMinus(), 0, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_DetailPayment(), ioId, inDetailPayment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_BankAccountTo(), ioId, inBankAccountTo);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_ToShort(), ioId, inToShort);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberMinus_Number(), ioId, inNumber);
      
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_From(), ioId, inFromId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_To(), ioId, inToId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountFrom(), ioId, ioBankAccountFromId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MemberMinus_BankAccountTo(), ioId, inBankAccountToId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_MemberMinus_Child(), ioId, inisChild);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_TotalSumm(), ioId, inTotalSumm);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Summ(), ioId, inSumm);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MemberMinus_Tax(), ioId, inTax);

   SELECT CASE WHEN Object_To.DescId = zc_Object_Juridical() THEN ObjectHistory_JuridicalDetails_View.OKPO
               ELSE ObjectString_INN_to.ValueData
          END              AS INN_to
        , Object_To.DescId AS DescId
 INTO vbINN_to, vbDescId_to
   FROM Object AS Object_to
        LEFT JOIN ObjectString AS ObjectString_INN_to
                               ON ObjectString_INN_to.ObjectId = Object_To.Id
                              AND ObjectString_INN_to.DescId IN (zc_ObjectString_MemberExternal_INN(), zc_ObjectString_Member_INN())
                              AND Object_To.DescId <> zc_Object_Juridical()
        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_To.Id
                                                     AND Object_To.DescId = zc_Object_Juridical()
   WHERE Object_to.Id = inToId;
   
   
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
   
   outBankAccountFromName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = ioBankAccountFromId);
   outisToShort := (SELECT CASE WHEN LENGTH (Object.ValueData) > 36 THEN TRUE ELSE FALSE END :: Boolean
                    FROM Object
                    WHERE Object.Id = inToId);
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.21         *
 04.09.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MemberMinus()
