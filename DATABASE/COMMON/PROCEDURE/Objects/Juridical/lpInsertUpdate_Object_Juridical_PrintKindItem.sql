-- Function: lpInsertUpdate_Object_Juridicall_PrintKindItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Juridical_PrintKindItem(
 INOUT ioId                  Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inCountMovement       TFloat,   -- Накладная
    IN inCountAccount        TFloat,   -- Счет
    IN inCountTransport      TFloat,   -- ТТН
    IN inCountQuality        TFloat,   -- Качественное
    IN inCountPack           TFloat,   -- Упаковочный
    IN inCountSpec           TFloat,   -- Спецификация
    IN inCountTax            TFloat,   -- Налоговая
    IN inUserId              Integer       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbId_calc Integer;   
BEGIN
   -- !!!замена!!!
   IF inCountMovement  > 0 THEN inIsMovement:= TRUE;  ELSE inIsMovement:= FALSE; END IF;
   IF inCountAccount   > 0 THEN inIsAccount:= TRUE;   ELSE inIsAccount:= FALSE; END IF;
   IF inCountTransport > 0 THEN inIsTransport:= TRUE; ELSE inIsTransport:= FALSE; END IF; 
   IF inCountQuality   > 0 THEN inIsQuality:= TRUE;   ELSE inIsQuality:= FALSE; END IF;
   IF inCountPack      > 0 THEN inIsPack:= TRUE;      ELSE inIsPack:= FALSE; END IF;
   IF inCountSpec      > 0 THEN inIsSpec:= TRUE;      ELSE inIsSpec:= FALSE; END IF;
   IF inCountTax       > 0 THEN inIsTax:= TRUE;       ELSE inIsTax:= FALSE; END IF;
   
   -- !!!поиск или создание!!!
   vbId_calc := lpInsertFind_Object_PrintKindItem(inisMovement, inisAccount, inisTransport, inisQuality, inisPack, inisSpec, inisTax , inCountMovement, inCountAccount, inCountTransport, inCountQuality, inCountPack, inCountSpec, inCountTax);
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Juridical_PrintKindItem(), ioId, vbId_calc);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.01.16         * 
 21.05.15         * 
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_Juridical_PrintKindItem(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')