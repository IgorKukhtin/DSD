-- SELECT * FROM HistoryCost WHERE ContainerId in (6377527) order by StartDate desc limit 5
 SELECT * FROM _tmpMaster_2024_07 WHERE goodsId in (3050) AND GoodsKindId = 8329  and InfoMoneyId_Detail  = 8909
SELECT * FROM _tmpMaster_2024_07 WHERE goodsId in (3050) AND GoodsKindId = 8329  and InfoMoneyId_Detail  = 8907
SELECT * FROM _tmpHistoryCost_PartionCell_2024_07 WHERE goodsId in (3050) AND GoodsKindId = 8329  and InfoMoneyId_Detail  = 8907


select * 
from Container 
left join ContainerLinkObject on ContainerId = Container.Id
left join ContainerLinkObjectDesc on ContainerLinkObjectDesc.Id  = ContainerLinkObject.DescId
left join Object on Object.Id = ContainerLinkObject.ObjectId
left join Object as Object_Account on Object_Account.Id = Container.ObjectId
left join ObjectDesc on ObjectDesc.Id = Object.DescId
-- left join ContainerDesc on ContainerDesc.Id = Container.DescId
where Container.Id = 6377527

select * from object where Id = 256303
select * from object where Id = 8929
select * from object where Id = 8909







-- update MovementItem set isErased = true WHERE MovementItem.MovementId = 29309489  AND MovementItem.DescId = zc_MI_Sign()  AND MovementItem.isErased = FALSE
-- select * from gpInsertUpdate_Movement_PromoTradeSign(inMovementId := 29309489 , inOrd := 3 , inValueId := null , inValue := 'Іляш Андрій Віталійович' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');


 select gpComplete_All_Sybase(28872742 , false, '')
 select gpComplete_All_Sybase(28874886 , false, '')

update MovementDesc set ItemName  = ItemName2  
from (select 'zc_Movement_Income' as Code2 , 'Постачання'  as ItemName2
union select 'zc_Movement_ReturnOut', 'Повернення постачальнику'
union select 'zc_Movement_Sale', 'Продаж'
union select 'zc_Movement_ReturnIn', 'Повернення покупця'
union select 'zc_Movement_BankAccount', 'Оплата на Розрахунковий рахунок'
union select 'zc_Movement_Service', 'Нарахування послуг'
union select 'zc_Movement_ProfitLossService', 'Нарахування послуг (витрати періодів)'
) as a
where a.Code2 = Code 


select * from ObjectStringDesc where ItemName  ilike '%банковск%'


"zc_ObjectString_GoodsPropertyValue_BarCode"
"zc_ObjectString_GoodsPropertyValue_Article"
"zc_ObjectString_GoodsPropertyValue_BarCodeGLN"
"zc_ObjectString_GoodsPropertyValue_ArticleGLN"


select * from ObjectStringDesc where Code = ItemName
and ItemName ilike '№ банковской карточки ЗП (Ф2 - Восток)'

-- update ObjectStringDesc set ItemName = code where Code not ilike '%zc_ObjectString_Member_Card%'
-- and ItemName ilike '№ банковской карточки ЗП (Ф2 - Восток)'

update ObjectStringDesc set ItemName = '№ карточного счета ЗП - алименты (удержание)' where Code =  'zc_ObjectString_Member_CardChild';
update ObjectStringDesc set ItemName = '№ карточного счета ЗП (Ф1)' where Code =  'zc_ObjectString_Member_Card';
update ObjectStringDesc set ItemName = '№ карточного счета IBAN ЗП (Ф1)' where Code =  'zc_ObjectString_Member_CardIBAN';
update ObjectStringDesc set ItemName = '№ банковской карточки ЗП (Ф1)' where Code =  'zc_ObjectString_Member_CardBank';
update ObjectStringDesc set ItemName = '№ карточного счета ЗП (Ф2 - Восток)' where Code =  'zc_ObjectString_Member_CardSecond';
update ObjectStringDesc set ItemName = '№ карточного счета IBAN ЗП (Ф2 - Восток)' where Code =  'zc_ObjectString_Member_CardIBANSecond';






--  zc_ObjectString_Bank_SWIFT() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_SWIFT'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)

    SELECT lpUpdate__ ( 'zc_ObjectString_Bank_SWIFT', zc_object_Bank(), 'Bank_SWIFT' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_SWIFT');

--  zc_ObjectString_Bank_IBAN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_IBAN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Bank_IBAN', zc_object_Bank(), 'Bank_IBAN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_IBAN');

--  zc_ObjectString_BankAccount_CorrespondentAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CorrespondentAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BankAccount_CorrespondentAccount', zc_Object_BankAccount(), 'BankAccount_CorrespondentAccount' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CorrespondentAccount');

--  zc_ObjectString_BankAccount_BeneficiarysBankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysBankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BankAccount_BeneficiarysBankAccount', zc_Object_BankAccount(), 'BankAccount_BeneficiarysBankAccount' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysBankAccount');

--  zc_ObjectString_BankAccount_BeneficiarysAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BankAccount_BeneficiarysAccount', zc_Object_BankAccount(), 'BankAccount_BeneficiarysAccount' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_BeneficiarysAccount');

--  zc_ObjectString_BankAccount_CBAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BankAccount_CBAccount', zc_Object_BankAccount(), 'Счет - для выгрузки в клиент банк' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccount');

--
--  zc_ObjectString_Car_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_Comment', zc_Object_Car(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment');

--  zc_ObjectString_Car_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_RegistrationCertificate', zc_object_Car(), 'Техпаспорт Автомобиля' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate');

--  zc_ObjectString_Car_VIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_VIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_VIN', zc_Object_Car(), ' 	VIN-код' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_VIN');

--  zc_ObjectString_Car_EngineNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_EngineNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_EngineNum', zc_Object_Car(), 'Номер двигателя' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_EngineNum');


--  zc_ObjectString_CarExternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CarExternal_Comment', zc_Object_CarExternal(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment');

--  zc_ObjectString_CarExternal_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CarExternal_RegistrationCertificate', zc_object_CarExternal(), 'Техпаспорт Автомобиля' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate');

--  zc_ObjectString_CarExternal_VIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_VIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CarExternal_VIN', zc_Object_CarExternal(), ' 	VIN-код' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_VIN');


-- --  zc_ObjectString_Contract_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- --  ObjectStringDesc (Code, DescId, ItemName)
--union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_InvNumber', zc_Object_Contract(), 'Contract_InvNumber' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber');

--  zc_ObjectString_Contract_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_BankAccount', zc_Object_Contract(), 'Расчетный счет (исх.платеж)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount');

--  zc_ObjectString_Contract_BankAccountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_BankAccountPartner', zc_Object_Contract(), 'Расчетный счет (покупателя)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccountPartner');

--  zc_ObjectString_Contract_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_Comment', zc_Object_Contract(), 'Contract_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment');

--  zc_ObjectString_Contract_InvNumberArchive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_InvNumberArchive', zc_Object_Contract(), 'Contract_InvNumberArchive' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive');

--  zc_ObjectString_Contract_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_GLNCode', zc_Object_Contract(), 'Код GLN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode');

--  zc_ObjectString_Contract_PartnerCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_PartnerCode', zc_Object_Contract(), 'Код поставщика' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode');


--  zc_ObjectString_ContactPerson_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ContactPerson_Comment', zc_Object_ContactPerson(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment');

--  zc_ObjectString_ContactPerson_Mail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ContactPerson_Mail', zc_Object_ContactPerson(), 'Электронная почта' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail');

