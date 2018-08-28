-- Function: gpUpdate_Liquidity_Overdraft()

DROP FUNCTION IF EXISTS gpUpdate_Liquidity_Overdraft (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Liquidity_Overdraft(
    IN inId                  Integer   ,   -- ���� ������� <>
 INOUT inoutSumma            TFloat   ,    -- ����
    IN inSession             TVarChar      -- ������� ������������
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN


   IF COALESCE(inId, 0) = 0 THEN
      inoutSumma := Null;
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Overdraft_Summa(), inId, inoutSumma);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 27.08.18        *
 11.08.18        *

*/

-- ����
-- SELECT * FROM gpUpdate_Liquidity_Overdraft