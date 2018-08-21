-- Function: gpInsertUpdate_Object_Accommodation_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Accommodation_Unit (Integer ,Integer ,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Accommodation_Unit(
 INOUT ioId	                 Integer   ,    -- ���� �������
    IN inCode                Integer   ,    -- ��� �������
    IN inName                TVarChar  ,    -- �������� ������� <
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE ObjectName TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
       RAISE EXCEPTION '�� ���������� �������������';
   END IF;
   vbUnitId := vbUnitKey::Integer;


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Accommodation());

   -- �������� ������������ <������������>
   IF EXISTS (SELECT Object.ValueData FROM Object

                 INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                       ON ObjectLink_Accommodation_Unit.ChildObjectId = vbUnitId
                                      AND ObjectLink_Accommodation_Unit.ObjectId = Object.Id
                                      AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

              WHERE Object.DescId = zc_Object_Accommodation()
                AND Object.ValueData = inName
                AND Object.Id <> vbCode_calc)
   THEN
      SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = zc_Object_Accommodation();
      RAISE EXCEPTION '�������� "%" �� ��������� ��� ����������� "%" �� ������������� "%"', inName, ObjectName,
        (SELECT ValueData FROM Object WHERE Id = vbUnitId);
   END IF;
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Accommodation(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Accommodation(), vbCode_calc, inName);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_Object_Accommodation_Unit(), ioId, vbUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Accommodation_Unit(Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������ �.�.
 17.08.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Accommodation_Unit()