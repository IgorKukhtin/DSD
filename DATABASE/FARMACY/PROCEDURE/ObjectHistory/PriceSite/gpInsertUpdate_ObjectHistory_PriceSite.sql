-- Function: gpInsertUpdate_ObjectHistory_PriceSite ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceSite (Integer, Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceSite(
 INOUT ioId           Integer,    -- ���� ������� <������� ������� ������>
    IN inPriceSiteId  Integer,    -- �����
    IN inOperDate     TDateTime,  -- ���� �������� ������
    IN inPrice        TFloat,     -- ����
    IN inSession      TVarChar    -- ������ ������������
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());
    vbUserId := inSession::Integer;

   -- ��������
   IF COALESCE (inPriceSiteId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� <�����>.';
   END IF;


   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceSite(), inPriceSiteId, inOperDate, vbUserId);
   -- ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceSite_Value(), ioId, inPrice);
        
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ObjectHistory_PriceSite()

