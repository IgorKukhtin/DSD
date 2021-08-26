-- Function: gpInsert_Movement_ContractGoods_byGuides()

DROP FUNCTION IF EXISTS gpInsert_Movement_ContractGoods_byGuides (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_ContractGoods_byGuides(
    IN inOperDate            TDateTime , -- Дата документа
    IN inContractId          Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ContractGoods());

     PERFORM lpInsert_Movement_ContractGoods_byGuides (inStartDate   := tmp.StartDate
                                                         , inEndDate     := tmp.EndDate
                                                         , inContractId  := tmp.ContractId
                                                         , inJuridicalId := tmp.JuridicalId
                                                         , inGoodsId     := tmp.GoodsId
                                                         , inGoodsKindId := tmp.GoodsKindId
                                                         , inPrice       := tmp.Price
                                                         , inUserId      := vbUserId
                                                          )
     FROM (SELECT ContractGoods_Contract.ChildObjectId             AS ContractId
                , ObjectLink_Contract_Juridical.ChildObjectId      AS JuridicalId
                , ObjectLink_ContractGoods_Goods.ChildObjectId     AS GoodsId
                , ObjectLink_ContractGoods_GoodsKind.ChildObjectId AS GoodsKindId
                , ObjectDate_Start.ValueData          ::TDateTime  AS StartDate
                , ObjectDate_End.ValueData            ::TDateTime  AS EndDate
                , ObjectFloat_Price.ValueData                      AS Price
                , MAX (ObjectDate_End.ValueData) OVER (PARTITION BY ContractGoods_Contract.ChildObjectId, ObjectLink_Contract_PriceList.ChildObjectId, ObjectLink_ContractGoods_Goods.ChildObjectId, ObjectLink_ContractGoods_GoodsKind.ChildObjectId) AS EndDate_last
           FROM Object AS Object_ContractGoods
                LEFT JOIN ObjectLink AS ContractGoods_Contract
                                     ON ContractGoods_Contract.ObjectId = Object_ContractGoods.Id
                                    AND ContractGoods_Contract.DescId = zc_ObjectLink_ContractGoods_Contract()
 
                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_Goods
                                     ON ObjectLink_ContractGoods_Goods.ObjectId = Object_ContractGoods.Id
                                    AND ObjectLink_ContractGoods_Goods.DescId = zc_ObjectLink_ContractGoods_Goods()
  
                LEFT JOIN ObjectLink AS ObjectLink_ContractGoods_GoodsKind
                                     ON ObjectLink_ContractGoods_GoodsKind.ObjectId = Object_ContractGoods.Id
                                    AND ObjectLink_ContractGoods_GoodsKind.DescId = zc_ObjectLink_ContractGoods_GoodsKind()
  
                LEFT JOIN ObjectDate AS ObjectDate_Start
                                     ON ObjectDate_Start.ObjectId = Object_ContractGoods.Id
                                    AND ObjectDate_Start.DescId = zc_ObjectDate_ContractGoods_Start()
                LEFT JOIN ObjectDate AS ObjectDate_End
                                     ON ObjectDate_End.ObjectId = Object_ContractGoods.Id
                                    AND ObjectDate_End.DescId = zc_ObjectDate_ContractGoods_End()
  
                LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                      ON ObjectFloat_Price.ObjectId = Object_ContractGoods.Id 
                                     AND ObjectFloat_Price.DescId = zc_ObjectFloat_ContractGoods_Price()

                LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                     ON ObjectLink_Contract_Juridical.ObjectId = ContractGoods_Contract.ChildObjectId
                                    AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

           WHERE Object_ContractGoods.DescId = zc_Object_ContractGoods()
             AND (Object_ContractGoods.isErased = FALSE)
          ) AS tmp
     WHERE tmp.EndDate = tmp.EndDate_last
     ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  07.05.21        *
*/

-- тест
--