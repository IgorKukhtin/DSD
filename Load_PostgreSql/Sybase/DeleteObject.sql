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

-- 2 - !!!!!!!!!!!!!!!!!!!!
select lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), Movement.Id, ObjectLink_Partner_Juridical.ObjectId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKindFrom(), Movement.Id, Object_Contract_View.PaidKindId)
     , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractFrom(), Movement.Id, Object_Contract_View.ContractId)
-- select *
from Movement
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
where Movement.Id = 709723  



-- 3 - !!!!!!!!!!!!!!!!!!!!
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
     inner join ObjectLink AS ObjectLink_Partner_Juridical
                           ON ObjectLink_Partner_Juridical.ObjectId = 298605
                          AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
     inner join Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
where Movement.Id = 629208;
