-- Function: gpInsertUpdate_Object_Fuel (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fuel (Integer,Integer,TVarChar, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fuel(
 INOUT ioId              Integer   ,    -- ���� ������� <���� �������>
    IN inCode            Integer   ,    -- ��� ������� <���� �������>
    IN inName            TVarChar  ,    -- �������� ������� <���� �������>
    IN inRatio           TFloat    ,    -- ����������� �������� �����
    IN inRateFuelKindId  Integer   ,    -- ���� ���� ��� �������
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Fuel());

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Fuel()); 
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Fuel(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Fuel(), vbCode_calc);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Fuel(), vbCode_calc, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Fuel_Ratio(), ioId, inRatio);

   -- ��������� ����� � <������� ������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Fuel_RateFuelKind(), ioId, inRateFuelKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_Fuel(Integer,Integer,TVarChar, TFloat, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.13          *  add  RateFuelKind
 24.09.13          * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Fuel()
