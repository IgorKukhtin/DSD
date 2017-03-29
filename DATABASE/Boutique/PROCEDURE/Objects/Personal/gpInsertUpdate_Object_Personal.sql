-- Function: gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������> 
    IN inCode                     Integer   ,    -- ��� ������� <����������>     
    IN inName                     TVarChar  ,    -- �������� ������� <����������>
    IN inMemberId                 Integer   ,    -- ���� ������� <���������� ����> 
    IN inPositionId               Integer   ,    -- ���� ������� <���������> 
    IN inUnitId                   Integer   ,    -- ���� ������� <�������������> 
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Personal_seq'); END IF; 

   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Personal(), inName);

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Personal(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), inCode, inName);
   
   -- ��������� ����� � <���������� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Personal_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
28.03.17                                                           *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Personal()