--  zc_ObjectString_ContactPerson_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ContactPerson_Phone', zc_Object_ContactPerson(), 'Телефон' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone');

--  zc_objectString_Currency_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_objectString_Currency_InternalName', zc_object_Currency(), 'Currency_InternalName' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName');

-- zc_Object_Goods                           

--  zc_ObjectString_Goods_GroupNameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_GroupNameFull', zc_Object_Goods(), 'Полное название группы' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull');

--  zc_ObjectString_Goods_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Maker', zc_Object_Goods(), 'Производитель' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker');

--  zc_ObjectString_Goods_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_UKTZED', zc_Object_Goods(), 'Код товару згідно з УКТ ЗЕД' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED');

--  zc_ObjectString_Goods_UKTZED_main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_UKTZED_main', zc_Object_Goods(), 'Код товару згідно з УКТ ЗЕД' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_main');


--  zc_ObjectString_Goods_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_DKPP', zc_Object_Goods(), 'Послуги згідно з ДКПП' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP');

--  zc_ObjectString_Goods_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_TaxImport', zc_Object_Goods(), 'Ознака імпортованого товару' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport');

--  zc_ObjectString_Goods_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_TaxAction', zc_Object_Goods(), 'Код виду діяльності сільск-господар товаровиробника ' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction');

--  zc_ObjectString_Goods_RUS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_RUS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_RUS', zc_Object_Goods(), 'Название товара(русс.)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_RUS');

--  zc_ObjectString_Goods_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_BUH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_BUH', zc_Object_Goods(), 'Название товара(бухг.)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_BUH');

--
--  zc_ObjectString_GoodsPropertyValue_Article() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Article', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_Article' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article');

--  zc_ObjectString_GoodsPropertyValue_ArticleGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_ArticleGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_ArticleGLN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN');

--  zc_ObjectString_Goods_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_NameUkr', zc_Object_Goods(), 'Название украинское' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr');

--  zc_ObjectString_Goods_CodeUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_CodeUKTZED', zc_Object_Goods(), 'Код УКТЗЭД' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED');

--  zc_ObjectString_Goods_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_UKTZED_new', zc_Object_Goods(), 'Новый код товару згідно з УКТ ЗЕД' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_new');


--  zc_ObjectString_Goods_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ShortName', zc_Object_Goods(), 'Название сокращенное' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ShortName');

--  zc_ObjectString_Goods_Scale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Scale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Scale', zc_Object_Goods(), 'Название товара(для приложения Scale)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Scale');


-- zc_Object_GoodsPropertyValue
--  zc_ObjectString_GoodsPropertyValue_BarCodeShort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_BarCodeShort', zc_Object_GoodsPropertyValue(), 'Часть штрих кода (поиск при сканировании)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort');

--  zc_ObjectString_GoodsPropertyValue_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_BarCode', zc_Object_GoodsPropertyValue(), 'BarCode' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCode');

--  zc_ObjectString_GoodsPropertyValue_BarCodeGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN', zc_Object_GoodsPropertyValue(), 'BarCodeGLN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeGLN');

--  zc_ObjectString_GoodsPropertyValue_CodeSticker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_CodeSticker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_CodeSticker', zc_Object_GoodsPropertyValue(), 'CodeSticker' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_CodeSticker');

--  zc_ObjectString_GoodsPropertyValue_Quality2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Quality2', zc_Object_GoodsPropertyValue(), 'Строк придатності (КУ)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality2');

--  zc_ObjectString_GoodsPropertyValue_Quality10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Quality10', zc_Object_GoodsPropertyValue(), 'Умови зберігання (КУ)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality10');

--  zc_ObjectString_GoodsPropertyValue_Quality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Quality', zc_Object_GoodsPropertyValue(), 'Значение ГОСТ, ДСТУ,ТУ (КУ)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality');

--  zc_ObjectString_GoodsPropertyValue_NameExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_NameExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_NameExternal', zc_Object_GoodsPropertyValue(), 'Название в базе покупателя' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_NameExternal');

--  zc_ObjectString_GoodsPropertyValue_ArticleExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_ArticleExternal', zc_Object_GoodsPropertyValue(), 'Артикул в базе покупателя' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleExternal');


--  zc_ObjectString_Juridical_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_GLNCode', zc_Object_Juridical(), 'Juridical_GLNCode' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode');

--  zc_ObjectString_Juridical_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_OrderSumm', zc_Object_Juridical(), 'Примечание к минимальной сумме для заказа' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm');

--  zc_ObjectString_Juridical_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_OrderTime', zc_Object_Juridical(), 'информативно - максимальное время отправки' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime');

--  zc_ObjectString_Juridical_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_GUID', zc_Object_Juridical(), 'Глобальный уникальный идентификатор' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID');







---
--  zc_ObjectString_ModelService_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelService_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ModelService_Comment', zc_Object_ModelService(), 'ModelService_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelService_Comment');

--  zc_ObjectString_ModelServiceItemMaster_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemMaster_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ModelServiceItemMaster_Comment', zc_Object_ModelServiceItemMaster(), 'ModelServiceItemMaster_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemMaster_Comment');

--  zc_ObjectString_ModelServiceItemChild_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemChild_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ModelServiceItemChild_Comment', zc_Object_ModelServiceItemChild(), 'ModelServiceItemChild_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceItemChild_Comment');

--  zc_ObjectString_ModelServiceKind_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceKind_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ModelServiceKind_Comment', zc_Object_ModelServiceKind(), 'ModelServiceKind_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ModelServiceKind_Comment');

-- !!!временно!!!
--  zc_ObjectString_Partner_NameInteger() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_NameInteger', zc_Object_Partner(), 'Название Integer' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger');

--  zc_ObjectString_Partner_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_GLNCode', zc_Object_Partner(), 'Partner_GLNCode' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCode');

--  zc_ObjectString_Partner_GLNCodeJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_GLNCodeJuridical', zc_Object_Partner(), 'Partner_GLNCodeJuridical' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeJuridical');

--  zc_ObjectString_Partner_GLNCodeRetail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeRetail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_GLNCodeRetail', zc_Object_Partner(), 'Partner_GLNCodeRetail' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeRetail');

--  zc_ObjectString_Partner_GLNCodeCorporate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeCorporate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_GLNCodeCorporate', zc_Object_Partner(), 'Partner_GLNCodeCorporate' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GLNCodeCorporate');

--  zc_ObjectString_Partner_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Address', zc_Object_Partner(), 'Адрес точки доставки' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address');

--  zc_ObjectString_Partner_HouseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_HouseNumber', zc_Object_Partner(), 'Номер дома' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber');

--  zc_ObjectString_Partner_CaseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_CaseNumber', zc_Object_Partner(), 'Номер корпуса' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber');

--  zc_ObjectString_Partner_RoomNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_RoomNumber', zc_Object_Partner(), 'Номер квартиры' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber');

--  zc_ObjectString_Partner_KATOTTG() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_KATOTTG'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_KATOTTG', zc_Object_Partner(), 'КАТОТТГ' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_KATOTTG');

--  zc_ObjectString_Partner_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_ShortName', zc_Object_Partner(), 'Короткое обозначение' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName');

--  zc_ObjectString_Partner_Schedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Schedule', zc_Object_Partner(), 'График посещения' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule');

--  zc_ObjectString_Partner_Delivery() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Delivery', zc_Object_Partner(), 'График завоза' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery');

--  zc_ObjectString_Partner_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_GUID', zc_Object_Partner(), 'Глобальный уникальный идентификатор' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID');

--  zc_ObjectString_Partner_Movement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Movement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Movement', zc_Object_Partner(), 'Примечание(для Накладной продажи)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Movement');

