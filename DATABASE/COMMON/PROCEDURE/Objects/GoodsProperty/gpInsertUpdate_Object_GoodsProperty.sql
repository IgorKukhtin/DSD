-- Function: gpInsertUpdate_Object_GoodsProperty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsProperty (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsProperty (Integer, Integer, TVarChar, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsProperty(
 INOUT ioId                  Integer   ,   	-- ���� ������� <������������� ������� �������> 
    IN inCode                Integer   ,    -- ��� ������� <������������� ������� �������> 
    IN inName                TVarChar  ,    -- �������� ������� <������������� ������� �������> 
    IN inStartPosInt         TFloat    ,    -- ����� ����� ���� � ����� ����(��������� �������)
    IN inEndPosInt           TFloat    ,    -- ����� ����� ���� � ����� ����(��������� �������)
    IN inStartPosFrac        TFloat    ,    -- ������� ����� ���� � ����� ����(��������� �������)
    IN inEndPosFrac          TFloat    ,    -- ������� ����� ���� � ����� ����(��������� �������)
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbCode Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsProperty());

   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_GoodsProperty());
   
   -- �������� ���� ������������ ��� �������� <������������ ��������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsProperty(), inName);
   -- �������� ���� ������������ ��� �������� <��� ��������������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsProperty(), vbCode);

   -- ��������� <������>  
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsProperty(), inCode, inName);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_StartPosInt(), ioId, inStartPosInt);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_EndPosInt(), ioId, inEndPosInt);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_StartPosFrac(), ioId, inStartPosFrac);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsProperty_EndPosFrac(), ioId, inEndPosFrac);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsProperty (Integer, Integer, TVarChar, TVarChar)  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.15         * add Float
 12.02.15                                        *
 12.06.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsProperty()
