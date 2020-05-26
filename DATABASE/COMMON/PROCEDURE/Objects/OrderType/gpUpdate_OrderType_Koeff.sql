-- Function: gpUpdate_OrderType_Koeff()

DROP FUNCTION IF EXISTS gpUpdate_OrderType_Koeff(Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                               , Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_OrderType_Koeff(
    IN inId              Integer   ,    -- ключ объекта <Подразделение>
    IN inKoeff1          TFloat    ,    --
    IN inKoeff2          TFloat    ,    --
    IN inKoeff3          TFloat    ,    --
    IN inKoeff4          TFloat    ,    --
    IN inKoeff5          TFloat    ,    --
    IN inKoeff6          TFloat    ,    --
    IN inKoeff7          TFloat    ,    --
    IN inKoeff8          TFloat    ,    --
    IN inKoeff9          TFloat    ,    --
    IN inKoeff10         TFloat    ,    --
    IN inKoeff11         TFloat    ,    --
    IN inKoeff12         TFloat    ,    --
    IN inisChange1       Boolean    ,    --
    IN inisChange2       Boolean    ,    --
    IN inisChange3       Boolean    ,    --
    IN inisChange4       Boolean    ,    --
    IN inisChange5       Boolean    ,    --
    IN inisChange6       Boolean    ,    --
    IN inisChange7       Boolean    ,    --
    IN inisChange8       Boolean    ,    --
    IN inisChange9       Boolean    ,    --
    IN inisChange10      Boolean    ,    --
    IN inisChange11      Boolean    ,    --
    IN inisChange12      Boolean    ,    --
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE (inisChange1, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff1(), inId, inKoeff1);
   END IF;
   IF COALESCE (inisChange2, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff2(), inId, inKoeff2);
   END IF;
   IF COALESCE (inisChange3, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff3(), inId, inKoeff3);
   END IF;
   IF COALESCE (inisChange4, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff4(), inId, inKoeff4);
   END IF;
   IF COALESCE (inisChange5, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff5(), inId, inKoeff5);
   END IF;
   IF COALESCE (inisChange6, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff6(), inId, inKoeff6);
   END IF;
   IF COALESCE (inisChange7, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff7(), inId, inKoeff7);
   END IF;
   IF COALESCE (inisChange8, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff8(), inId, inKoeff8);
   END IF;
   IF COALESCE (inisChange9, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff9(), inId, inKoeff9);
   END IF;
   IF COALESCE (inisChange10, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff10(), inId, inKoeff10);   
   END IF;
   IF COALESCE (inisChange11, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff11(), inId, inKoeff11);
   END IF;
   IF COALESCE (inisChange12, FALSE) = TRUE
   THEN
       -- сохранили св-во <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_OrderType_Koeff12(), inId, inKoeff12);   
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         *
*/