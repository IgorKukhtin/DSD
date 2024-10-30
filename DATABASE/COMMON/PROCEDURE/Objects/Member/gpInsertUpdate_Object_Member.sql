 -- Function: gpInsertUpdate_Object_Member(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
*/
/*DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, Boolean, Boolean, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                    , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId	                 Integer   ,    -- ���� ������� <���������� ����> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� <
    IN inIsOfficial          Boolean   ,    -- �������� ����������
    IN inIsNotCompensation   Boolean   ,    -- ��������� �� ����������� �������
    IN inCode1�              TVarChar  ,    -- ��� 1�
    IN inINN                 TVarChar  ,    -- ��� ���
    IN inDriverCertificate   TVarChar  ,    -- ������������ ������������� 
    IN inCard                TVarChar  ,    -- � ���������� ����� ��
    IN inCardSecond          TVarChar  ,    -- � ���������� ����� �� - ������ �����
    IN inCardChild           TVarChar  ,    -- � ���������� ����� �� - - �������� (���������)
    IN inCardIBAN            TVarChar  ,    -- � ���������� ����� IBAN �� - ������ �����
    IN inCardIBANSecond      TVarChar  ,    -- � ���������� ����� IBAN �� - ������ �����
    IN inCardBank            TVarChar  ,    -- � ���������� ����� ��
    IN inCardBankSecond      TVarChar  ,    -- � ���������� ����� �� - ������ �����
    
    IN inCardBankSecondTwo   TVarChar  ,    --
    IN inCardIBANSecondTwo   TVarChar  ,    --
    IN inCardSecondTwo       TVarChar  ,    --
    IN inCardBankSecondDiff  TVarChar  ,    --  
    IN inCardIBANSecondDiff  TVarChar  ,    --
    IN inCardSecondDiff      TVarChar  ,    --
    
    IN inPhone               TVarChar  ,    --
    IN inComment             TVarChar  ,    -- ���������� 

    IN inBankId_Top            Integer   ,    --
    IN inBankSecondId_Top      Integer   ,    --
    IN inBankSecondTwoId_Top   Integer   ,    --
    IN inBankSecondDiffId_Top  Integer   ,    --
    
    IN inBankId              Integer   ,    --
    IN inBankSecondId        Integer   ,    --
    IN inBankChildId         Integer   ,    --
    IN inBankSecondTwoId     Integer   ,    --
    IN inBankSecondDiffId    Integer   ,    --
    IN inInfoMoneyId         Integer   ,    --
    IN inUnitMobileId        Integer   ,    --�������������(������ ���������) 
   OUT outBankName           TVarChar  ,    --   
   OUT outBankSecondName     TVarChar  ,    --
   OUT outBankSecondTwoName  TVarChar  ,    --
   OUT outBankSecondDiffName TVarChar  ,    --
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
    
   --��������
   IF COALESCE (inName,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <���>.' ; END IF;  

   -- ����������� - �������� ���������� ��� ��� ���
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 11355513)
   THEN
       IF COALESCE (inPhone,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <�������>.' ; END IF;
       IF COALESCE (inINN,'') = '' THEN RAISE EXCEPTION '������. �� �������� �������� <���>.' ; END IF;
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Member());   
   
   --�������������� ��������� - 
   IF COALESCE (inBankId_Top,0) <> 0           THEN inBankId           = inBankId_Top;           END IF;
   IF COALESCE (inBankSecondId_Top,0) <> 0     THEN inBankSecondId     = inBankSecondId_Top;     END IF;
   IF COALESCE (inBankSecondTwoId_Top,0) <> 0  THEN inBankSecondTwoId  = inBankSecondTwoId_Top;  END IF;
   IF COALESCE (inBankSecondDiffId_Top,0) <> 0 THEN inBankSecondDiffId = inBankSecondDiffId_Top; END IF;
   
   -- �������� ������������ <������������>
   IF TRIM (inINN) = ''
   THEN 
       PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName);
   END IF;
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), vbCode_calc);
   -- �������� ������������ <INN>      ���� ������ � �������� ����� ����� �� ����
   IF TRIM (inINN) <> '' AND LEFT (inINN, 8) <> '00000000'
   THEN
       IF EXISTS (SELECT ObjectString.ObjectId
                  FROM ObjectString
                  WHERE TRIM (ObjectString.ValueData) = TRIM (inINN)
                    AND ObjectString.ObjectId <> COALESCE (ioId, 0)
                    AND ObjectString.DescId = zc_ObjectString_Member_INN())
       THEN
           RAISE EXCEPTION '������. ��� ��� <%> ��� ���������� � <%>.', TRIM (inINN), lfGet_Object_ValueData ((SELECT ObjectString.ObjectId
                                                                                                               FROM ObjectString
                                                                                                               WHERE TRIM (ObjectString.ValueData) = TRIM (inINN)
                                                                                                                 AND ObjectString.ObjectId <> COALESCE (ioId, 0)
                                                                                                                 AND ObjectString.DescId = zc_ObjectString_Member_INN()
                                                                                                             ));
       END IF;
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- ��������� �������� <�������� ����������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);
   -- ��������� �������� <��������� �� ����������� �������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_NotCompensation(), ioId, inIsNotCompensation);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Code1C(), ioId, inCode1�);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_INN(), ioId, inINN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_DriverCertificate(), ioId, inDriverCertificate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Card(), ioId, inCard);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecond(), ioId, inCardSecond);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardChild(), ioId, inCardChild); 

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBAN(), ioId, inCardIBAN);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecond(), ioId, inCardIBANSecond);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBank(), ioId, inCardBank);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBankSecond(), ioId, inCardBankSecond);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBankSecondTwo(), ioId, inCardBankSecondTwo);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecondTwo(), ioId, inCardIBANSecondTwo);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecondTwo(), ioId, inCardSecondTwo);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardBankSecondDiff(), ioId, inCardBankSecondDiff);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardSecondDiff(), ioId, inCardSecondDiff);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_CardIBANSecondDiff(), ioId, inCardIBANSecondDiff);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Phone(), ioId, inPhone);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Comment(), ioId, inComment);
   
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_InfoMoney(), ioId, inInfoMoneyId);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_Bank(), ioId, inBankId);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecond(), ioId, inBankSecondId);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankChild(), ioId, inBankChildId);
      -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecondTwo(), ioId, inBankSecondTwoId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_BankSecondDiff(), ioId, inBankSecondDiffId);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Member_UnitMobile(), ioId, inUnitMobileId);

   -- �������������� <���������� ����> � <����������>
   UPDATE Object SET ValueData = inName, ObjectCode = vbCode_calc
   WHERE Id IN (SELECT ObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Member() AND ChildObjectId = ioId);  

   --
   outBankName           := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankId);
   outBankSecondName     := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankSecondId);
   outBankSecondTwoName  := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankSecondTwoId);
   outBankSecondDiffName := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Bank() AND Object.Id = inBankSecondDiffId);
    
   IF vbUserId = 9457 THEN RAISE EXCEPTION 'Test. OK'; END IF;
    
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.10.24         * Code1C
 15.03.24         * Phone
 27.09.21         *
 09.09.21         *
 06.02.20         * inIsNotCompensation
 09.09.19         * inCardIBAN, inCardIBANSecond
 03.03.17         * add Bank, BankSecond, BankChild
 20.02.17         * add CardSecond,inCardChild
 25.03.16         * add Card
 19.02.15         * add inInfoMoneyId
 12.09.14                                        * add inIsOfficial
 13.12.13                                        * del inAccessKeyId
 08.12.13                                        * add inAccessKeyId
 30.10.13                         * �������������� <���������� ����> � <����������>
 09.10.13                                        * �������� ����� ���
 01.10.13         *  add DriverCertificate, Comment              
 01.07.13         *
*/

-- !!!�������������� <���������� ����> � <����������>!!!
-- UPDATE Object SET ValueData = Object2.ValueData , ObjectCode = Object2.ObjectCode from (SELECT Object.*, ObjectId FROM ObjectLink join Object on Object.Id = ObjectLink.ChildObjectId WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Member()) as Object2 WHERE Object.Id  = Object2. ObjectId;
-- ����
-- SELECT * FROM gpInsertUpdate_Object_Member()
