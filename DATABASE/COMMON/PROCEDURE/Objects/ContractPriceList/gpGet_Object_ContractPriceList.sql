-- 
DROP FUNCTION IF EXISTS gpGet_Object_ContractPriceList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ContractPriceList(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Comment TVarChar
             , ContractId Integer, ContractName TVarChar                
             , PriceListId Integer, PriceListName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             )
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractPriceList());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0    :: Integer   AS Id
           , ''    :: TVarChar  AS Comment
           ,  0    :: Integer   AS ContractId
           , ''    :: TVarChar  AS ContractName
           ,  0    :: Integer   AS PriceListId
           , ''    :: TVarChar  AS PriceListName
           , Null  :: TDateTime AS StartDate
           , Null  :: TDateTime AS EndDate
       ;
   ELSE
       RETURN QUERY
     SELECT 
           Object_ContractPriceList.Id          AS Id
         , Object_ContractPriceList.ValueData   AS Comment

         , Object_Contract.Id                   AS ContractId
         , Object_Contract.ValueData            AS ContractName

         , Object_PriceList.Id                  AS PriceListId
         , Object_PriceList.ValueData           AS PriceListName

         , COALESCE (ObjectDate_StartDate.ValueData, zc_DateStart())  :: TDateTime AS StartDate
         , COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd())      :: TDateTime AS EndDate
         
     FROM Object AS Object_ContractPriceList
          LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                               ON ObjectLink_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                              AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ContractPriceList_Contract.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                               ON ObjectLink_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                              AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_ContractPriceList_PriceList.ChildObjectId  

          LEFT JOIN ObjectDate AS ObjectDate_StartDate
                               ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                              AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()

       WHERE Object_ContractPriceList.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
 
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.21         *
*/

-- тест
-- SELECT * FROM gpGet_Object_ContractPriceList (1 ::integer,'2'::TVarChar)
