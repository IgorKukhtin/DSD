-- Function: gpSelect_Object_ContractPriceList(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPriceList(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPriceList(
    IN inisErased    Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Comment TVarChar
             , ContractId Integer, ContractName TVarChar                
             , PriceListId Integer, PriceListName TVarChar
             , StartDate TDateTime, EndDate TDateTime
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased boolean
             ) AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractPriceList());

   RETURN QUERY 
     SELECT 
           Object_ContractPriceList.Id          AS Id
         , Object_ContractPriceList.ValueData   AS Comment

         , Object_Contract.Id                   AS ContractId
         , Object_Contract.ValueData            AS ContractName

         , Object_PriceList.Id                  AS PriceListId
         , Object_PriceList.ValueData           AS PriceListName

         , ObjectDate_StartDate.ValueData :: TDateTime AS StartDate
         , ObjectDate_EndDate.ValueData   :: TDateTime AS EndDate

         , Object_Insert.ValueData              AS InsertName
         , Object_Update.ValueData              AS UpdateName
         , ObjectDate_Protocol_Insert.ValueData AS InsertDate
         , ObjectDate_Protocol_Update.ValueData AS UpdateDate

         , Object_ContractPriceList.isErased    AS isErased
         
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

          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                               ON ObjectDate_Protocol_Insert.ObjectId = Object_ContractPriceList.Id
                              AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
          LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                               ON ObjectDate_Protocol_Update.ObjectId = Object_ContractPriceList.Id
                              AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ContractPriceList.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = Object_ContractPriceList.Id
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId 

     WHERE Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
       AND (Object_ContractPriceList.isErased = FALSE OR inisErased = TRUE)
    ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.05.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractPriceList (false, '2')
