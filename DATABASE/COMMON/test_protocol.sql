with tmpMov AS (select *  from Movement where OperDate between '01.09.2021' and '30.09.2021')
   , tmpMP AS (select MovementProtocol.*
              , ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.Id ASC) AS Ord

          from MovementProtocol where MovementProtocol.MovementId in (select distinct Id from tmpMov)
              )
   , tmpMP2 AS (select * FROM tmpMP where UserId = 6131893 and ord = 1)
   
   select tmpMov.DescId, MovementDesc.ItemName, MovementDesc.Code, tmpMov.OperDate, tmpMov.InvNumber, Object_jur.ObjectCode, Object_jur.ValueData, tmpMP2.OperDate
   from tmpMP2
        left join tmpMov as tmpMov2 on tmpMov2.Id = tmpMP2.MovementId and tmpMov2.DescId = zc_Movement_IncomeCost()
        left join tmpMov on tmpMov.Id = coalesce (tmpMov2.ParentId, tmpMP2.MovementId)
        left join MovementDesc on MovementDesc.Id = coalesce (tmpMov2.DescId, tmpMov.DescId)
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = tmpMov.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From on Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = tmpMov.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To on Object_To.Id = MovementLinkObject_To.ObjectId
          
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                       ON MovementLinkObject_Juridical.MovementId = tmpMov.Id
                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
          

          LEFT JOIN MovementItem AS MI ON MI.MovementId = tmpMov.Id and MI.DescId = zc_MI_Master()
                                      and tmpMov.DescId in (zc_Movement_Cash(), zc_Movement_Service(), zc_Movement_BankAccount()
                                                          , zc_Movement_PersonalAccount()
                                                          , zc_Movement_ProfitLossService()
                                                          , zc_Movement_SendDebt()
                                                           )
          LEFT JOIN MovementItemLinkObject AS MILO_MoneyPlace
                                           ON MILO_MoneyPlace.MovementItemId = MI.Id
                                          AND MILO_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

          LEFT JOIN Object AS Object_Partner on Object_Partner.Id = case when Object_From.DescId = zc_Object_Partner() then Object_From.Id
                                                                         when Object_To.DescId   = zc_Object_Partner() then Object_To.Id
                                                                         when MILO_MoneyPlace.ObjectId > 0 then MILO_MoneyPlace.ObjectId
                                                                         when MI.ObjectId > 0 then MI.ObjectId
                                                                    end

          LEFT JOIN ObjectLink AS ObjectLink_Jur
                               ON ObjectLink_Jur.ObjectId = Object_Partner.Id
                              AND ObjectLink_Jur.DescId   = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN Object AS Object_jur on Object_jur.Id = case when Object_From.DescId = zc_Object_PartnerExternal() then Object_From.Id
                                                                 when ObjectLink_Jur.ChildObjectId > 0 then ObjectLink_Jur.ChildObjectId
                                                                 when MILO_MoneyPlace.ObjectId > 0 then MILO_MoneyPlace.ObjectId
                                                                 when MI.ObjectId > 0 then MI.ObjectId
                                                                 else MovementLinkObject_Juridical.ObjectId
                                                            end
-- where Object_jur.Id is null
-- and tmpMov.DescId not in (41, 48, 49) -- "Начисления учредителям" + "Акция" + "Список покупателей для акции"
order by tmpMov.DescId, tmpMov.OperDate
-- limit 100
