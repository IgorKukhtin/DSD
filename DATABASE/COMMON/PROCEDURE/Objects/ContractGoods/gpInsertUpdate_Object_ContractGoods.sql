-- Function: gpInsertUpdate_Object_ContractGoods  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractGoods (Integer,Integer,Integer,Integer,Integer, Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractGoods (Integer,Integer,Integer,Integer,Integer, TDateTime, TDateTime, Tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractGoods(
 INOUT ioId                Integer   ,    -- ключ объекта < Улица/проспект> 
    IN inCode              Integer   ,    -- Код объекта <>
    IN inContractId        Integer   ,    --   
    IN inGoodsId           Integer   ,    -- 
    IN inGoodsKindId       Integer   ,    --
    IN inStartDate         TDateTime ,    --
    IN inEndDate           TDateTime ,    --   
    IN inPrice             Tfloat    ,
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractGoods());
   
   ioId := lpInsertUpdate_Object_ContractGoods(ioId          := ioId          :: Integer
                                             , inCode        := inCode        ::Integer
                                             , inContractId  := inContractId
                                             , inGoodsId     := inGoodsId
                                             , inGoodsKindId := inGoodsKindId ::Integer
                                             , inStartDate   := inStartDate   ::TDateTime    --
                                             , inEndDate     := inEndDate     ::TDateTime    --
                                             , inPrice       := inPrice       ::Tfloat    
                                             , inUserId      := vbUserId
                                              );

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.15         *

*/

-- тест
--