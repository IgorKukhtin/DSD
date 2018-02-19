-- Function: gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal (Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal(
 INOUT ioId                       Integer   ,    -- ���� ������� <����������> 
 INOUT ioCode                     Integer   ,    -- ��� ������� <����������>     
    IN inName                     TVarChar  ,    -- �������� ������� <����������>
    IN inMemberId                 Integer   ,    -- ���� ������� <���������� ����> 
    IN inPositionId               Integer   ,    -- ���� ������� <���������> 
    IN inUnitId                   Integer   ,    -- ���� ������� <�������������> 
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Personal_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Personal_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- ��������
   IF ioId > 0 AND vbUserId = zc_User_Sybase()
   THEN
       -- <�������������>
       IF inPositionId = 0 THEN inPositionId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Position() AND ObjectId = ioId); END IF;
       -- <�������������>
       IF inUnitId = 0 THEN inUnitId:= (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Unit() AND ObjectId = ioId); END IF;
   END IF;


   -- ��������
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <���> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inUnitId, 0) = 0 AND vbUserId <> zc_User_Sybase()
   THEN
       RAISE EXCEPTION '������. <�������������> �� �������.';
   END IF;
   -- ��������
   IF COALESCE (inPositionId, 0) = 0 AND vbUserId <> zc_User_Sybase()
   THEN
       RAISE EXCEPTION '������. <���������> �� �������.';
   END IF;


   -- �������� ���� ������������ ��� �������� <��������>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Personal(), (SELECT Object.ValueData FROM Object WHERE Object.Id = inMemberId));
                                          
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Personal(), ioCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Personal(), ioCode, (SELECT Object.ValueData FROM Object WHERE Object.Id = inMemberId));
   
   -- ��������� ����� � <���������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Member(), ioId, inMemberId);
   -- ��������� ����� � <���������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), ioId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
13.05.17                                                           *
08.05.17                                                           *
28.03.17                                                           *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Personal()