--  zc_ObjectString_Partner_BranchCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_BranchCode', zc_Object_Partner(), 'Номер филиала' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchCode');

--  zc_ObjectString_Partner_BranchJur() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchJur'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_BranchJur', zc_Object_Partner(), 'Название юр.лица для филиала' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchJur');

--  zc_ObjectString_Partner_Terminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Terminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Terminal', zc_Object_Partner(), 'Код терминала' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Terminal');

 
 
 

--  zc_ObjectString_ReceiptChild_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ReceiptChild_Comment', zc_Object_ReceiptChild(), 'Составляющие рецептур - Значение' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment');

--  zc_ObjectString_Receipt_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Receipt_Code', zc_Object_Receipt(), 'Код рецептуры' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code');

--  zc_ObjectString_Receipt_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Receipt_Comment', zc_Object_Receipt(), 'Комментарий' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment');

--  zc_ObjectString_ToolsWeighing_NameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ToolsWeighing_NameFull', zc_ObjectString_ToolsWeighing_NameFull(), 'Полное название' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull');

--  zc_ObjectString_ToolsWeighing_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ToolsWeighing_Name', zc_ObjectString_ToolsWeighing_Name(), 'Название' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name');

--  zc_ObjectString_ToolsWeighing_NameUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ToolsWeighing_NameUser', zc_ObjectString_ToolsWeighing_NameUser(), 'Название для пользователя' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser');

--  zc_ObjectString_StaffList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StaffList_Comment', zc_Object_StaffList(), 'StaffList_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffList_Comment');

--  zc_ObjectString_StaffListCost_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListCost_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StaffListCost_Comment', zc_Object_StaffListCost(), 'StaffListCost_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListCost_Comment');

--  zc_ObjectString_StaffListSumm_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSumm_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StaffListSumm_Comment', zc_Object_StaffListSumm(), 'ModelServiceItemChild_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSumm_Comment');

--  zc_ObjectString_StaffListSummKind_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSummKind_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StaffListSummKind_Comment', zc_Object_StaffListSummKind(), 'StaffListSummKind_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StaffListSummKind_Comment');

--  zc_ObjectString_Street_PostalCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Street_PostalCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Street_PostalCode', zc_Object_Street(), 'Street_PostalCode' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Street_PostalCode');

--  zc_ObjectString_CityKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CityKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CityKind_ShortName', zc_Object_CityKind(), 'Короткое обозначение' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CityKind_ShortName');

--  zc_ObjectString_StreetKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StreetKind_ShortName', zc_Object_StreetKind(), 'Короткое обозначение' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName');


--
--  zc_ObjectString_User_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Password', zc_Object_User(), 'Пароль пользователя' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password');

--  zc_ObjectString_User_PasswordWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PasswordWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_PasswordWages', zc_Object_User(), 'Парль для просмотра своей зарплаты' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PasswordWages');

--  zc_ObjectString_User_Sign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Sign', zc_Object_User(), 'Электронная подпись' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign');

--  zc_ObjectString_User_Seal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Seal', zc_Object_User(), 'Электронная печать' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal');

--  zc_ObjectString_User_Key() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Key', zc_Object_User(), 'Электроный Ключ' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key');

--  zc_ObjectString_User_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Foto', zc_Object_User(), 'Путь к фото' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto');

--  zc_ObjectString_User_PhoneAuthent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PhoneAuthent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_PhoneAuthent', zc_Object_User(), '№ телефона для Аутентификации' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PhoneAuthent');

--  zc_ObjectString_User_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_GUID', zc_Object_User(), 'UUID сессии пользователя' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_GUID');

--  zc_ObjectString_User_SMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_SMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_SMS', zc_Object_User(), 'SMS для идентификации ' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_SMS');

 
--  zc_ObjectString_WorkTimeKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_WorkTimeKind_ShortName', zc_Object_WorkTimeKind(), 'Короткое наименование' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName');

--  zc_ObjectString_Measure_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Measure_InternalName', zc_Object_Measure(), 'Международное наименование' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName');

--  zc_ObjectString_Measure_InternalCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Measure_InternalCode', zc_Object_Measure(), 'Международный код' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode');

--  zc_ObjectString_GoodsPropertyValue_GroupName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_GroupName', zc_Object_GoodsPropertyValue(), 'Название группы' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName');

--  zc_ObjectString_Retail_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Retail_GLNCode', zc_Object_Retail(), 'Код GLN - Получатель' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode');

--  zc_ObjectString_Retail_GLNCodeCorporate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Retail_GLNCodeCorporate', zc_Object_Retail(), ' КодGLN - Поставщик' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate');

--  zc_ObjectString_Retail_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Retail_OKPO', zc_Object_Retail(), 'ОКПО для налог. документов' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_OKPO');

--  zc_ObjectString_GoodsByGoodsKind_Quality1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsByGoodsKind_Quality1', zc_Object_GoodsByGoodsKind(), 'Вид оболонки, колонка 4' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality1');

--  zc_ObjectString_GoodsByGoodsKind_Quality11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsByGoodsKind_Quality11', zc_Object_GoodsByGoodsKind(), 'Вид пакування/стан продукції' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality11');

---zc_Object_GoodsQuality

--  zc_ObjectString_GoodsQuality_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value1', zc_Object_GoodsQuality(), 'Вид оболонки, колонка 4' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1');

--  zc_ObjectString_GoodsQuality_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value2', zc_Object_GoodsQuality(), 'Термін зберігання, колонка 6' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2');

--  zc_ObjectString_GoodsQuality_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value3', zc_Object_GoodsQuality(), 'Термін зберіг. в газ.серед.(флаупак), колонка 7' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3');

--  zc_ObjectString_GoodsQuality_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value4', zc_Object_GoodsQuality(), 'Термін зберігання в газ.середовищ, колонка 8' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4');

--  zc_ObjectString_GoodsQuality_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value5', zc_Object_GoodsQuality(), 'Вакуумна упаковка - Термін зберігання цілим виробом, колонка 10' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5');

--  zc_ObjectString_GoodsQuality_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value6', zc_Object_GoodsQuality(), 'Вакуумна упаковка - Термін зберігання порційна нарізка, колонка 11' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6');

--  zc_ObjectString_GoodsQuality_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value7', zc_Object_GoodsQuality(), 'Вакуумна упаковка - Термін зберігання серверувальна нарізка, колонка 12' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7');
--  zc_ObjectString_GoodsQuality_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value8', zc_Object_GoodsQuality(), 'Температура зберігання в вакуумі та модифікованому газовому середовищі, колонка 14' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8');
--  zc_ObjectString_GoodsQuality_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value9', zc_Object_GoodsQuality(), 'Температура зберігання в газовому середовищі, колонка 15' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9');
--  zc_ObjectString_GoodsQuality_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value10', zc_Object_GoodsQuality(), 'Умови зберігання, колонка 16' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10');

--!!!Quality
--  zc_ObjectString_Quality_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Quality_Comment', zc_Object_Quality(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment');

--  zc_ObjectString_Quality_MemberMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Quality_MemberMain', zc_Object_Quality(), 'Заступник директора підприємства' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain');

--  zc_ObjectString_Quality_MemberTech() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Quality_MemberTech', zc_Object_Quality(), 'Технолог виробництва' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech');


--  zc_ObjectString_InvNumberTax_InvNumberBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InvNumberTax_InvNumberBranch', zc_Object_InvNumberTax(), 'Номер филиала' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch');

--  zc_ObjectString_Branch_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Branch_InvNumber', zc_Object_Branch(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber');

