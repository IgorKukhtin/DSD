-- Function: lpInsertUpdate_Object_Retail_PrintKindItem()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Retail_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Retail_PrintKindItem(Integer, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Retail_PrintKindItem(Integer, Integer,Integer,  Boolean, Boolean, boolean, boolean, boolean, boolean, boolean, boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Retail_PrintKindItem(
 INOUT ioId                  Integer   ,  -- ключ объекта <> 
    IN inBranchId            Integer   ,  -- ключ объекта <Филиал> 
    IN inRetailId            Integer   ,  -- ключ объекта <Торговая сеть> 
    IN inisMovement          boolean   , 
    IN inisAccount           boolean   ,
    IN inisTransport         boolean   , 
    IN inisQuality           boolean   , 
    IN inisPack              boolean   , 
    IN inisSpec              boolean   , 
    IN inisTax               boolean   ,
    IN inisTransportBill     boolean   ,  -- Транспортная
    IN inCountMovement       TFloat    , 
    IN inCountAccount        TFloat    ,
    IN inCountTransport      TFloat    , 
    IN inCountQuality        TFloat    , 
    IN inCountPack           TFloat    , 
    IN inCountSpec           TFloat    , 
    IN inCountTax            TFloat    ,
    IN inCountTransportBill  TFloat    ,  -- Транспортная
    IN inUserId              Integer       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbId_calc Integer;   
   DECLARE vbObjectId Integer;  
BEGIN
   -- !!!замена!!!
   IF inCountMovement      > 0 THEN inIsMovement:= TRUE;      ELSE inIsMovement:= FALSE; END IF;
   IF inCountAccount       > 0 THEN inIsAccount:= TRUE;       ELSE inIsAccount:= FALSE; END IF;
   IF inCountTransport     > 0 THEN inIsTransport:= TRUE;     ELSE inIsTransport:= FALSE; END IF; 
   IF inCountQuality       > 0 THEN inIsQuality:= TRUE;       ELSE inIsQuality:= FALSE; END IF;
   IF inCountPack          > 0 THEN inIsPack:= TRUE;          ELSE inIsPack:= FALSE; END IF;
   IF inCountSpec          > 0 THEN inIsSpec:= TRUE;          ELSE inIsSpec:= FALSE; END IF;
   IF inCountTax           > 0 THEN inIsTax:= TRUE;           ELSE inIsTax:= FALSE; END IF;
   IF inCountTransportBill > 0 THEN inIsTransportBill:= TRUE; ELSE inIsTransportBill:= FALSE; END IF; 
   
   -- !!!поиск или создание!!!
   vbId_calc := lpInsertFind_Object_PrintKindItem(inisMovement, inisAccount, inisTransport, inisQuality, inisPack, inisSpec, inisTax , inisTransportBill, inCountMovement, inCountAccount, inCountTransport, inCountQuality, inCountPack, inCountSpec, inCountTax, inCountTransportBill);
   
   vbObjectId:= (SELECT ObjectLink_Branch.ObjectId         -- Object_BranchPrintKindItem.Id 
                 FROM ObjectLink AS ObjectLink_Branch
                   LEFT JOIN ObjectLink AS ObjectLink_Retail
                                        ON ObjectLink_Retail.ObjectId = ObjectLink_Branch.ObjectId 
                                       AND ObjectLink_Retail.DescId = zc_ObjectLink_BranchPrintKindItem_Retail()
                 WHERE ObjectLink_Branch.DescId = zc_ObjectLink_BranchPrintKindItem_Branch()
                   AND ObjectLink_Branch.ChildObjectId = inBranchId
                   AND ObjectLink_Retail.ChildObjectId = inRetailId);
                


   IF COALESCE ( vbObjectId,0) = 0
   THEN
      -- сохранили <Объект>
      vbObjectId := lpInsertUpdate_Object (0, zc_Object_BranchPrintKindItem(), 0, '');
      -- сохранили связь с <Филиалом>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchPrintKindItem_Branch(), vbObjectId, inBranchId);
      -- сохранили связь с <Торговой сетью>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_BranchPrintKindItem_Retail(), vbObjectId, inRetailId);

   END IF;

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_BranchPrintKindItem_PrintKindItem(), vbObjectId, vbId_calc);
 
   ioId := vbObjectId;
 
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
-- SELECT * FROM lpInsertUpdate_Object_Retail_PrintKindItem(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')