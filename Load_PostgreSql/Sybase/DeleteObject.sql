select lpDelete_Object (Object.Id, '5') 
from Object
where DescId = zc_Object_ContractGoods();


select * 
from Object
where DescId = zc_Object_ContractGoods()




select lpDelete_Object (Object.Id, '5') 
from (
select Id from gpSelect_Object_ToolsWeighing( inSession := '5')
where ParentId = 344844 or id = 344771
) as Object



-- 1 - !!!!!!!!!!!!!!!!!!!!
-- select * from Object where ObjectCode=4 and DescId = zc_Object_Branch()
select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Branch(), Id, (select Id from Object where ObjectCode=4 and DescId = zc_Object_Branch()))
-- select *
from Object
where Id = 298605 --  ОГОРЕНКО новый дистрибьютор
union
select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Branch(), Id, (select Id from Object where ObjectCode=10 and DescId = zc_Object_Branch()))
-- select *
from Object
where Id = 256624 --  Мержиєвський О.В. ФОП дистрибьютор

union
select lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_Branch(), Id, (select Id from Object where ObjectCode=6 and DescId = zc_Object_Branch()))
-- select *
from Object
where Id in (79447, 329598) -- Преміум Фудс ТОВ


-- 2.1 - !!!!!!!!!!!!!!!!!!!! Change Sale FromId
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), Movement.Id, Object_Contract_View.ContractId)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ф. Одесса
     inner join MovementLinkObject AS MovementLinkObject_PaidKind
                                   ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                  AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                  AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ОГОРЕНКО новый дистрибьютор
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_Sale();


-- 2.2 - !!!!!!!!!!!!!!!!!!!! Change ReturnIn ToId
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindTo(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractTo(), Movement.Id, Object_Contract_View.ContractId)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ф. Одесса
     inner join MovementLinkObject AS MovementLinkObject_PaidKind
                                   ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                  AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                  AND MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ОГОРЕНКО новый дистрибьютор
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_ReturnIn();


-- 3.1 - !!!!!!!!!!!!!!!!!!!! SendOnPrice -> Sale
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), Movement.Id, Object_Contract_View.ContractId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), Movement.Id, zc_PriceList_Basis())
     , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), Movement.Id, FALSE)
     , lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), Movement.Id, 20)
     , lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), Movement.Id, Movement.OperDate)
     , lpInsertUpdate_Movement (Movement.Id, zc_Movement_Sale(), Movement.InvNumber , Movement.OperDate, Movement.ParentId , 80540)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_To()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ф. Одесса
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ОГОРЕНКО новый дистрибьютор
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_SendOnPrice();

-- 3.2 - !!!!!!!!!!!!!!!!!!!! SendOnPrice -> ReturnIn
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), Movement.Id, Object_Contract_View.ContractId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), Movement.Id, zc_PriceList_Basis())
     , lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), Movement.Id, FALSE)
     , lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), Movement.Id, 20)
     , lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), Movement.Id, Movement.OperDate)
     , lpInsertUpdate_Movement (Movement.Id, zc_Movement_ReturnIn(), Movement.InvNumber , Movement.OperDate, Movement.ParentId , 80540)
-- select *
from Movement
     inner join MovementLinkObject AS MovementLinkObject_From
                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                  AND MovementLinkObject_From.ObjectId = 8423 -- ф. Одесса
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605 --  ОГОРЕНКО новый дистрибьютор
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
where Movement.OperDate >= '01.06.2014'
  and Movement.DescId = zc_Movement_SendOnPrice();
