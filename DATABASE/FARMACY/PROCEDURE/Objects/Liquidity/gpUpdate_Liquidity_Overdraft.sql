-- Function: gpUpdate_Liquidity_Overdraft()

DROP FUNCTION IF EXISTS gpUpdate_Liquidity_Overdraft (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Liquidity_Overdraft(
    IN inId                  Integer   ,   -- ключ объекта <>
 INOUT inoutSumma            TFloat   ,    -- Сума
    IN inSession             TVarChar      -- текущий пользователь
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

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 27.08.18        *
 11.08.18        *

*/

-- тест
-- SELECT * FROM gpUpdate_Liquidity_Overdraft