-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, TFloat, Boolean, Boolean, 
  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������������>
    IN inCode                    Integer   ,    -- ��� ������� <�������������>
    IN inName                    TVarChar  ,    -- �������� ������� <�������������>
    IN inisCorporate             Boolean   ,    -- ������� ���� �� ������������� ��� ����������� ���� 
    IN inRetailId                Integer   ,    -- ������ �� �������������
    IN inPercent                 TFloat    ,    
    IN inPayOrder                TFloat    ,    -- ������� �������
    IN inisLoadBarcode           Boolean   ,    -- ������ �����-�����
    IN inisDeferred              Boolean   ,    -- ���������� - ����� ������ "�������"
    IN inCBName                  TVarChar  ,    -- ������ �������� ���������� ��� ������ �����
    IN inCBMFO                   TVarChar  ,    -- ��� ��� ������ �����
    IN inCBAccount               TVarChar  ,    -- ��������� ���� ��� ������ �����
    IN inCBAccountOld            TVarChar  ,    -- ��������� ���� ������ ��� ������ �����
    IN inCBPurposePayment        TVarChar  ,    -- ���������� ������� ��� ������ �����
    IN inCodeRazom               Integer   ,    -- ��� � ������� "�����"
    IN inCodeMedicard            Integer   ,    -- ��� � ������� "Medicard"
    IN inCodeOrangeCard          Integer   ,    -- ��� � ������� "����� ����"
    IN inisUseReprice            boolean   ,    -- ��������� � ��������������
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Juridical());
   vbUserId:= inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_Juridical());
   -- !!! IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Juridical(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Juridical(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Juridical(), vbCode_calc, inName);

   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), ioId, inRetailId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_isCorporate(), ioId, inisCorporate);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_Percent(), ioId, inPercent);
   
   -- ��������� �������� <������� �������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_PayOrder(), ioId, inPayOrder);

   -- ��������� �������� <��� � ������� "�����">
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CodeRazom(), ioId, inCodeRazom);
   -- ��������� �������� <��� � ������� "Medicard">
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CodeMedicard(), ioId, inCodeMedicard);
   -- ��������� �������� <��� � ������� "����� ����">
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_CodeOrangeCard(), ioId, inCodeOrangeCard);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_LoadBarcode(), ioId, inisLoadBarcode);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_Deferred(), ioId, inisDeferred);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_UseReprice(), ioId, inisUseReprice);

   -- ��������� �������� <������ �������� ���������� ��� ������ �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBName(), ioId, inCBName);
   -- ��������� �������� <��� ��� ������ �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBMFO(), ioId, inCBMFO);
   -- ��������� �������� <��������� ���� ��� ������ �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBAccount(), ioId, inCBAccount);
   -- ��������� �������� <��������� ���� ������ ��� ������ �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBAccountOld(), ioId, inCBAccountOld);
   -- ��������� �������� <���������� ������� ��� ������ �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_CBPurposePayment(), ioId, inCBPurposePayment);

   -- ��������� ��������
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  �������� �.�.  ������ �.�.
 10.06.20                                                                                      * 
 06.09.19                                                                                      * 
 22.02.18         * dell inOrderSumm, inOrderSummComment, inOrderTime
 17.08.17         *              
 27.06.17                                                                        *
 14.01.17         *
 02.12.15                                                         * PayOrder
 10.04.15                        * 
 01.07.14         * 

*/

-- ����
--