--  zc_ObjectString_Branch_PlaceOf() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Branch_PlaceOf', zc_Object_Branch(), 'Місце складання' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf');

--  zc_ObjectString_Branch_PersonalBookkeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PersonalBookkeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Branch_PersonalBookkeeper', zc_Object_Branch(), 'Сотрудник (бухгалтер) подписант' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PersonalBookkeeper');

--  zc_ObjectString_Form_HelpFile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Form_HelpFile', zc_Object_Form(), 'Путь к файлу помощи' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile');

--  zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Address', zc_object_Unit(), 'Адрес' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

--  zc_ObjectString_Unit_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Phone', zc_object_Unit(), 'Телефон' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone');

--  zc_ObjectString_Unit_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Comment', zc_object_Unit(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment');


--  zc_ObjectString_Storage_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Storage_Address', zc_object_Storage(), 'Адрес места' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address');

--  zc_ObjectString_Storage_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Storage_Comment', zc_object_Storage(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment');

--  zc_ObjectString_Storage_Room() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Room'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Storage_Room', zc_object_Storage(), 'Кабинет' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Room');



--  zc_ObjectString_SignInternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SignInternal_Comment', zc_object_SignInternal(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment');

--  zc_ObjectString_MobileEmployee_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileEmployee_Comment', zc_Object_MobileEmployee(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment');

--  zc_ObjectString_MobileTariff_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileTariff_Comment', zc_Object_MobileTariff(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment');

--  zc_ObjectString_MobileConst_MobileVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileConst_MobileVersion', zc_Object_MobileConst(), 'Версия мобильного приложения' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion');

--  zc_ObjectString_MobileConst_MobileAPKFileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileConst_MobileAPKFileName', zc_Object_MobileConst(), 'Название ".apk" файла мобильного приложения' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName');

--
--  zc_ObjectString_SheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SheetWorkTime_Comment', zc_Object_SheetWorkTime(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment');

--  zc_ObjectString_SheetWorkTime_DayOffPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SheetWorkTime_DayOffPeriod', zc_Object_SheetWorkTime(), 'Периодичность в днях' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod');

--  zc_ObjectString_SheetWorkTime_DayOffWeek() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SheetWorkTime_DayOffWeek', zc_Object_SheetWorkTime(), 'Дни недели' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek');

--  zc_ObjectString_GoodsListSale_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsListSale_GoodsKind', zc_Object_GoodsListSale(), 'Список всех вид товара' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind');

--  zc_ObjectString_GoodsListIncome_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsListIncome_GoodsKind', zc_Object_GoodsListIncome(), 'Список всех вид товара' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind');

--  zc_ObjectString_GoodsGroup_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_UKTZED', zc_Object_GoodsGroup(), 'Код товару згідно з УКТ ЗЕД' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED');

--  zc_ObjectString_GoodsGroup_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_UKTZED_new', zc_Object_GoodsGroup(), 'Новый код товару згідно з УКТ ЗЕД' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED_new');


--  zc_ObjectString_GoodsGroup_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_DKPP', zc_Object_GoodsGroup(), 'Послуги згідно з ДКПП' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP');

--  zc_ObjectString_GoodsGroup_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_TaxImport', zc_Object_GoodsGroup(), 'Ознака імпортованого товару' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport');

--  zc_ObjectString_GoodsGroup_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_TaxAction', zc_Object_GoodsGroup(), 'Код виду діяльності сільск-господар товаровиробника' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction');

--  zc_ObjectString_StorageLine_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StorageLine_Comment', zc_Object_StorageLine(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment');

--  zc_ObjectString_ArticleLoss_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ArticleLoss_Comment', zc_Object_ArticleLoss(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment');

--
--  zc_ObjectString_StickerGroup_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerGroup_Comment', zc_Object_StickerGroup(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment');

--  zc_ObjectString_StickerType_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerType_Comment', zc_Object_StickerType(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment');

--  zc_ObjectString_StickerTag_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerTag_Comment', zc_Object_StickerTag(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment');

--  zc_ObjectString_StickerSort_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerSort_Comment', zc_Object_StickerSort(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment');

--  zc_ObjectString_StickerNorm_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerNorm_Comment', zc_Object_StickerNorm(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment');

--  zc_ObjectString_StickerFile_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerFile_Comment', zc_Object_StickerFile(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment');

--  zc_ObjectString_StickerSkin_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerSkin_Comment', zc_Object_StickerSkin(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment');

--  zc_ObjectString_StickerPack_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerPack_Comment', zc_Object_StickerPack(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment');

--  zc_ObjectString_Language_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Comment', zc_Object_Language(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment');

--  zc_ObjectString_Language_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value1', zc_Object_Language(), 'Склад:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1');

--  zc_ObjectString_Language_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value2', zc_Object_Language(), 'Умови та термін зберігання:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2');

--  zc_ObjectString_Language_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value3', zc_Object_Language(), 'за відносної вологості повітря від' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3');

--  zc_ObjectString_Language_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value4', zc_Object_Language(), 'до' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4');

--  zc_ObjectString_Language_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value5', zc_Object_Language(), 'за температури від' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5');

--  zc_ObjectString_Language_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value6', zc_Object_Language(), 'до' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6');

--  zc_ObjectString_Language_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value7', zc_Object_Language(), 'не більш ніж' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7');

--  zc_ObjectString_Language_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value8', zc_Object_Language(), 'Поживна цінність та калорійність В 100гр.продукта:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8');

--  zc_ObjectString_Language_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value9', zc_Object_Language(), 'білки не менше' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9');

--  zc_ObjectString_Language_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value10', zc_Object_Language(), 'гр' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10');

--  zc_ObjectString_Language_Value11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value11', zc_Object_Language(), 'жири не більше' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11');

--  zc_ObjectString_Language_Value12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value12', zc_Object_Language(), 'гр' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12');

--  zc_ObjectString_Language_Value13() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value13', zc_Object_Language(), 'кКал' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13');

--  zc_ObjectString_Language_Value14() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value14'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value14', zc_Object_Language(), 'діб.' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value14');

--  zc_ObjectString_Language_Value15() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value15'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value15', zc_Object_Language(), 'вуглеводи не більше:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value15');

--  zc_ObjectString_Language_Value16() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value16'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value16', zc_Object_Language(), 'гр' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value16');

--  zc_ObjectString_Language_Value17() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value17'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value17', zc_Object_Language(), 'кДж' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value17');

---
--  zc_ObjectString_StickerProperty_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerProperty_BarCode', zc_Object_StickerProperty(), 'Штрихкод' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode');


--  zc_ObjectString_DocumentTaxKind_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_Code', zc_Object_DocumentTaxKind(), 'Код причины' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Code');

--  zc_ObjectString_DocumentTaxKind_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_Goods', zc_Object_DocumentTaxKind(), 'Номенклатура' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Goods');

--  zc_ObjectString_DocumentTaxKind_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_Measure', zc_Object_DocumentTaxKind(), 'Ед.изм.' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Measure');

--  zc_ObjectString_DocumentTaxKind_MeasureCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_MeasureCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_MeasureCode', zc_Object_DocumentTaxKind(), 'Код ед.изм.' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_MeasureCode');

--  zc_ObjectString_GoodsTypeKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsTypeKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsTypeKind_ShortName', zc_object_GoodsTypeKind(), 'Короткое обозначение' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsTypeKind_ShortName');

--  zc_ObjectString_OrderFinance_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_OrderFinance_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_OrderFinance_Comment', zc_object_OrderFinance(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_OrderFinance_Comment');



