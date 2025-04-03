-- Function: gpInsertUpdate_Object_PersonalServiceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar
                                                                , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar
                                                                , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PersonalServiceList(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar
                                                                , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PersonalServiceList(
 INOUT ioId                    Integer   ,     -- ���� ������� <> 
    IN inCode                  Integer   ,     -- ��� �������  
    IN inName                  TVarChar  ,     -- �������� ������� 
    IN inJuridicalId           Integer   ,     -- ��. ����
    IN inPaidKindId            Integer   ,     -- 
    IN inBranchId              Integer   ,     -- 
    IN inBankId                Integer   ,     -- 
    IN inMemberHeadManagerId   Integer   ,     -- ��� ����(�������������� ��������)
    IN inMemberManagerId       Integer   ,     -- ��� ����(��������)
    IN inMemberBookkeeperId    Integer   ,     -- ��� ����(���������)
    IN inPersonalHeadId        Integer   ,     -- ������������ �������������
    IN inBankAccountId         Integer   ,     --
    IN inPSLExportKindId       Integer   ,     -- 
    IN inPersonalServiceListId_AvanceF2 Integer , --  �� ����� ��������� "�����" ����������� ������ � "����� �� (����) - 2�."
    IN inCompensation          TFloat    ,     -- ����� �����������
    IN inSummAvance            TFloat    ,     -- 
    IN inSummAvanceMax         TFloat    ,     -- 
    IN inHourAvance            TFloat    ,     -- 
    IN inKoeffSummCardSecond   TVarChar,      -- ����� ��� �������� ��������� ���� 2�.   ����� * �� 1000, �.�. ����� ������ ����� ���, 
    IN inisSecond              Boolean   ,     -- 
    IN inisRecalc              Boolean   ,     -- 
    IN inisBankOut             Boolean   ,     -- 
    IN inisDetail              Boolean   ,     --
    IN inisAvanceNot           Boolean   ,     --
    IN inisBankNot             Boolean   ,     -- ��������� �� ������� ������� ���� 2�
    IN inisCompensationNot     Boolean   ,     -- ��������� �� ������� ����������� ��� �������
    IN inisNotAuto             Boolean   ,     -- ��������� �� ����-���������� ��
    IN inisNotRound            Boolean   ,     -- ��������� �� ���������� �� �����
    IN inContentType           TVarChar   ,     --
    IN inOnFlowType            TVarChar   ,     --
   -- IN inMemberId            Integer   ,     -- ��� ����(������������)
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PersonalServiceList());
   vbUserId:= lpGetUserBySession (inSession);

--RAISE EXCEPTION '�����a <%>', inKoeffSummCardSecond;

   IF TRIM (COALESCE (inName , '')) = ''
   THEN
       RAISE EXCEPTION '�����a.�������� ��������� �� ���������.';
   END IF;
   
   
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PersonalServiceList());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PersonalServiceList(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PersonalServiceList(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PersonalServiceList(), vbCode_calc, inName);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Juridical(), ioId, inJuridicalId);

   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_PaidKind(), ioId, inPaidKindId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Branch(), ioId, inBranchId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Bank(), ioId, inBankId);
   
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberHeadManager(), ioId, inMemberHeadManagerId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberManager(), ioId, inMemberManagerId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_MemberBookkeeper(), ioId, inMemberBookkeeperId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_PersonalHead(), ioId, inPersonalHeadId);

   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_BankAccount(), ioId, inBankAccountId);
   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_PSLExportKind(), ioId, inPSLExportKindId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PersonalServiceList_OnFlowType(), ioId, inOnFlowType);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PersonalServiceList_ContentType(), ioId, inContentType);

   -- ��������� ��-�� 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Avance_F2(), ioId, inPersonalServiceListId_AvanceF2);


   -- ��������� ��-�� 
   --PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PersonalServiceList_Member(), ioId, inMemberId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Second(), ioId, inisSecond);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Recalc(), ioId, inisRecalc);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_BankOut(), ioId, inisBankOut);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_Detail(), ioId, inisDetail);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_AvanceNot(), ioId, inisAvanceNot);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_BankNot(), ioId, inisBankNot);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_CompensationNot(), ioId, inisCompensationNot);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_NotAuto(), ioId, inisNotAuto);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PersonalServiceList_NotRound(), ioId, inisNotRound);
       
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_Compensation(), ioId, inCompensation);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_KoeffSummCardSecond(), ioId, (CAST (inKoeffSummCardSecond AS NUMERIC (16,10)) * 1000));
 
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_SummAvance(), ioId, inSummAvance);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_SummAvanceMax(), ioId, inSummAvanceMax);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PersonalServiceList_HourAvance(), ioId, inHourAvance);          

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.04.25         * inisNotRound
 21.03.25         * inisNotAuto
 12.02.24         * inisBankNot
 29.01.24         * inisCompensationNot
 14.03.23         * 
 09.03.22         * inPersonalHeadId
 18.11.21         *
 28.04.21         * inisDetail
 18.03.21         * 
 17.11.20         * add inisBankOut
 17.02.20         * add inisRecalc
 27.01.20         * add inCompensation
 20.02.17         * add inisSecond
 26.08.15         * add inMemberId
 15.04.15         * add PaidKind, Branch, Bank
 12.09.14         *
*/

-- ����
-- select * from gpInsertUpdate_Object_PersonalServiceList(ioId := 957950 , inCode := 226 , inName := '��������� ���� ��' , inJuridicalId := 131931 , inPaidKindId := 4 , inBranchId := 0 , inBankId := 0 , inMemberHeadManagerId := 0 , inMemberManagerId := 0 , inMemberBookkeeperId := 0 , inisSecond := 'False' , inisRecalc:=false,  inSession := '5');
