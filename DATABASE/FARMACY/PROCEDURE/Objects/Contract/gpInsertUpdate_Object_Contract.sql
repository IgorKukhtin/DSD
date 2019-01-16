-- Function: gpInsertUpdate_Object_Contract()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Contract 
     (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, TDateTime, Tvarchar);
     
CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Contract(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������>
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inJuridicalBasisId        Integer   ,    -- ������ �� ������� ��.����
    IN inJuridicalId             Integer   ,    -- ������ ��  ��.����
    IN inGroupMemberSPId         Integer   ,    -- ������ �� ��������� ��������(���. ������)
    IN inBankAccountId           Integer   ,    -- ������ �� �/����
    IN inMemberId                Integer   ,    -- ������ �� ���. �� ������
    IN inDeferment               Integer   ,    -- ���� ��������
    IN inPercent                 TFloat    ,    -- % ������������� �������
    IN inPercentSP               TFloat    ,    -- % c����� ���.������
    IN inTotalSumm               TFloat    ,    -- ����� ���. ��������
    IN inOrderSumm               TFloat    ,    -- ����������� ����� ��� ������
    IN inOrderSummComment        TVarChar  ,    -- ���������� � ����������� ����� ��� ������
    IN inOrderTime               TVarChar  ,    -- ������������ - ������������ ����� ��������
    IN inComment                 TVarChar  ,    -- ����������
    IN inSigningDate             TDateTime,     -- ���� ���������� ��������
    IN inStartDate               TDateTime,     -- ���� � ������� ��������� �������
    IN inEndDate                 TDateTime,     -- ���� �� ������� ��������� �������    
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Contract());
   vbUserId:= inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Contract());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Contract(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Contract(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Contract(), vbCode_calc, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_JuridicalBasis(), ioId, inJuridicalBasisId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_GroupMemberSP(), ioId, inGroupMemberSPId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_BankAccount(), ioId, inBankAccountId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Contract_Member(), ioId, inMemberId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_Deferment(), ioId, inDeferment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_Percent(), ioId, inPercent);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_PercentSP(), ioId, inPercentSP);
   -- ��������� �������� <����������� ����� ��� ������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_OrderSumm(), ioId, inOrderSumm);
   -- ��������� �������� <����� ���. ��������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Contract_TotalSumm(), ioId, inTotalSumm);
   
   -- ���� ����� �������� ����� �� ���� ���������� �� ����������
   IF COALESCE (inName, '') <> '' 
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Signing(), ioId, inSigningDate);
   ELSE 
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Signing(), ioId, NULL);   
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Start(), ioId, inStartDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_End(), ioId, inEndDate);
   -- ��������� �������� <�����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_Comment(), ioId, inComment);
   -- ��������� �������� <������������ - ������������ ����� ��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderTime(), ioId, inOrderTime);
      -- ��������� �������� <���������� � ����������� ����� ��� ������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Contract_OrderSumm(), ioId, inOrderSummComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.19         *
 24.09.18         * add inMemberId
 20.08.18         * inTotalSumm
 14.02.18         *
 08.08.17         *
 03.05.17         * add BankAccountId
 16.03.17         * inPercentSP
 05.03.17         * inGroupMemberSPId
 08.12.16         * inPercent
 21.01.16         *
 21.09.14                         * 
 01.07.14         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Contract ()                            