--  zc_ObjectString_PartnerExternal_ObjectCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerExternal_ObjectCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PartnerExternal_ObjectCode', zc_object_PartnerExternal(), 'Код внешний' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerExternal_ObjectCode');

--  zc_ObjectString_JuridicalOrderFinance_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalOrderFinance_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_JuridicalOrderFinance_Comment', zc_object_JuridicalOrderFinance(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalOrderFinance_Comment');

--  zc_ObjectString_PersonalServiceList_ContentType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_ContentType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PersonalServiceList_ContentType', zc_Object_PersonalServiceList(), ' Content-Type' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_ContentType');

--  zc_ObjectString_PersonalServiceList_OnFlowType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_OnFlowType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PersonalServiceList_OnFlowType', zc_Object_PersonalServiceList(), 'Вид начисления в банке' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_OnFlowType');

--  zc_ObjectString_FineSubject_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FineSubject_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_FineSubject_Comment', zc_Object_FineSubject(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FineSubject_Comment');

--  zc_ObjectString_ReceiptLevel_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptLevel_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ReceiptLevel_Comment', zc_Object_ReceiptLevel(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptLevel_Comment');

--  zc_ObjectString_Reason_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Reason_Comment', zc_Object_Reason(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Comment');

--  zc_ObjectString_MobilePack_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobilePack_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobilePack_Comment', zc_Object_MobilePack(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobilePack_Comment');


--  zc_ObjectString_SmsSettings_Login() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Login'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SmsSettings_Login', zc_Object_SmsSettings(), 'Login' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Login');

--  zc_ObjectString_SmsSettings_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SmsSettings_Password', zc_Object_SmsSettings(), 'Password' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Password');

--  zc_ObjectString_SmsSettings_Message() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Message'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SmsSettings_Message', zc_Object_SmsSettings(), 'Message' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SmsSettings_Message');

--  zc_ObjectString_PairDay_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PairDay_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PairDay_Comment', zc_object_PairDay(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PairDay_Comment');

/*
--  zc_ObjectString_Area_TelegramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Area_TelegramId', zc_object_Area(), 'Группа получателей в рассылке Акций' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramId');

 --  zc_ObjectString_Area_TelegramBotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramBotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Area_TelegramBotToken', zc_object_Area(), 'Токен отправителя телеграм бота в рассылке Акций' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramBotToken');
 */
 
--  zc_ObjectString_TelegramGroup_Id() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_Id'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_TelegramGroup_Id', zc_object_Area(), 'Группа получателей в рассылке Акций' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_Id');

 --  zc_ObjectString_TelegramGroup_BotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_BotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_TelegramGroup_BotToken', zc_object_TelegramGroup(), 'Токен отправителя телеграм бота в рассылке Акций' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_BotToken');




 --  zc_ObjectString_PartionCell_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionCell_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PartionCell_Comment', zc_object_PartionCell(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionCell_Comment');


 --  zc_ObjectString_ViewPriceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ViewPriceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ViewPriceList_Comment', zc_object_ViewPriceList(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ViewPriceList_Comment');

 --  zc_ObjectString_ChoiceCell_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ChoiceCell_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ChoiceCell_Comment', zc_object_ChoiceCell(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ChoiceCell_Comment');

 --  zc_ObjectString_GoodsNormDiff_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsNormDiff_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsNormDiff_Comment', zc_object_GoodsNormDiff(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsNormDiff_Comment');
   
 --  zc_ObjectString_RouteNum_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RouteNum_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_RouteNum_Comment', zc_object_RouteNum(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RouteNum_Comment');







---!!! Аптека

--  zc_ObjectString_Goods_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Code', zc_Object_Goods(), 'Строковый код' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code');

--  zc_ObjectString_ImportSettings_Directory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportSettings_Directory', zc_Object_ImportSettings(), 'Директория загрузки' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory');

--  zc_ObjectString_ImportType_ProcedureName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportType_ProcedureName', zc_Object_ImportType(), 'Имя процедуры' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName');

--  zc_ObjectString_ImportTypeItems_ParamType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportTypeItems_ParamType', zc_Object_ImportTypeItems(), 'Тип параметра процедуры' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType');

--  zc_ObjectString_ImportTypeItems_UserParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportTypeItems_UserParamName', zc_Object_ImportTypeItems(), 'Пользовательское название параметра процедуры' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName');

--  zc_ObjectString_ImportSettingsItems_DefaultValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportSettingsItems_DefaultValue', zc_Object_ImportSettingsItems(), 'Значения по умолчанию' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue');
  
--  zc_ObjectString_Goods_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Foto', zc_Object_Goods(), 'Путь к фото' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto');
  
--  zc_ObjectString_Goods_Thumb() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Thumb', zc_Object_Goods(), 'Путь к превью фото' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb');


--  zc_ObjectString_Email_ErrorTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Email_ErrorTo', zc_object_Email(), 'Кому отправлять сообщение об ошибке при загрузке данных с п/я' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo');


--  zc_ObjectString_DiscountExternal_URL() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_URL'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternal_URL', zc_object_DiscountExternal(), 'URL' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_URL');

--  zc_ObjectString_DiscountExternal_Service() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Service'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternal_Service', zc_object_DiscountExternal(), 'Service' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Service');

--  zc_ObjectString_DiscountExternal_Port() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Port'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternal_Port', zc_object_DiscountExternal(), 'Port' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternal_Port');

--  zc_ObjectString_DiscountExternalTools_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalTools_User', zc_object_DiscountExternalTools(), 'User' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_User');

--  zc_ObjectString_DiscountExternalTools_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalTools_Password', zc_object_DiscountExternalTools(), 'Password' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Password');

--  zc_ObjectString_DiscountExternalTools_ExternalUnit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_ExternalUnit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalTools_ExternalUnit', zc_Object_DiscountExternalTools(), 'Подразделение проекта' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_ExternalUnit');

--  zc_ObjectString_DiscountExternalJuridical_ExternalJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical', zc_Object_DiscountExternalJuridical(), 'Юридическое лицо проекта' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical');

--  zc_ObjectString_Goods_Pack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Pack', zc_object_Goods(), 'Сила дії/ дозування (5)(СП)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack');

--  zc_ObjectString_Goods_CodeATX() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_CodeATX', zc_object_Goods(), 'Код АТХ (7)(СП)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX');

--  zc_ObjectString_Goods_ReestrSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ReestrSP', zc_object_Goods(), '№ реєстраційного посвідчення на лікарський засіб (9)(СП)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP');

--  zc_ObjectString_Goods_ReestrDateSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ReestrDateSP', zc_object_Goods(), 'Дата закінчення строку дії реєстраційного посвідчення на лікарський засіб(10)(СП)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP');

--  zc_ObjectString_Goods_MakerSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_MakerSP', zc_object_Goods(), 'Найменування виробника, країна(8)(СП)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP');

--  zc_ObjectString_User_ProjectMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_ProjectMobile', 'Серийный № моб устр-ва' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile');

--  zc_ObjectString_User_MobileModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileModel', 'Модель моб устр-ва' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel');

--  zc_ObjectString_User_MobileVesion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesion', 'Версия Андроид устр-ва' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion');

--  zc_ObjectString_User_MobileVesionSDK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesionSDK', 'Версия SDK устр-ва' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK');
  

--  zc_ObjectString_PartnerMedical_FIO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PartnerMedical_FIO', zc_object_PartnerMedical(), 'ГлавВрач' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO');

--  zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Address', zc_object_Unit(), 'Адрес аптеки' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

--  zc_ObjectString_Unit_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_GLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_GLN', zc_object_Unit(), 'GLN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_GLN');

