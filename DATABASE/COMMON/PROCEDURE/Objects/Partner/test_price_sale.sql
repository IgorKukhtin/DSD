     SELECT
          ObjectLink_Partner_PriceList.ChildObjectId, ObjectLink_Partner_PriceList_2.ChildObjectId
     -- , ObjectLink_Contract_InfoMoney.ChildObjectId ,  zc_Enum_InfoMoney_30201()
        , Movement .Id,        Movement .OperDate, Movement .InvNumber
        , Object_From.ValueData
        ,  Object.Id as ToId, Object.ValueData
        , Object_PriceList.Id  as ok_Id
        , Object_PriceList_err.Id  as err_Id
        , Object_PriceList.ValueData  as ok
        , Object_PriceList_err.ValueData  as err

     FROM Object AS Object_ContractPriceList

          inner JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                               ON ObjectLink_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                              AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
          LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = ObjectLink_ContractPriceList_Contract.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               on ObjectLink_Contract_InfoMoney.ObjectId = Object_Contract.Id
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

          LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                               ON ObjectLink_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                              AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()

          LEFT JOIN ObjectDate AS ObjectDate_EndDate
                               ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                              AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()


          JOIN Movement on Movement.OperDate between '20.05.2021' and '01.07.2021'
                       AND Movement.DescId = zc_Movement_Sale()
          JOIN MovementLinkObject AS MovementLinkObject_Contract
                                  ON MovementLinkObject_Contract.MovementId = Movement.Id
                                 AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 AND MovementLinkObject_Contract.ObjectId = Object_Contract.Id

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                       ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
          LEFT JOIN Object AS Object_PriceList_err ON Object_PriceList_err.Id = MovementLinkObject_PriceList.ObjectId


          JOIN MovementLinkObject AS MovementLinkObject_from
                                  ON MovementLinkObject_from.MovementId = Movement.Id
                                 AND MovementLinkObject_from.DescId = zc_MovementLinkObject_from()
          left join Object as Object_From on Object_From .Id = MovementLinkObject_from.ObjectId

          JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          left join Object on Object .Id = MovementLinkObject_To.ObjectId


          left JOIN ObjectLink AS ObjectLink_Partner_PriceList
                               ON ObjectLink_Partner_PriceList.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_PriceList.DescId   = zc_ObjectLink_Partner_PriceList()
          left JOIN ObjectLink AS ObjectLink_Partner_PriceList_2
                               ON ObjectLink_Partner_PriceList_2.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_PriceList_2.DescId   = zc_ObjectLink_Partner_PriceList30201()


          LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = case when 1=0 then ObjectLink_Partner_PriceList.ChildObjectId
                                                                             when ObjectLink_Contract_InfoMoney.ChildObjectId =  zc_Enum_InfoMoney_30201()
                                                                              and ObjectLink_Partner_PriceList_2.ChildObjectId > 0 then ObjectLink_Partner_PriceList_2.ChildObjectId
                                                                             when ObjectLink_Contract_InfoMoney.ChildObjectId <>  zc_Enum_InfoMoney_30201()
                                                                              and ObjectLink_Partner_PriceList.ChildObjectId > 0 then ObjectLink_Partner_PriceList.ChildObjectId
                                                                           else ObjectLink_ContractPriceList_PriceList.ChildObjectId
end

     WHERE Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
      and COALESCE (ObjectDate_EndDate.ValueData, zc_DateEnd()) = zc_DateEnd()
and MovementLinkObject_PriceList.ObjectId <> Object_PriceList.Id
 and Movement.StatusId = zc_Enum_Status_Complete()

 and Object .Id <> 1387363
-- and Movement .Id > 20003719
--  and Movement .Id = 19988251

-- and ObjectLink_Partner_PriceList_2.ObjectId > 0

order by Movement .Id desc , Movement .OperDate desc
, Object_From.ValueData
, Movement .InvNumber