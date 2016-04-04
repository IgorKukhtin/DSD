/* ÓÁèðàåì çàäâîåííûõ
select lpUnComplete_Movement (inMovementId := Movement .Id
                                      , inUserId     := zfCalc_UserAdmin() :: Integer)
from Movement 
where Id in (

with tmpAll as 
(SELECT *
FROM gpSelect_Movement_BankAccount (inStartDate:= '01.02.2016', inEndDate:= '16.03.2016', inIsErased:= FALSE, inIsPartnerDate:= FALSE, inBankAccountId:= 0, inMoneyPlaceId:= 0, inJuridicalCorporateId:= 0, inSession:= zfCalc_UserAdmin())
where StatusCode = 2 and BankAccountId IN (1648977 -- house-1
                                           , 1693572 -- house-2-ÀÑÍÁ-4 
                                          , 1694740 -- house-3-ÀÑÍÁ-3 
                                           , 1702164 -- house-4-ÀÑÍÁ
                                          , 1705473 -- house-5-ÀÑÍÁ-2
                                          , 1726712 -- house-6-Íå áîëåé
                                           )


)

 , tmp as (SELECT  tmpAll.*
                , row_number(*)  OVER (PARTITION BY BankAccountId, InvNumber, OperDate) as myR
                , count(*)  OVER (PARTITION BY BankAccountId, InvNumber, OperDate) as myC
           FROM tmpAll )

 SELECT  tmp.Id
 FROM tmp
 where myC > 1 and myR = 2
)
*/
/*
+House - Øàïèðî È.À.
House4 - Øàïèðî Ä.Ã.
+House2 - ÀÑÍÁ
-- House3 - ÀÑÍÁ-1
-- House3new - ÂÒ-1
+House6new - ÍåÁîëåé
+House12 - ÀÑÍÁ-2 
+House7 - ÀÑÍÁ-4
+House8 - ÀÑÍÁ-3
*/
-- 1. check 1
select count(*) , BillNumber, BillDate from _Bill where BillKind = 1 group by BillNumber, BillDate having count (*) > 1 order by 3 desc

-- 2. check 2+3+4
select MovementId
from(
select _CashOperation.Id, Movement.Id as MovementId -- , Movement2.*
from _CashOperation
     inner join _Bill on _Bill.Id = _CashOperation.DocumentId and BillKind = 1
     left join Movement on Movement.InvNumber = _Bill.BillNumber and Movement.OperDate = _Bill.BillDate and Movement.StatusId = zc_Enum_Status_Complete()
                      and Movement.DescId = zc_Movement_Income()
                      and Movement.Id not in (140089 , 655705)
--     left join Movement as Movement2 on Movement2.InvNumber = _Bill.BillNumber and Movement2.OperDate = _Bill.BillDate and Movement2.StatusId = zc_Enum_Status_UnComplete()
--                      and Movement2.DescId = zc_Movement_Income()
where _CashOperation.OperDate between '2016-01-01' and '2016-02-15'
-- and Movement.Id >0 and Movement2.Id > 0  
) as aa
group by MovementId having count(*) > 1


-- 3.
/*
update Movement  set StatusId = zc_Enum_Status_Erased()
where Movement.DescId = zc_Movement_BankAccount()
  AND Movement.OperDate BETWEEN '01.01.2015' AND '31.12.2015'
  AND Movement.StatusId = zc_Enum_Status_UnComplete()
  AND Movement.Id not in (319442, 931449)
;
*/

-- 4.
select Movement.Id as MovementId, _CashOperation.*, MovementLinkObject_from.ObjectId, ObjectDesc.*
     , gpInsertUpdate_Movement_BankAccount (ioId                   := 0
                                          , inInvNumber            := platNumber :: TVarChar
                                          , inOperDate             := _CashOperation.OperDate
                                          , inAmountIn             := case when OperSumm > 0 then OperSumm else 0 end
                                          , inAmountOut            := case when OperSumm < 0 then -1 * OperSumm else 0 end
                                          , inAmountSumm           := 0 

                                          -- , inBankAccountId        := 1648977 -- house-1
                                          -- , inBankAccountId        := 1693572 -- house-2-ÀÑÍÁ-4 
                                          -- , inBankAccountId        := 1694740 -- house-3-ÀÑÍÁ-3 
                                           , inBankAccountId        := 1702164 -- house-4-ÀÑÍÁ
                                          -- , inBankAccountId        := 1705473 -- house-5-ÀÑÍÁ-2
                                          -- , inBankAccountId        := 1726712 -- house-6-Íå áîëåé
                                          , inComment              := remark
                                          , inMoneyPlaceId         := MovementLinkObject_from.ObjectId
                                          , inIncomeMovementId     := Movement.Id
                                          , inContractId           := MovementLinkObject.ObjectId
                                          , inInfoMoneyId          := ObjectLink_Contract_InfoMoney.ObjectId

                                          , inCurrencyId           := 1020649 -- Ãðèâíà
                                          , inCurrencyPartnerValue := 0
                                          , inParPartnerValue      := 0
                                          , inSession              := '3'
                                           )

from _CashOperation
     inner join _Bill on _Bill.Id = _CashOperation.DocumentId and BillKind = 1
     left join Movement on Movement.InvNumber = _Bill.BillNumber and Movement.OperDate = _Bill.BillDate and Movement.StatusId = zc_Enum_Status_Complete()
                      and Movement.DescId = zc_Movement_Income()
                      and Movement.Id not in (140089 , 655705)
     left join MovementLinkObject on MovementLinkObject.MovementId = Movement.Id and MovementLinkObject.DescId = zc_MovementLinkObject_Contract()
     left join MovementLinkObject as MovementLinkObject_from on MovementLinkObject_from.MovementId = Movement.Id and MovementLinkObject_from.DescId = zc_MovementLinkObject_From()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                                 ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject.ObjectId
                                AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

            LEFT JOIN Object on Object.Id = MovementLinkObject_from.ObjectId
            LEFT JOIN ObjectDesc on ObjectDesc.Id = Object.DescId

where _CashOperation.OperDate between '2016-01-01' and '2016-02-15'