--  zc_ObjectString_Unit_KATOTTG() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_KATOTTG'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_KATOTTG', zc_object_Unit(), 'КАТОТТГ' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_KATOTTG');

--  zc_ObjectString_Unit_AddressEDIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AddressEDIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_AddressEDIN', zc_object_Unit(), 'Адрес для EDIN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AddressEDIN');



--  zc_ObjectString_Contract_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_OrderSumm', zc_Object_Contract(), 'Примечание к минимальной сумме для заказа' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm');

--  zc_ObjectString_Contract_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_OrderTime', zc_Object_Contract(), 'информативно - максимальное время отправки' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime');

--  zc_ObjectString_Area_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Area_Email', zc_Object_Area(), 'На какой адрес приходит инфа по прайсам для этого региона' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email');

--  zc_ObjectString_JuridicalArea_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_JuridicalArea_Email', zc_Object_JuridicalArea(), 'На какой адрес ПОСТАВЩИКА мы отправляем инфу по заказам для этого региона' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email');

--  zc_ObjectString_PromoCode_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PromoCode_Comment', zc_Object_PromoCode(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment');

--  zc_ObjectString_Fiscal_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Fiscal_SerialNumber', zc_Object_Fiscal(), 'омер заводской' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber');

--  zc_ObjectString_Fiscal_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Fiscal_InvNumber', zc_Object_Fiscal(), 'номер фискальный' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber');

--  zc_ObjectString_ImportType_JSONParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportType_JSONParamName', zc_Object_ImportType(), 'Имя процедуры' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName');
  

--  zc_ObjectString_ClientsByBank_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_OKPO', zc_Object_ClientsByBank(), 'ОКПО' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO');

--  zc_ObjectString_ClientsByBank_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_INN', zc_Object_ClientsByBank(), 'ИНН' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN');

--  zc_ObjectString_ClientsByBank_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_Phone', zc_Object_ClientsByBank(), 'Телефоны' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone');

--  zc_ObjectString_ClientsByBank_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_ContactPerson', zc_Object_ClientsByBank(), 'Контактное лицо' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson');

--  zc_ObjectString_ClientsByBank_RegAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_RegAddress', zc_Object_ClientsByBank(), 'Адрес регистрации' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress');

--  zc_ObjectString_ClientsByBank_SendingAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_SendingAddress', zc_Object_ClientsByBank(), 'Адрес отправки' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress');

--  zc_ObjectString_ClientsByBank_Accounting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_Accounting', zc_Object_ClientsByBank(), 'Бухгалтерия' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting');

--  zc_ObjectString_ClientsByBank_PhoneAccountancy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_PhoneAccountancy', zc_Object_ClientsByBank(), 'Телефон бухгалтерии' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy');

--  zc_ObjectString_ClientsByBank_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_Comment', zc_Object_ClientsByBank(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment');

--  zc_ObjectString_Asset_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Asset_SerialNumber', zc_Object_Asset(), 'Asset_SerialNumber' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber');

--  zc_ObjectString_CashRegister_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_SerialNumber', zc_Object_CashRegister(), 'Номер заводской' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_SerialNumber');

--  zc_ObjectString_HelsiEnum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_HelsiEnum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_HelsiEnum', zc_Object_HelsiEnum(), 'Параметр доступа к сайту Хелси' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_HelsiEnum');

--  zc_ObjectString_User_Helsi_UserName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_UserName', zc_Object_User(), 'Имя пользователя на сайте Хелси' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserName');

--  zc_ObjectString_User_Helsi_UserPassword() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserPassword'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_UserPassword', zc_Object_User(), 'Пароль пользователя на сайте Хелси' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserPassword');

--  zc_ObjectString_User_Helsi_KeyPassword() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_KeyPassword'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_KeyPassword', zc_Object_User(), 'Пароль к файловому ключу' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_KeyPassword');

--  zc_ObjectString_User_Helsi_PasswordEHels() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_PasswordEHels'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_PasswordEHels', zc_Object_User(), 'Пароль Е-Хелс' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_PasswordEHels');

--  zc_ObjectString_Goods_Analog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Analog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Analog', zc_Object_Goods(), 'Перечень аналогов товара' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Analog');

--  zc_ObjectString_Driver_E_Mail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Driver_E_Mail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Driver_E_Mail', zc_Object_Driver(), 'e-mail для отправки реестра перемещений' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Driver_E_Mail');
 
--  zc_ObjectString_PayrollType_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollType_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PayrollType_ShortName', zc_Object_PayrollType(), 'Короткое наименование' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollType_ShortName');

--  zc_ObjectString_Juridical_CBName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBName', zc_Object_Juridical(), 'Полное название поставщика для клиент банка' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBName');

--  zc_ObjectString_Juridical_CBMFO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBMFO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBMFO', zc_Object_Juridical(), 'МФО для клиент банка' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBMFO');

--  zc_ObjectString_Juridical_CBAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBAccount', zc_Object_Juridical(), 'Расчетный счет для клиент банка' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccount');

--  zc_ObjectString_Juridical_CBAccountOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccountOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBAccountOld', zc_Object_Juridical(), 'Расчетный счет старый для клиент банка' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccountOld');

--  zc_ObjectString_Juridical_CBPurposePayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBPurposePayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBPurposePayment', zc_ObjectString_Juridical_CBPurposePayment(), 'Назначение платежа для клиент банка' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBPurposePayment');

--  zc_ObjectString_BankAccount_CBAccountOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccountOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BankAccount_CBAccountOld', zc_Object_BankAccount(), 'Счет старый - для выгрузки в клиент банк' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccountOld');


--  zc_ObjectString_Unit_Latitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Latitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Latitude', zc_object_Unit(), 'Географическая широта' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Latitude');

--  zc_ObjectString_Unit_Longitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Longitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Longitude', zc_object_Unit(), 'Географическая долгота' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Longitude');

--  zc_ObjectString_Unit_ListDaySUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_ListDaySUN', zc_object_Unit(), 'По каким дням недели по СУН' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN');

--  zc_ObjectString_CashSettings_ShareFromPriceName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_ShareFromPriceName', zc_Object_CashSettings(), 'Перечень фраз в названиях товаров которые можно делить с любой ценой' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceName');

--  zc_ObjectString_CashSettings_ShareFromPriceCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_ShareFromPriceCode', zc_Object_CashSettings(), 'Перечень кодов товаров которые можно делить с любой ценой' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceCode');

--  zc_ObjectString_Unit_AccessKeyYF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AccessKeyYF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_AccessKeyYF', zc_object_Unit(), 'Ключ ХО для отправки данных Юрия-Фарм' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AccessKeyYF');

--  zc_ObjectString_Unit_ListDaySUN_pi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN_pi'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_ListDaySUN_pi', zc_object_Unit(), 'По каким дням недели формируется СУН2-перемещ.излишков' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN_pi');

--  zc_ObjectString_Unit_SUN_v1_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v1_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SUN_v1_Lock', zc_object_Unit(), 'запрет в СУН-1 для 1)подключать чек "не для НТЗ" 2)товары "закрыт код" 3)товары "убит код"' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v1_Lock');

--  zc_ObjectString_Unit_SUN_v2_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v2_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SUN_v2_Lock', zc_object_Unit(), 'запрет в СУН-2 для 1)подключать чек "не для НТЗ" 2)товары "закрыт код" 3)товары "убит код"' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v2_Lock');

--  zc_ObjectString_Unit_SUN_v4_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v4_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SUN_v4_Lock', zc_object_Unit(), 'запрет в СУН-2-пи для 1)подключать чек "не для НТЗ" 2)товары "закрыт код" 3)товары "убит код"' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v4_Lock');


