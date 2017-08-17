-- Function: gpInsertUpdate_Object_Juridical()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, TFloat, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Juridical(
 INOUT ioId                      Integer   ,   	-- ���� ������� <�������������>
    IN inCode                    Integer   ,    -- ��� ������� <�������������>
    IN inName                    TVarChar  ,    -- �������� ������� <�������������>
    IN inisCorporate             Boolean   ,    -- ������� ���� �� ������������� ��� ����������� ���� 
    IN inRetailId                Integer   ,    -- ������ �� �������������
    IN inPercent                 TFloat    ,    
    IN inPayOrder                TFloat    ,    -- ������� �������
    IN inOrderSumm               TFloat    ,    -- ����������� ����� ��� ������
    IN inOrderSummComment        TVarChar  ,    -- ���������� � ����������� ����� ��� ������
    IN inOrderTime               TVarChar  ,    -- ������������ - ������������ ����� ��������
    IN inisLoadBarcode           Boolean   ,    -- ������ �����-�����
    IN inisDeferred              Boolean   ,    -- ���������� - ����� ������ "�������"
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

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Juridical_OrderSumm(), ioId, inOrderSumm);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_OrderSumm(), ioId, inOrderSummComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Juridical_OrderTime(), ioId, inOrderTime);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_LoadBarcode(), ioId, inisLoadBarcode);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Juridical_Deferred(), ioId, inisDeferred);

   -- ��������� ��������
   --PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Juridical (Integer, Integer, TVarChar, Boolean, Integer, TFloat, TFloat, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  �������� �.�.
 17.08.17         *              
 27.06.17                                                                        *
 14.01.17         *
 02.12.15                                                         * PayOrder
 10.04.15                        * 
 01.07.14         * 

*/

-- ����
-- select * from gpInsertUpdate_Object_Juridical(ioId := 0 , inCode := 1 , inName := 'sdggsd' , inRetailId := 0 , inisCorporate := 'False' ,  inSession := '8');