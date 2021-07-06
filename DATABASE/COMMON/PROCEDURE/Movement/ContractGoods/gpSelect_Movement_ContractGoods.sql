-- Function: gpSelect_Movement_ContractGoods()

DROP FUNCTION IF EXISTS gpSelect_Movement_ContractGoods (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ContractGoods(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, EndBeginDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ContractId Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PriceListId_first Integer, PriceListName_first TVarChar
             , PriceListId_curr Integer, PriceListName_curr TVarChar
             
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId         Integer;
   DECLARE vbIsDocumentUser Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ContractGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH 
     tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
   , tmpMovement AS (SELECT Movement.*
                          , MovementLinkObject_Contract.ObjectId AS ContractId
                          , ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                     FROM tmpStatus
                          JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                       AND Movement.DescId = zc_Movement_ContractGoods()
                                       AND Movement.StatusId = tmpStatus.StatusId
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                               ON ObjectLink_Contract_Juridical.ObjectId = MovementLinkObject_Contract.ObjectId
                                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                     )

   , tmpContractPrice AS (SELECT CASE WHEN tmp.StartDate = StartDate_first THEN tmp.PriceListId ELSE 0 END AS PriceListId_first
                               , tmp.PriceListId_curr AS PriceListId_curr
                          FROM (SELECT ObjectLink_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                                     , ObjectDate_StartDate.ValueData          :: TDateTime AS StartDate
                                     , ObjectDate_EndDate.ValueData            :: TDateTime AS EndDate
                                     , MIN (ObjectDate_StartDate.ValueData) OVER ()         AS StartDate_first
                                     , CASE WHEN ObjectDate_StartDate.ValueData <= tmp.OperDate AND ObjectDate_EndDate.ValueData >= tmp.OperDate
                                            THEN ObjectLink_ContractPriceList_PriceList.ChildObjectId
                                            ELSE 0
                                       END AS PriceListId_curr -- текущий прайс лист
                                FROM (SELECT DISTINCT tmpMovement.ContractId, tmpMovement.OperDate FROM tmpMovement) AS tmp
                                 
                                      INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                            ON ObjectLink_ContractPriceList_Contract.ChildObjectId = tmp.ContractId
                                                           AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                            
                                      INNER JOIN Object AS Object_ContractPriceList
                                                        ON Object_ContractPriceList.Id = ObjectLink_ContractPriceList_Contract.ObjectId
                                                       AND Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                                       AND Object_ContractPriceList.isErased = FALSE
                             
                                      LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                           ON ObjectLink_ContractPriceList_PriceList.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                          AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                            
                                      LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                           ON ObjectDate_StartDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                          AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                      LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                           ON ObjectDate_EndDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                          AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()
                                ) AS tmp
                           WHERE tmp.StartDate = StartDate_first 
                              OR COALESCE (tmp.PriceListId_curr,0) <> 0
                           GROUP BY CASE WHEN tmp.StartDate = StartDate_first THEN tmp.PriceListId ELSE 0 END
                                  , tmp.PriceListId_curr
                         )


       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate ::TDateTime       AS OperDate
           , MovementDate_EndBegin.ValueData     AS EndBeginDate

           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName

           , Object_Contract.Id                  AS ContractId
           , Object_Contract.ValueData           AS ContractName
           , Object_Juridical.Id                 AS JuridicalId
           , Object_Juridical.ValueData          AS JuridicalName

           , Object_PriceList_first.Id           AS PriceListId_first
           , Object_PriceList_first.ValueData    AS PriceListName_first
           , Object_PriceList_curr.Id            AS PriceListId_curr
           , Object_PriceList_curr.ValueData     AS PriceListName_curr           

           , MovementString_Comment.ValueData    AS Comment

           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           , Object_Update.ValueData             AS UpdateName
           , MovementDate_Update.ValueData       AS UpdateDate
           
       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = Movement.ContractId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement.JuridicalId

            LEFT JOIN MovementDate AS MovementDate_EndBegin
                                   ON MovementDate_EndBegin.MovementId = Movement.Id
                                  AND MovementDate_EndBegin.DescId = zc_MovementDate_EndBegin()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId
            
            LEFT JOIN tmpContractPrice ON 1 = 1
            LEFT JOIN Object AS Object_PriceList_first ON Object_PriceList_first.Id = tmpContractPrice.PriceListId_first
            LEFT JOIN Object AS Object_PriceList_curr ON Object_PriceList_curr.Id = tmpContractPrice.PriceListId_curr
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.21         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ContractGoods (inStartDate:= '30.11.2017', inEndDate:= '30.11.2017', inJuridicalBasisId:=0, inIsErased := FALSE, inSession:= '2')