--  zc_ObjectString_Buyer_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Name', zc_Object_Buyer(), 'Фамилия Имя Отчество' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Name');

--  zc_ObjectString_Buyer_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Phone', zc_Object_Buyer(), 'Телефон' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Phone');

--  zc_ObjectString_Buyer_EMail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_EMail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_EMail', zc_object_Buyer(), 'Электронная почта' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_EMail');

--  zc_ObjectString_Buyer_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Address', zc_object_Buyer(), 'Место проживания' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Address');

--  zc_ObjectString_Buyer_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Comment', zc_object_Buyer(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Comment');

--  zc_ObjectString_Buyer_DateBirth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_DateBirth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_DateBirth', zc_object_Buyer(), 'Дата рождения' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_DateBirth');

--  zc_ObjectString_Buyer_Sex() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Sex'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Sex', zc_object_Buyer(), 'Пол' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Sex');

--  zc_ObjectString_DriverSun_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DriverSun_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DriverSun_Phone', zc_Object_DriverSun(), 'Телефон' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DriverSun_Phone');
 
--  zc_ObjectString_CashRegister_ComputerName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ComputerName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_ComputerName', zc_Object_CashRegister(), 'Имя компютера' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ComputerName');

--  zc_ObjectString_CashRegister_BaseBoardProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_BaseBoardProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_BaseBoardProduct', zc_Object_CashRegister(), 'Материнская плата' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_BaseBoardProduct');
 
--  zc_ObjectString_CashRegister_ProcessorName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ProcessorName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_ProcessorName', zc_Object_CashRegister(), 'Процессор' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ProcessorName');

--  zc_ObjectString_CashRegister_DiskDriveModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_DiskDriveModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_DiskDriveModel', zc_Object_CashRegister(), 'Жесткий Диск' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_DiskDriveModel');

--  zc_ObjectString_CashRegister_TaxRate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_TaxRate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_TaxRate', zc_Object_CashRegister(), 'Налоговые ставки' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_TaxRate');

--  zc_ObjectString_CashRegister_PhysicalMemory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_PhysicalMemory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_PhysicalMemory', zc_Object_CashRegister(), 'Оперативная память' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_PhysicalMemory');
 

--  zc_ObjectString_Hardware_BaseBoardProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_BaseBoardProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_BaseBoardProduct', zc_Object_Hardware(), 'Материнская плата' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_BaseBoardProduct');
 
--  zc_ObjectString_Hardware_ProcessorName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ProcessorName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_ProcessorName', zc_Object_Hardware(), 'Процессор' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ProcessorName');

--  zc_ObjectString_Hardware_DiskDriveModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_DiskDriveModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_DiskDriveModel', zc_Object_Hardware(), 'Жесткий Диск' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_DiskDriveModel');

--  zc_ObjectString_Hardware_PhysicalMemory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_PhysicalMemory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_PhysicalMemory', zc_Object_Hardware(), 'Оперативная память' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_PhysicalMemory');
   
--  zc_ObjectString_Hardware_Identifier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Identifier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_Identifier', zc_Object_Hardware(), 'Идентификатор' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Identifier');

--  zc_ObjectString_Hardware_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_Comment', zc_Object_Hardware(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Comment');

--  zc_ObjectString_Goods_AnalogATC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_AnalogATC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_AnalogATC', zc_Object_Goods(), 'Перечень аналогов товара ATC' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_AnalogATC');

--  zc_ObjectString_Goods_ActiveSubstance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ActiveSubstance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ActiveSubstance', zc_Object_Goods(), 'Действующее вещество' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ActiveSubstance');

--  zc_ObjectString_DiscountExternalTools_Token() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Token'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalTools_Token', zc_Object_DiscountExternalTools(), 'API токен' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Token');


--  zc_ObjectString_Unit_PromoForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PromoForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_PromoForSale', zc_object_Unit(), 'Маркетинговый контракт для заполнения врачей и покупателей' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PromoForSale');

--  zc_ObjectString_BuyerForSale_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSale_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BuyerForSale_Phone', zc_Object_BuyerForSale(), 'Телефон' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSale_Phone');

--  zc_ObjectString_Hardware_ComputerName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ComputerName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_ComputerName', zc_Object_Hardware(), 'Имя компьютера' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ComputerName');
 
--  zc_ObjectString_Instructions_FileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Instructions_FileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Instructions_FileName', zc_Object_Instructions(), 'Имя файла' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Instructions_FileName');

--  zc_ObjectString_User_LikiDnepr_UserEmail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_UserEmail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_LikiDnepr_UserEmail', zc_Object_User(), 'E-mail провизора Е-Хелс для МИС «Каштан»' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_UserEmail');

--  zc_ObjectString_User_LikiDnepr_PasswordEHels() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_PasswordEHels'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_LikiDnepr_PasswordEHels', zc_Object_User(), 'Пароль Е-Хелс для регистрации через МИС «Каштан»' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_PasswordEHels');


--  zc_ObjectString_BuyerForSite_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSite_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BuyerForSite_Phone', zc_Object_BuyerForSite(), 'Телефон' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSite_Phone');

--  zc_ObjectString_RecalcMCSSheduler_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RecalcMCSSheduler_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_RecalcMCSSheduler_Comment', zc_Object_RecalcMCSSheduler(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RecalcMCSSheduler_Comment');

--  zc_ObjectString_Personal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Personal_Comment', zc_Object_Personal(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment');

--  zc_ObjectString_Personal_Code1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Code1C'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Personal_Code1C', zc_Object_Personal(), 'Код 1С' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Code1C');

--  zc_ObjectString_PayrollTypeVIP_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollTypeVIP_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PayrollTypeVIP_ShortName', zc_Object_PayrollTypeVIP(), 'Короткое наименование' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollTypeVIP_ShortName');

--  zc_ObjectString_Goods_PromoBonusName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_PromoBonusName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_PromoBonusName', zc_Object_Goods(), 'Наименование бонусных упаковок по акции' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_PromoBonusName');

--  zc_ObjectString_MedicalProgramSP_ProgramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MedicalProgramSP_ProgramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MedicalProgramSP_ProgramId', zc_Object_MedicalProgramSP(), 'Идентификатор медицинской программы' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MedicalProgramSP_ProgramId');

--  zc_ObjectString_Unit_PharmacyManager() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManager'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_PharmacyManager', zc_object_Unit(), 'ФИО Зав. аптекой' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManager');

--  zc_ObjectString_Unit_PharmacyManagerPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManagerPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_PharmacyManagerPhone', zc_object_Unit(), 'Телефон Зав. аптекой' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManagerPhone');

--  zc_ObjectString_Unit_TokenKashtan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TokenKashtan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_TokenKashtan', zc_object_Unit(), 'Токен аптечной сети в МИС «Каштан»' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TokenKashtan');

--  zc_ObjectString_Unit_TelegramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TelegramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_TelegramId', zc_object_Unit(), 'ID аптеки в Telegram	' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TelegramId');

--  zc_ObjectString_CashSettings_TelegramBotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_TelegramBotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_TelegramBotToken', zc_Object_CashSettings(), 'Токен телеграм бота' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_TelegramBotToken');

--  zc_ObjectString_SurchargeWages_Description() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SurchargeWages_Description'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SurchargeWages_Description', zc_Object_SurchargeWages(), 'Описание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SurchargeWages_Description');

--  zc_ObjectString_Education_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Education_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Education_NameUkr', zc_Object_Education(), 'Наименование на Украинском языке' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Education_NameUkr');
  

