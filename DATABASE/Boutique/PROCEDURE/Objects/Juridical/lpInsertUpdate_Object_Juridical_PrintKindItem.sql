-- Function: lpInsertUpdate_Object_Juridicall_PrintKindItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Juridical_PrintKindItem(Integer, Integer,Integer, Boolean, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Juridical_PrintKindItem(
 INOUT ioId                  Integer   ,     -- ключ объекта <Торговая сеть> 
    IN inBranchId            Integer   ,  -- ключ объекта <Филиал> 
    IN inJuridicalId         Integer   ,  -- ключ объекта <юр.лицо 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inisTransportBill     boolean   ,  -- Транспортная
    IN inCountMovement       TFloat,   -- Накладная
    IN inCountAccount        TFloat,   -- Счет
    IN inCountTransport      TFloat,   -- ТТН
    IN inCountQuality        TFloat,   -- Качественное
    IN inCountPack           TFloat,   -- Упаковочный
    IN inCountSpec           TFloat,   -- Спецификация
    IN inCountTax            TFloat,   -- Налоговая
    IN inCountTransportBill  TFloat,  -- Транспортная
    IN inUserId              Integer       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbId_calc Integer;   
   DECLARE vbObjectId Integer;  
BEGIN
   -- !!!замена!!!
   IF inCountMovement  > 0 THEN inIsMovement:= TRUE;  ELSE inIsMovement:= FALSE; END IF;
   IF inCountAccount   > 0 THEN inIsAccount:= TRUE;   ELSE inIsAccount:= FALSE; END IF;
   IF inCountTransport > 0 THEN inIsTransport:= TRUE; ELSE inIsTransport:= FALSE; END IF; 
   IF inCountQuality   > 0 THEN inIsQuality:= TRUE;   ELSE inIsQuality:= FALSE; END IF;
   IF inCountPack      > 0 THEN inIsPack:= TRUE;      ELSE inIsPack:= FALSE; END IF;
   IF inCountSpec      > 0 THEN inIsSpec:= TRUE;      ELSE inIsSpec:= FALSE; END IF;
   IF inCountTax       > 0 THEN inIsTax:= TRUE;       ELSE inIsTax:= FALSE; END IF;
   IF inCountTransportBill > 0 THEN inIsTransportBill:= TRUE; ELSE inIsTransportBill:= FALSE; END IF; 

   -- !!!поиск или создание!!!
   vbId_calc := lpInsertFind_Object_PrintKindItem(inisMovement, inisAccount, inisTransport, inisQuality, inisPack, inisSpec, inisTax, inisTransportBill, inCountMovement, inCountAccount, inCountTransport, inCountQuality, inCountPack, inCountSpec, inCountTax, inCountTransportBill);
   

   vbObjectId:= (SELECT ObjectLink_Branch.ObjectId         -- Object_BranchPrintKindItem.Id 
                 FROM ObjectLink AS ObjectLink_Branch
                   LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                        ON ObjectLink_Juridical.ObjectId = ObjectLink_Branch.ObjectId 
                                       AND ObjectLink_Juridical.DescId = zc_ObjectLink_BranchPrintKindItem_Juridical()
                 WHERE ObjectLink_Branch.DescId = zc_ObjectLink_BranchPrintKindItem_Branch()
                   AND ObjectLink_Branch.ChildObjectId = inBranchId
                   AND ObjectLink_Juridical.ChildObjectId = inJuridicalId);
                


   IF COALESCE ( vbObjectId,0) = 0
   THEN
      -- сохранили <Объект>
      vbObjectId := lpInsertUpdate_Object (0, zc_Object_BranchPrintKindItem(), 0, '');
      -- сохранили связь с <Филиалом>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchPrintKindItem_Branch(), vbObjectId, inBranchId);
      -- сохранили связь с <>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchPrintKindItem_Juridical(), vbObjectId, inJuridicalId);

   END IF;

   ioId := vbObjectId;
   
   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BranchPrintKindItem_PrintKindItem(), ioId, vbId_calc);
 
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