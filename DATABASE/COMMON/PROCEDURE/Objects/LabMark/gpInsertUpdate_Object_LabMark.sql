-- Function: gpInsertUpdate_Object_LabMark()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabMark (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LabMark (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LabMark(
 INOUT ioId             Integer   ,     -- ���� ������� <> 
    IN inCode           Integer   ,     -- ��� ������� <> 
    IN inName           TVarChar  ,     -- �������� ������� <>
    IN inLabProductId   Integer   ,     -- 
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_LabMark());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_LabMark());
   
   -- �������� ���� ������������ ��� �������� <>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_LabMark(), inName);
   -- �������� ���� ������������ ��� �������� <>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_LabMark(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_LabMark(), vbCode_calc, inName);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_LabMark_LabProduct(), ioId, inLabProductId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.10.19          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_LabMark()