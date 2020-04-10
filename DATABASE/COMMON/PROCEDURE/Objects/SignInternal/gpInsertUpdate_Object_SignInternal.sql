-- Function: gpInsertUpdate_Object_SignInternal(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SignInternal (Integer, Integer, TVarChar, Tfloat, Tfloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_SignInternal (Integer, Integer, TVarChar, Tfloat, Tfloat, TVarChar, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_SignInternal(
 INOUT ioId               Integer   , -- ���� ������� 
    IN inCode             Integer   , -- �������� <���>
    IN inName             TVarChar  , -- �������� <������������>
    IN inMovementDescId   Tfloat    , -- 
    IN inObjectDescId     Tfloat    , -- 
    IN inComment          TVarChar  , -- 
    IN inObjectId         Integer   , -- ������ �� �������������
    IN inisMain           Boolean   , --
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_SignInternal());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:= lfGet_ObjectCode (inCode, zc_Object_SignInternal());

   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_SignInternal(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_SignInternal(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId:= ioId, inDescId:= zc_Object_SignInternal(), inObjectCode:= vbCode_calc, inValueData:= inName);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_SignInternal_Object(), ioId, inObjectId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SignInternal_MovementDesc(), ioId, inMovementDescId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_SignInternal_ObjectDesc(), ioId, inObjectDescId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_SignInternal_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_SignInternal_Main(), ioId, inisMain);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.04.20         *
 22.08.16         *
 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_SignInternal()
