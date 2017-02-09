-- Function: gpInsertUpdate_Object_MobileTariff  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MobileTariff2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MobileTariff2(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inMonthly                  TFloat    ,    -- ����������� ���������
    IN inPocketMinutes            TFloat    ,    -- ���������� ����� � ������
    IN inPocketSMS                TFloat    ,    -- ���������� ��� � ������
    IN inPocketInet               TFloat    ,    -- ���������� �� ��������� � ������
    IN inCostSMS                  TFloat    ,    -- ��������� ��� ��� ������
    IN inCostMinutes              TFloat    ,    -- ��������� 1 ������ ��� ������
    IN inCostInet                 TFloat    ,    -- ��������� 1 �� ��������� ��� ������
    IN inComment                  TVarChar  ,    -- �����������
    IN inContractId               Integer   ,    -- �������
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
   DECLARE vbObjectId Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MobileTariff());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MobileTariff()); 
   

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MobileTariff(), vbCode_calc, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_Monthly(), ioId, inMonthly);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_PocketMinutes(), ioId, inPocketMinutes);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_PocketSMS(), ioId, inPocketSMS);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_PocketInet(), ioId, inPocketInet);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_CostSMS(), ioId, inCostSMS);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_CostMinutes(), ioId, inCostMinutes);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileTariff_CostInet(), ioId, inCostInet);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MobileTariff_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileTariff_Contract(), ioId, inContractId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.10.16         * parce
 23.09.16         *
*/

-- ����
-- select * from gpInsertUpdate_Object_MobileTariff2(ioId := 0 , inCode := 1 , inName := '�����' , inMonthly := '4444' , PocketMinutes := '���@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inContractId := 0 , inMobileTariffKindId := 153272 ,  inSession := '5');
