 -- Function: gpInsertUpdate_Object_Language()

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_Language (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Language(
   INOUT ioId                       Integer,     -- ��
      IN incode                     Integer,     -- ��� 
      IN inName                     TVarChar,    -- ������������ 
      IN inComment                  TVarChar,    -- ����������
      IN inValue1                   TVarChar, 
      IN inValue2                   TVarChar, 
      IN inValue3                   TVarChar, 
      IN inValue4                   TVarChar, 
      IN inValue5                   TVarChar, 
      IN inValue6                   TVarChar, 
      IN inValue7                   TVarChar, 
      IN inValue8                   TVarChar, 
      IN inValue9                   TVarChar, 
      IN inValue10                  TVarChar, 
      IN inValue11                  TVarChar, 
      IN inValue12                  TVarChar, 
      IN inValue13                  TVarChar, 
      IN inValue14                  TVarChar,
      IN inValue15                  TVarChar,
      IN inValue16                  TVarChar,
      IN inValue17                  TVarChar,
      IN inSession                  TVarChar     -- ������������
      )
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Language());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Language()); 
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Language(), inName);
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Language(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Language(), vbCode_calc, inName);
   
   -- ��������� ��-�� <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Comment(), ioId, inComment);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value1(), ioId, inValue1);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value2(), ioId, inValue2);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value3(), ioId, inValue3);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value4(), ioId, inValue4);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value5(), ioId, inValue5);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value6(), ioId, inValue6);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value7(), ioId, inValue7);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value8(), ioId, inValue8);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value9(), ioId, inValue9);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value10(), ioId, inValue10);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value11(), ioId, inValue11);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value12(), ioId, inValue12);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value13(), ioId, inValue13);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value14(), ioId, inValue14);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value15(), ioId, inValue15);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value16(), ioId, inValue16);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Language_Value17(), ioId, inValue17);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.06.19         *
 10.10.18         *
 23.10.17         *
*/

-- ����
-- 
