-- Function: gpInsertUpdate_Object_MobileEmployee  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_MobileEmployee2 (Integer,Integer,TVarChar,TFloat,TFloat,TFloat,TVarChar,Integer,Integer,Integer,Integer,Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_MobileEmployee2(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
    IN inCode                     Integer   ,    -- ��� ������� <>
    IN inName                     TVarChar  ,    -- �������� ������� <>
    IN inLimit                    TFloat    ,    -- �����
    IN inDutyLimit                TFloat    ,    -- ��������� �����
    IN inNavigator                TFloat    ,    -- ������ ���������
    IN inComment                  TVarChar  ,    -- �����������
    IN inPersonalId               Integer   ,    -- ����������
    IN inMobileTariffId           Integer   ,    -- ������ ��������� ����������
    IN inRegionId                 Integer   ,    -- ������
    IN inMobilePackId             Integer   ,    -- �������� ������
    IN inUserId                   Integer        -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbCode_calc Integer; 

BEGIN
   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_MobileEmployee()); 
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MobileEmployee(), vbCode_calc, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_Limit(), ioId, inLimit);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_DutyLimit(), ioId, inDutyLimit);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MobileEmployee_Navigator(), ioId, inNavigator);
  
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MobileEmployee_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_Personal(), ioId, inPersonalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_MobileTariff(), ioId, inMobileTariffId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_Region(), ioId, inRegionId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_MobileEmployee_MobilePack(), ioId, inMobilePackId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.07.21         *
 05.10.16         * parce
 01.10.16         *
*/

-- ����
-- select * from lpInsertUpdate_Object_MobileEmployee2(ioId := 0 , inCode := 1 , inName := '�����' , inLimit := '4444' , DutyLimit := '���@kjjkj' , Comment := '' , inPartnerId := 258441 , inJuridicalId := 0 , inPersonalId := 0 , inMobileEmployeeKindId := 153272 ,  inSession := '5');
