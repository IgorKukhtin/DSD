-- Function: gpInsertUpdate_Object_AccommodationUnit_Unit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_AccommodationUnit_Unit (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_AccommodationUnit_Unit(
 INOUT ioId	                 Integer   ,    -- ���� �������
    IN inUnitId              Integer   ,    -- ���� ������� �������������
    IN inCode                Integer   ,    -- ��� �������
    IN inName                TVarChar  ,    -- �������� ������� <
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE ObjectName TVarChar;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE(ioId, 0 ) <> 0 AND
      (SELECT ObjectLink_Accommodation_Unit.ChildObjectId FROM ObjectLink AS ObjectLink_Accommodation_Unit
       WHERE ObjectLink_Accommodation_Unit.ObjectId = ioId
         AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()) <> inUnitId
   THEN
     RAISE EXCEPTION '�������� �������� �������� ����� ������ �� ��������������� ������������� <%>.',  (SELECT ValueData FROM Object WHERE Id = inUnitId);   
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Accommodation());

   -- �������� ������������ <������������>
   IF EXISTS (SELECT Object.ValueData FROM Object

                 INNER JOIN ObjectLink AS ObjectLink_Accommodation_Unit
                                       ON ObjectLink_Accommodation_Unit.ChildObjectId = inUnitId
                                      AND ObjectLink_Accommodation_Unit.ObjectId = Object.Id
                                      AND ObjectLink_Accommodation_Unit.DescId = zc_Object_Accommodation_Unit()

              WHERE Object.DescId = zc_Object_Accommodation()
                AND Object.ValueData = inName
                AND Object.Id <> COALESCE(ioId, 0 ))
   THEN
      SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = zc_Object_Accommodation();
      RAISE EXCEPTION '�������� "%" �� ��������� ��� ����������� "%" �� ������������� "%"', inName, ObjectName,
        (SELECT ValueData FROM Object WHERE Id = inUnitId);
   END IF;
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Accommodation(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Accommodation(), vbCode_calc, inName);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_Object_Accommodation_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_AccommodationUnit_Unit(Integer, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������ �.�.
 17.08.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_AccommodationUnit_Unit()