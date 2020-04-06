-- Function: gpInsertUpdate_Object_SunExclusion (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SunExclusion (Integer,Integer,TVarChar, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SunExclusion(
 INOUT ioId              Integer   ,    -- ���� ������� <�������������>
    IN inCode            Integer   ,    -- ��� ������� <>
    IN inName            TVarChar  ,    -- �������� ������� <>
    IN inFromId          Integer   ,    -- 
    IN inToId            Integer   ,    -- 
    IN inisV1            Boolean,       -- 
    IN inisV2            Boolean,       -- 
    IN inisMSC_in        Boolean,       -- 
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;    
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := inSession; 

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_SunExclusion()); 
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_SunExclusion(), vbCode_calc, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SunExclusion_From(), ioId, inFromId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SunExclusion_To(), ioId, inToId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_SunExclusion_V1(), ioId, inisV1);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_SunExclusion_V2(), ioId, inisV2);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_SunExclusion_MSC_in(), ioId, inisMSC_in);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.04.20         *
*/

-- ����
--