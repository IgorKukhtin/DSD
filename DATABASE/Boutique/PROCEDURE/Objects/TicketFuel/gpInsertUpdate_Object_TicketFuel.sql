-- Function: gpInsertUpdate_Object_TicketFuel(Integer, Integer, TVarChar, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TicketFuel (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TicketFuel(
 INOUT ioId         Integer   , -- ���� ������� <������ �� �������>
    IN inCode       Integer   , -- �������� <��� >
    IN inName       TVarChar  , -- �������� <������������>
    IN inGoodsId    Integer   , -- ������ �� ������
    
    IN inSession    TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   

BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_TicketFuel());
   vbUserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_TicketFuel());

   -- �������� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_TicketFuel(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_TicketFuel(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TicketFuel(), vbCode_calc, inName);

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TicketFuel_Goods(), ioId, inGoodsId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_TicketFuel (Integer, Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.10.13         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_TicketFuel()
