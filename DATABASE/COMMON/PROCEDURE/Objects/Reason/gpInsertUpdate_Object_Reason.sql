-- Function: gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer,Integer,TVarChar,Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Reason(Integer, Integer, TVarChar, TVarChar, Integer, Integer, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Reason(
 INOUT ioId	             Integer,       -- ���� ������� <>
    IN inCode                Integer,       -- ��� ������� <>
    IN inName                TVarChar,      -- �������� ������� <>
    IN inShort               TVarChar,      -- ����������� ��������
    IN inReturnKindId        Integer,       -- ��� ��������
    IN inReturnDescKindId    Integer,       -- ������� ��������
    IN inPeriodDays          TFloat,        -- ������ � ��. �� "���� ��������"
    IN inPeriodTax           TFloat,        -- ������ � % �� "���� ��������"
    IN inisReturnIn          Boolean,       -- �� ��������� ��� �����. �� �����
    IN inisSendOnPrice       Boolean,       -- �� ��������� ��� �����. � �������
    IN inComment             TVarChar,      -- ����������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Reason());

   -- ��������
   IF COALESCE (inisReturnIn,False) = TRUE AND COALESCE (inisSendOnPrice,False) = TRUE
   THEN
       RAISE EXCEPTION '������.�������� �� ��������� ����� ���� ������� ������ ����.';
   END IF;
   
   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_Reason());
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Reason(), inCode);

   -- �������� ���� ������������ ��� �������� ��������  <������������> + <��� ��������> + <������� ��������>
   IF EXISTS (SELECT 1
              FROM Object
                   INNER JOIN ObjectLink AS ObjectLink_ReturnKind
                                         ON ObjectLink_ReturnKind.ObjectId = Object.Id 
                                        AND ObjectLink_ReturnKind.DescId = zc_ObjectLink_Reason_ReturnKind()
                                        AND ObjectLink_ReturnKind.ChildObjectId = inReturnKindId
                   INNER JOIN ObjectLink AS ObjectLink_ReturnDescKind
                                        ON ObjectLink_ReturnDescKind.ObjectId = Object.Id 
                                       AND ObjectLink_ReturnDescKind.DescId = zc_ObjectLink_Reason_ReturnDescKind()
                                       AND ObjectLink_ReturnDescKind.ChildObjectId = inReturnDescKindId
              WHERE Object.Id <> ioId
                AND TRIM (Object.ValueData) = TRIM (inName))
   THEN
       RAISE EXCEPTION '������.������� �� ���������.';
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Reason(), inCode, inName);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Reason_ReturnKind(), ioId, inReturnKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Reason_ReturnDescKind(), ioId, inReturnDescKindId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Reason_ReturnIn(), ioId, inisReturnIn);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Reason_SendOnPrice(), ioId, inisSendOnPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Reason_Short(), ioId, inShort);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Reason_Comment(), ioId, inComment);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Reason_PeriodDays(), ioId, inPeriodDays);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Reason_PeriodTax(), ioId, inPeriodTax);   
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.11.23         * 
 01.07.21         *
 17.06.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Reason ()
                            