--  zc_ObjectString_FormDispensing_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FormDispensing_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_FormDispensing_NameUkr', zc_Object_FormDispensing(), 'Название украинское' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FormDispensing_NameUkr');

--  zc_ObjectString_Goods_MakerUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_MakerUkr', zc_Object_Goods(), 'Производитель украинское название' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerUkr');


--  zc_ObjectString_GoodsWhoCan_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsWhoCan_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsWhoCan_NameUkr', zc_Object_GoodsWhoCan(), 'Название украинское' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsWhoCan_NameUkr');

--  zc_ObjectString_GoodsMethodAppl_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsMethodAppl_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsMethodAppl_NameUkr', zc_Object_GoodsMethodAppl(), 'Название украинское' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsMethodAppl_NameUkr');

--  zc_ObjectString_GoodsSignOrigin_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsSignOrigin_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsSignOrigin_NameUkr', zc_Object_GoodsSignOrigin(), 'Название украинское' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsSignOrigin_NameUkr');

--  zc_ObjectString_Goods_Dosage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Dosage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Dosage', zc_Object_Goods(), 'Дозировка' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Dosage');

--  zc_ObjectString_Goods_Volume() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Volume'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Volume', zc_Object_Goods(), 'Объем' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Volume');

--  zc_ObjectString_Goods_GoodsWhoCan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GoodsWhoCan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_GoodsWhoCan', zc_Object_Goods(), 'Кому можно' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GoodsWhoCan');

--  zc_ObjectString_Unit_SetDateRROList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SetDateRROList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SetDateRROList', zc_Object_Unit(), 'Перечень дат авто установки времени на РРО' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SetDateRROList');

--  zc_ObjectString_InternetRepair_Provider() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Provider'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_Provider', zc_Object_InternetRepair(), 'Провайдер' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Provider');

--  zc_ObjectString_InternetRepair_ContractNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_ContractNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_ContractNumber', zc_Object_InternetRepair(), 'Номер договора' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_ContractNumber');

--  zc_ObjectString_InternetRepair_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_Phone', zc_Object_InternetRepair(), 'Телефон' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Phone');

--  zc_ObjectString_InternetRepair_WhoSignedContract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_WhoSignedContract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_WhoSignedContract', zc_Object_InternetRepair(), 'Кто оформил договор' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_WhoSignedContract');

--  zc_ObjectString_User_Language() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Language'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Language', zc_Object_User(), 'Язык справочников кассы' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Language');

--  zc_ObjectString_Goods_IdSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_IdSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_IdSP', zc_Object_Goods(), 'ID лікарського засобу в СП' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_IdSP');

--  zc_ObjectString_CashSettings_SendCashErrorTelId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_SendCashErrorTelId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_SendCashErrorTelId', zc_Object_CashSettings(), 'ID в телеграм для отправки ошибок на кассах' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_SendCashErrorTelId');

--  zc_ObjectString_PartionGoods_PartNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionGoods_PartNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectString_PartionGoods_PartNumber', ' Серийный номер  (№ по тех паспорту)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionGoods_PartNumber');
  
--  zc_ObjectString_SubjectDoc_Short() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Short'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_Short', 'Сокращенное название' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Short');

--  zc_ObjectLink_SubjectDoc_Reason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectLink_SubjectDoc_Reason', 'Причина возврата / перемещения' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason');

--  zc_ObjectString_SubjectDoc_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_MovementDesc', 'Вид документа' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_MovementDesc');

--  zc_ObjectString_SubjectDoc_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_Comment', 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Comment');


               
--  zc_ObjectString_Reason_Short() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Short'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_Reason(), 'zc_ObjectString_Reason_Short', 'Сокращенное название' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Short');










  SELECT lpUpdate__ ('zc_ObjectString_Enum', 0, 'Функция бизнес-логики' )
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GUID', zc_Object_ReplServer(), 'Ключ реплики' )
union all 
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_Host', zc_Object_ReplServer(), 'Сервер' )
union all 
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_User', zc_Object_ReplServer(), 'Пользоатель' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_User');
union all 
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_Password', zc_Object_ReplServer(), 'Пароль' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Password');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_Port', zc_Object_ReplServer(), 'Порт' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Port');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_DataBase', zc_Object_ReplServer(), 'База данных' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_DataBase');

union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_Comment', zc_Object_Asset(), 'Asset_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_Comment');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_FullName', zc_Object_Asset(), 'Asset_FullName' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_FullName');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_InvNumber', zc_object_Asset(), 'Инвентарный номер Основных средств' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_InvNumber');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_PassportNumber', zc_Object_Asset(), 'Asset_PassportNumber' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_PassportNumber');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_SerialNumber', zc_Object_Asset(), 'Asset_SerialNumber' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Bank_MFO', zc_object_Bank(), 'Bank_MFO' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Bank_MFO');





-- Function: lpUpdate__()

DROP FUNCTION IF EXISTS lpUpdate__ (TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpUpdate__(
inCode TVarChar, inDescId Integer, inItemName TVarChar
)
RETURNS integer AS
$BODY$
BEGIN
     --
     if inCode ilike '%zc_ObjectString_Member%' THEN RAISE EXCEPTION 'zc_ObjectString_Member =  <%>', inCode; END IF;
     
     IF 1 <> (SELECT COUNT(*)  FROM ObjectStringDesc where Code ilike inCode)
     THEN
         RAISE EXCEPTION 'COUNT <> 1 from = <%>', inCode;
     END IF;
     
     UPDATE ObjectStringDesc SET ItemName = inItemName where Code ilike inCode;
     
     return 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.13                                        *
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM lpUpdate__ (ioId:= 0, inSession:= zfCalc_UserAdmin())





--  zc_ObjectString_MemberSheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberSheetWorkTime_Comment', zc_Object_MemberSheetWorkTime(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment');

--  zc_ObjectString_MemberPersonalServiceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberPersonalServiceList_Comment', zc_Object_MemberPersonalServiceList(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment');


--  zc_ObjectString_MemberExternal_DriverCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_DriverCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberExternal_DriverCertificate', zc_object_MemberExternal(), 'Водительское удостоверение' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_DriverCertificate');

--  zc_ObjectString_MemberExternal_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberExternal_INN', zc_object_MemberExternal(), 'ИНН Физ.лица(стороннего)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_INN');

--  zc_ObjectString_MemberExternal_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_GLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberExternal_GLN', zc_object_MemberExternal(), 'GLN Физ.лица(стороннего)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_GLN');


--  zc_ObjectString_MemberMinus_BankAccountTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_BankAccountTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_BankAccountTo', zc_object_MemberMinus(), '№ счета получателя платежа' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_BankAccountTo');

--  zc_ObjectString_MemberMinus_DetailPayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_DetailPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_DetailPayment', zc_object_MemberMinus(), 'Назначение платежа' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_DetailPayment');

--  zc_ObjectString_MemberMinus_ToShort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_ToShort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_ToShort', zc_object_MemberMinus(), 'Юр. лицо (сокращенное значение)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_ToShort');

--  zc_ObjectString_MemberMinus_Number() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_Number'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_Number', zc_object_MemberMinus(), '№ исполнительного листа' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_Number');




 --  zc_ObjectString_MemberReport_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberReport_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberReport_Comment', zc_object_MemberReport(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberReport_Comment');



--  zc_ObjectString_MemberBranch_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberBranch_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberBranch_Comment', zc_Object_MemberBranch(), 'Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberBranch_Comment');


--  zc_ObjectString_MemberPriceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPriceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberPriceList_Comment', zc_Object_MemberPriceList(), ' 	Примечание' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPriceList_Comment');



