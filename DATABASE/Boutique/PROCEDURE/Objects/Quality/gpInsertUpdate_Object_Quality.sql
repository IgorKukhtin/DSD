-- Function: gpInsertUpdate_Object_Quality  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Quality (Integer, Integer, TVarChar, TFloat, TVarChar, TVarChar, TVarChar,Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Quality(
 INOUT ioId                Integer   ,    -- ���� ������� < �����/��������> 
    IN inCode              Integer   ,    -- ��� ������� <>
    IN inName              TVarChar  ,
    IN inNumberPrint       TFloat    ,
    IN inMemberMain        TVarChar  ,
    IN inMemberTech        TVarChar  ,
    IN inComment           TVarChar  ,
    IN inJuridicalId       Integer   ,    -- 
    IN inRetailId          Integer   ,    -- 
    IN inTradeMarkId       Integer   ,    -- 
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Quality());
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Quality()); 
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Quality(), vbCode_calc);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Quality(), vbCode_calc, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Quality_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Quality_Retail(), ioId, inRetailId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Quality_TradeMark(), ioId, inTradeMarkId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Quality_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Quality_MemberMain(), ioId, inMemberMain);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Quality_MemberTech(), ioId, inMemberTech);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Quality_NumberPrint(), ioId, inNumberPrint);
 

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.04.15         * add
 09.02.15         *

*/

-- ����
-- select * from gpInsertUpdate_Object_Quality(ioId := 0 , inCode := 1 , inName := '�����' , inPhone := '4444' , Mail := '���@kjjkj' , Comment := '' , inJuridicalId := 258441 , inJuridicalId := 0 , inContractId := 0 , inQualityKindId := 153272 ,  inSession := '5');
