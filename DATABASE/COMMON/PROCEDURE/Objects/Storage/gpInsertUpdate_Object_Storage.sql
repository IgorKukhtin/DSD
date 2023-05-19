-- Function: gpInsertUpdate_Object_Storage()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Storage(
 INOUT ioId             Integer   ,     -- ���� ������� <����� ��������> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inName           TVarChar  ,     -- �������� ������� 
    IN inComment        TVarChar  ,     -- ����������
    IN inAddress        TVarChar  ,     -- ����� �����
    IN inUnitId         Integer   ,     -- �������������
    IN inAreaUnitName   TVarChar  ,     -- �������
    IN inRoom           TVarChar  ,     -- �������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;                                 
   DECLARE vbCode_calc Integer;
   DECLARE vbAreaUnitId Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Storage());
   vbUserId:= lpGetUserBySession (inSession);


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Storage());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Storage(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Storage(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Storage(), vbCode_calc, inName);

   -- ��������� �������� <�����>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Address(), ioId, inAddress);
   -- ��������� �������� <����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Comment(), ioId, inComment);
   -- ��������� �������� <�������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Room(), ioId, inRoom);
   -- ��������� ����� � <�������������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Storage_Unit(), ioId, inUnitId);
   
   vbAreaUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_AreaUnit() AND TRIM (UPPER (Object.ValueData)) = TRIM (UPPER (inAreaUnitName)) );
   IF COALESCE (vbAreaUnitId,0) = 0
   THEN
       --������� ����� �������
       vbAreaUnitId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_AreaUnit (ioId      := 0    :: Integer
                                                           , inCode    := 0    :: Integer
                                                           , inName    := TRIM (inAreaUnitName) ::TVarChar
                                                           , inSession := inSession             :: TVarChar
                                                            ) AS tmp);
   END IF;
   
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Storage_AreaUnit(), ioId, vbAreaUnitId);   
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.05.23         *
 26.07.16         *
 28.07.14         *
*/

-- ����
--