-- Function: gpInsertUpdate_Object_ContractGoods_byPriceList  ()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractGoods_byPriceList(Integer,Integer,Integer,Integer,Integer, Tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractGoods_byPriceList(
    IN inJuridicalId       Integer   ,    -- 
    IN inContractId        Integer   ,    --   
    IN inPriceListId       Integer   ,    --   
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractGoods());
   
   WITH
     tmpPrice AS (SELECT ObjectHistory_PriceListItem.Id                   AS PriceListItemId
                       , ObjectHistory_PriceListItem.ObjectId             AS PriceListItemObjectId
                       , ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                       , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId

                       , ObjectHistory_PriceListItem.StartDate
                       , ObjectHistory_PriceListItem.EndDate
                       , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice

                  FROM ObjectLink AS ObjectLink_PriceListItem_PriceList
                       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                            ON ObjectLink_PriceListItem_Goods.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                           AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()

                       LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                            ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                           AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()

                       LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                               ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                              AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                             -- AND inOperDate >= ObjectHistory_PriceListItem.StartDate AND inOperDate < ObjectHistory_PriceListItem.EndDate
                       LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                    ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                   AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()

                  WHERE ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                    AND ObjectLink_PriceListItem_PriceList.ChildObjectId = 2707438  --inPriceListId
                    AND (ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0 OR ObjectHistory_PriceListItem.StartDate <> zc_DateStart())
                    )   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.15         *

*/

-- тест
-- select * from gpInsertUpdate_Object_ContractGoods(ioId := 0 , inCode := 1 , inName := 'Белов' , inPhone := '4444' , Mail := 'выа@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inContractGoodsKindId := 153272 ,  inSession := '5');
