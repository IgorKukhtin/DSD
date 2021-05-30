-- Function: gpUpdate_Object_isErased_ContractPriceList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_ContractPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_ContractPriceList(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractPriceList());

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

   vbContractId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ContractPriceList_Contract() AND ObjectLink.ObjectId = inObjectId);
   -- EndDate - апдейтим ВСЕМ
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractPriceList_EndDate(), tmp.Id, tmp.EndDate)
   FROM (WITH tmpData AS (SELECT ObjectLink_Contract.ObjectId                          AS Id
                               , COALESCE (ObjectDate_StartDate.ValueData,zc_DateStart())                        AS StartDate
                               , ROW_NUMBER() OVER (ORDER BY COALESCE (ObjectDate_StartDate.ValueData,zc_DateStart()) ASC) AS Ord
                          FROM ObjectLink AS ObjectLink_Contract
                               LEFT JOIN ObjectLink AS ObjectLink_PriceList
                                                    ON ObjectLink_PriceList.ObjectId = ObjectLink_Contract.ObjectId
                                                   AND ObjectLink_PriceList.DescId   = zc_ObjectLink_ContractPriceList_PriceList()
                               INNER JOIN Object AS Object_ContractPriceList
                                                 ON Object_ContractPriceList.Id       = ObjectLink_Contract.ObjectId
                                                AND Object_ContractPriceList.isErased = FALSE
                               INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                     ON ObjectDate_StartDate.ObjectId = ObjectLink_Contract.ObjectId
                                                    AND ObjectDate_StartDate.DescId   = zc_ObjectDate_ContractPriceList_StartDate()
                          WHERE ObjectLink_Contract.ChildObjectId = vbContractId
                            AND ObjectLink_Contract.DescId        = zc_ObjectLink_ContractPriceList_Contract()
                         )
         SELECT tmpData.Id, COALESCE (tmpData_next.StartDate - INTERVAL '1 DAY', zc_DateEnd()) AS EndDate
         FROM tmpData
              LEFT JOIN tmpData AS tmpData_next ON tmpData_next.Ord = tmpData.Ord + 1
         ) AS tmp
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_ContractPriceList (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.14                                        *
*/
