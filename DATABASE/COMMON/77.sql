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
-- select * from gpInsertUpdate_Movement_PromoTradeSign(inMovementId := 29309489 , inOrd := 3 , inValueId := null , inValue := '���� ����� ³��������' ,  inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');


 select gpComplete_All_Sybase(28872742 , false, '')
 select gpComplete_All_Sybase(28874886 , false, '')

update MovementDesc set ItemName  = ItemName2  
from (select 'zc_Movement_Income' as Code2 , '����������'  as ItemName2
union select 'zc_Movement_ReturnOut', '���������� �������������'
union select 'zc_Movement_Sale', '������'
union select 'zc_Movement_ReturnIn', '���������� �������'
union select 'zc_Movement_BankAccount', '������ �� ������������� �������'
union select 'zc_Movement_Service', '����������� ������'
union select 'zc_Movement_ProfitLossService', '����������� ������ (������� ������)'
) as a
where a.Code2 = Code 


select * from ObjectStringDesc where ItemName  ilike '%��������%'


"zc_ObjectString_GoodsPropertyValue_BarCode"
"zc_ObjectString_GoodsPropertyValue_Article"
"zc_ObjectString_GoodsPropertyValue_BarCodeGLN"
"zc_ObjectString_GoodsPropertyValue_ArticleGLN"


select * from ObjectStringDesc where Code = ItemName
and ItemName ilike '� ���������� �������� �� (�2 - ������)'

-- update ObjectStringDesc set ItemName = code where Code not ilike '%zc_ObjectString_Member_Card%'
-- and ItemName ilike '� ���������� �������� �� (�2 - ������)'

update ObjectStringDesc set ItemName = '� ���������� ����� �� - �������� (���������)' where Code =  'zc_ObjectString_Member_CardChild';
update ObjectStringDesc set ItemName = '� ���������� ����� �� (�1)' where Code =  'zc_ObjectString_Member_Card';
update ObjectStringDesc set ItemName = '� ���������� ����� IBAN �� (�1)' where Code =  'zc_ObjectString_Member_CardIBAN';
update ObjectStringDesc set ItemName = '� ���������� �������� �� (�1)' where Code =  'zc_ObjectString_Member_CardBank';
update ObjectStringDesc set ItemName = '� ���������� ����� �� (�2 - ������)' where Code =  'zc_ObjectString_Member_CardSecond';
update ObjectStringDesc set ItemName = '� ���������� ����� IBAN �� (�2 - ������)' where Code =  'zc_ObjectString_Member_CardIBANSecond';






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
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BankAccount_CBAccount', zc_Object_BankAccount(), '���� - ��� �������� � ������ ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccount');

--
--  zc_ObjectString_Car_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_Comment', zc_Object_Car(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_Comment');

--  zc_ObjectString_Car_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_RegistrationCertificate', zc_object_Car(), '���������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_RegistrationCertificate');

--  zc_ObjectString_Car_VIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_VIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_VIN', zc_Object_Car(), ' 	VIN-���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_VIN');

--  zc_ObjectString_Car_EngineNum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_EngineNum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Car_EngineNum', zc_Object_Car(), '����� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Car_EngineNum');


--  zc_ObjectString_CarExternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CarExternal_Comment', zc_Object_CarExternal(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_Comment');

--  zc_ObjectString_CarExternal_RegistrationCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CarExternal_RegistrationCertificate', zc_object_CarExternal(), '���������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_RegistrationCertificate');

--  zc_ObjectString_CarExternal_VIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_VIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CarExternal_VIN', zc_Object_CarExternal(), ' 	VIN-���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CarExternal_VIN');


-- --  zc_ObjectString_Contract_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
-- --  ObjectStringDesc (Code, DescId, ItemName)
--union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_InvNumber', zc_Object_Contract(), 'Contract_InvNumber' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumber');

--  zc_ObjectString_Contract_BankAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_BankAccount', zc_Object_Contract(), '��������� ���� (���.������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccount');

--  zc_ObjectString_Contract_BankAccountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_BankAccountPartner', zc_Object_Contract(), '��������� ���� (����������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_BankAccountPartner');

--  zc_ObjectString_Contract_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_Comment', zc_Object_Contract(), 'Contract_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_Comment');

--  zc_ObjectString_Contract_InvNumberArchive() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_InvNumberArchive', zc_Object_Contract(), 'Contract_InvNumberArchive' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_InvNumberArchive');

--  zc_ObjectString_Contract_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_GLNCode', zc_Object_Contract(), '��� GLN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_GLNCode');

--  zc_ObjectString_Contract_PartnerCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_PartnerCode', zc_Object_Contract(), '��� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_PartnerCode');


--  zc_ObjectString_ContactPerson_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ContactPerson_Comment', zc_Object_ContactPerson(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Comment');

--  zc_ObjectString_ContactPerson_Mail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ContactPerson_Mail', zc_Object_ContactPerson(), '����������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Mail');

--  zc_ObjectString_ContactPerson_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ContactPerson_Phone', zc_Object_ContactPerson(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ContactPerson_Phone');

--  zc_objectString_Currency_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_objectString_Currency_InternalName', zc_object_Currency(), 'Currency_InternalName' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_objectString_Currency_InternalName');

-- zc_Object_Goods                           

--  zc_ObjectString_Goods_GroupNameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_GroupNameFull', zc_Object_Goods(), '������ �������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GroupNameFull');

--  zc_ObjectString_Goods_Maker() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Maker', zc_Object_Goods(), '�������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Maker');

--  zc_ObjectString_Goods_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_UKTZED', zc_Object_Goods(), '��� ������ ����� � ��� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED');

--  zc_ObjectString_Goods_UKTZED_main() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_main'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_UKTZED_main', zc_Object_Goods(), '��� ������ ����� � ��� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_main');


--  zc_ObjectString_Goods_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_DKPP', zc_Object_Goods(), '������� ����� � ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_DKPP');

--  zc_ObjectString_Goods_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_TaxImport', zc_Object_Goods(), '������ ������������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxImport');

--  zc_ObjectString_Goods_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_TaxAction', zc_Object_Goods(), '��� ���� �������� �����-�������� ��������������� ' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_TaxAction');

--  zc_ObjectString_Goods_RUS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_RUS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_RUS', zc_Object_Goods(), '�������� ������(����.)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_RUS');

--  zc_ObjectString_Goods_BUH() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_BUH'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_BUH', zc_Object_Goods(), '�������� ������(����.)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_BUH');

--
--  zc_ObjectString_GoodsPropertyValue_Article() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Article', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_Article' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Article');

--  zc_ObjectString_GoodsPropertyValue_ArticleGLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_ArticleGLN', zc_Object_GoodsPropertyValue(), 'GoodsPropertyValue_ArticleGLN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleGLN');

--  zc_ObjectString_Goods_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_NameUkr', zc_Object_Goods(), '�������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_NameUkr');

--  zc_ObjectString_Goods_CodeUKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_CodeUKTZED', zc_Object_Goods(), '��� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeUKTZED');

--  zc_ObjectString_Goods_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_UKTZED_new', zc_Object_Goods(), '����� ��� ������ ����� � ��� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_UKTZED_new');


--  zc_ObjectString_Goods_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ShortName', zc_Object_Goods(), '�������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ShortName');

--  zc_ObjectString_Goods_Scale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Scale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Scale', zc_Object_Goods(), '�������� ������(��� ���������� Scale)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Scale');


-- zc_Object_GoodsPropertyValue
--  zc_ObjectString_GoodsPropertyValue_BarCodeShort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_BarCodeShort', zc_Object_GoodsPropertyValue(), '����� ����� ���� (����� ��� ������������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_BarCodeShort');

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
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Quality2', zc_Object_GoodsPropertyValue(), '����� ���������� (��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality2');

--  zc_ObjectString_GoodsPropertyValue_Quality10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Quality10', zc_Object_GoodsPropertyValue(), '����� ��������� (��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality10');

--  zc_ObjectString_GoodsPropertyValue_Quality() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_Quality', zc_Object_GoodsPropertyValue(), '�������� ����, ����,�� (��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_Quality');

--  zc_ObjectString_GoodsPropertyValue_NameExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_NameExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_NameExternal', zc_Object_GoodsPropertyValue(), '�������� � ���� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_NameExternal');

--  zc_ObjectString_GoodsPropertyValue_ArticleExternal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleExternal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_ArticleExternal', zc_Object_GoodsPropertyValue(), '������� � ���� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_ArticleExternal');


--  zc_ObjectString_Juridical_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_GLNCode', zc_Object_Juridical(), 'Juridical_GLNCode' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GLNCode');

--  zc_ObjectString_Juridical_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_OrderSumm', zc_Object_Juridical(), '���������� � ����������� ����� ��� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderSumm');

--  zc_ObjectString_Juridical_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_OrderTime', zc_Object_Juridical(), '������������ - ������������ ����� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_OrderTime');

--  zc_ObjectString_Juridical_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_GUID', zc_Object_Juridical(), '���������� ���������� �������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_GUID');







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

-- !!!��������!!!
--  zc_ObjectString_Partner_NameInteger() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_NameInteger', zc_Object_Partner(), '�������� Integer' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_NameInteger');

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
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Address', zc_Object_Partner(), '����� ����� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Address');

--  zc_ObjectString_Partner_HouseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_HouseNumber', zc_Object_Partner(), '����� ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_HouseNumber');

--  zc_ObjectString_Partner_CaseNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_CaseNumber', zc_Object_Partner(), '����� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_CaseNumber');

--  zc_ObjectString_Partner_RoomNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_RoomNumber', zc_Object_Partner(), '����� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_RoomNumber');

--  zc_ObjectString_Partner_KATOTTG() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_KATOTTG'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_KATOTTG', zc_Object_Partner(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_KATOTTG');

--  zc_ObjectString_Partner_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_ShortName', zc_Object_Partner(), '�������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_ShortName');

--  zc_ObjectString_Partner_Schedule() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Schedule', zc_Object_Partner(), '������ ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Schedule');

--  zc_ObjectString_Partner_Delivery() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Delivery', zc_Object_Partner(), '������ ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Delivery');

--  zc_ObjectString_Partner_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_GUID', zc_Object_Partner(), '���������� ���������� �������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_GUID');

--  zc_ObjectString_Partner_Movement() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Movement'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Movement', zc_Object_Partner(), '����������(��� ��������� �������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Movement');

--  zc_ObjectString_Partner_BranchCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_BranchCode', zc_Object_Partner(), '����� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchCode');

--  zc_ObjectString_Partner_BranchJur() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchJur'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_BranchJur', zc_Object_Partner(), '�������� ��.���� ��� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_BranchJur');

--  zc_ObjectString_Partner_Terminal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Terminal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Partner_Terminal', zc_Object_Partner(), '��� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Partner_Terminal');

 
 
 

--  zc_ObjectString_ReceiptChild_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ReceiptChild_Comment', zc_Object_ReceiptChild(), '������������ �������� - ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptChild_Comment');

--  zc_ObjectString_Receipt_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Receipt_Code', zc_Object_Receipt(), '��� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Code');

--  zc_ObjectString_Receipt_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Receipt_Comment', zc_Object_Receipt(), '�����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Receipt_Comment');

--  zc_ObjectString_ToolsWeighing_NameFull() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ToolsWeighing_NameFull', zc_ObjectString_ToolsWeighing_NameFull(), '������ ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameFull');

--  zc_ObjectString_ToolsWeighing_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ToolsWeighing_Name', zc_ObjectString_ToolsWeighing_Name(), '��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_Name');

--  zc_ObjectString_ToolsWeighing_NameUser() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ToolsWeighing_NameUser', zc_ObjectString_ToolsWeighing_NameUser(), '�������� ��� ������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ToolsWeighing_NameUser');

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
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CityKind_ShortName', zc_Object_CityKind(), '�������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CityKind_ShortName');

--  zc_ObjectString_StreetKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StreetKind_ShortName', zc_Object_StreetKind(), '�������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StreetKind_ShortName');


--
--  zc_ObjectString_User_Password() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Password', zc_Object_User(), '������ ������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Password');

--  zc_ObjectString_User_PasswordWages() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PasswordWages'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_PasswordWages', zc_Object_User(), '����� ��� ��������� ����� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PasswordWages');

--  zc_ObjectString_User_Sign() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Sign', zc_Object_User(), '����������� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Sign');

--  zc_ObjectString_User_Seal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Seal', zc_Object_User(), '����������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Seal');

--  zc_ObjectString_User_Key() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Key', zc_Object_User(), '���������� ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Key');

--  zc_ObjectString_User_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Foto', zc_Object_User(), '���� � ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Foto');

--  zc_ObjectString_User_PhoneAuthent() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PhoneAuthent'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_PhoneAuthent', zc_Object_User(), '� �������� ��� ��������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_PhoneAuthent');

--  zc_ObjectString_User_GUID() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_GUID'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_GUID', zc_Object_User(), 'UUID ������ ������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_GUID');

--  zc_ObjectString_User_SMS() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_SMS'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_SMS', zc_Object_User(), 'SMS ��� ������������� ' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_SMS');

 
--  zc_ObjectString_WorkTimeKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_WorkTimeKind_ShortName', zc_Object_WorkTimeKind(), '�������� ������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_WorkTimeKind_ShortName');

--  zc_ObjectString_Measure_InternalName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Measure_InternalName', zc_Object_Measure(), '������������� ������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalName');

--  zc_ObjectString_Measure_InternalCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Measure_InternalCode', zc_Object_Measure(), '������������� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Measure_InternalCode');

--  zc_ObjectString_GoodsPropertyValue_GroupName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsPropertyValue_GroupName', zc_Object_GoodsPropertyValue(), '�������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsPropertyValue_GroupName');

--  zc_ObjectString_Retail_GLNCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Retail_GLNCode', zc_Object_Retail(), '��� GLN - ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCode');

--  zc_ObjectString_Retail_GLNCodeCorporate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Retail_GLNCodeCorporate', zc_Object_Retail(), ' ���GLN - ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_GLNCodeCorporate');

--  zc_ObjectString_Retail_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Retail_OKPO', zc_Object_Retail(), '���� ��� �����. ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Retail_OKPO');

--  zc_ObjectString_GoodsByGoodsKind_Quality1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsByGoodsKind_Quality1', zc_Object_GoodsByGoodsKind(), '��� ��������, ������� 4' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality1');

--  zc_ObjectString_GoodsByGoodsKind_Quality11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsByGoodsKind_Quality11', zc_Object_GoodsByGoodsKind(), '��� ���������/���� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsByGoodsKind_Quality11');

---zc_Object_GoodsQuality

--  zc_ObjectString_GoodsQuality_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value1', zc_Object_GoodsQuality(), '��� ��������, ������� 4' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value1');

--  zc_ObjectString_GoodsQuality_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value2', zc_Object_GoodsQuality(), '����� ���������, ������� 6' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value2');

--  zc_ObjectString_GoodsQuality_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value3', zc_Object_GoodsQuality(), '����� �����. � ���.�����.(�������), ������� 7' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value3');

--  zc_ObjectString_GoodsQuality_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value4', zc_Object_GoodsQuality(), '����� ��������� � ���.���������, ������� 8' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value4');

--  zc_ObjectString_GoodsQuality_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value5', zc_Object_GoodsQuality(), '�������� �������� - ����� ��������� ����� �������, ������� 10' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value5');

--  zc_ObjectString_GoodsQuality_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value6', zc_Object_GoodsQuality(), '�������� �������� - ����� ��������� �������� ������, ������� 11' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value6');

--  zc_ObjectString_GoodsQuality_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value7', zc_Object_GoodsQuality(), '�������� �������� - ����� ��������� ������������� ������, ������� 12' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value7');
--  zc_ObjectString_GoodsQuality_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value8', zc_Object_GoodsQuality(), '����������� ��������� � ������ �� �������������� �������� ����������, ������� 14' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value8');
--  zc_ObjectString_GoodsQuality_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value9', zc_Object_GoodsQuality(), '����������� ��������� � �������� ����������, ������� 15' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value9');
--  zc_ObjectString_GoodsQuality_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsQuality_Value10', zc_Object_GoodsQuality(), '����� ���������, ������� 16' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsQuality_Value10');

--!!!Quality
--  zc_ObjectString_Quality_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Quality_Comment', zc_Object_Quality(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_Comment');

--  zc_ObjectString_Quality_MemberMain() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Quality_MemberMain', zc_Object_Quality(), '��������� ��������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberMain');

--  zc_ObjectString_Quality_MemberTech() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Quality_MemberTech', zc_Object_Quality(), '�������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Quality_MemberTech');


--  zc_ObjectString_InvNumberTax_InvNumberBranch() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InvNumberTax_InvNumberBranch', zc_Object_InvNumberTax(), '����� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InvNumberTax_InvNumberBranch');

--  zc_ObjectString_Branch_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Branch_InvNumber', zc_Object_Branch(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_InvNumber');

--  zc_ObjectString_Branch_PlaceOf() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Branch_PlaceOf', zc_Object_Branch(), '̳��� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PlaceOf');

--  zc_ObjectString_Branch_PersonalBookkeeper() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PersonalBookkeeper'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Branch_PersonalBookkeeper', zc_Object_Branch(), '��������� (���������) ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Branch_PersonalBookkeeper');

--  zc_ObjectString_Form_HelpFile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Form_HelpFile', zc_Object_Form(), '���� � ����� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Form_HelpFile');

--  zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Address', zc_object_Unit(), '�����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

--  zc_ObjectString_Unit_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Phone', zc_object_Unit(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Phone');

--  zc_ObjectString_Unit_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Comment', zc_object_Unit(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Comment');


--  zc_ObjectString_Storage_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Storage_Address', zc_object_Storage(), '����� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Address');

--  zc_ObjectString_Storage_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Storage_Comment', zc_object_Storage(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Comment');

--  zc_ObjectString_Storage_Room() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Room'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Storage_Room', zc_object_Storage(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Storage_Room');



--  zc_ObjectString_SignInternal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SignInternal_Comment', zc_object_SignInternal(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SignInternal_Comment');

--  zc_ObjectString_MobileEmployee_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileEmployee_Comment', zc_Object_MobileEmployee(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileEmployee_Comment');

--  zc_ObjectString_MobileTariff_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileTariff_Comment', zc_Object_MobileTariff(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileTariff_Comment');

--  zc_ObjectString_MobileConst_MobileVersion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileConst_MobileVersion', zc_Object_MobileConst(), '������ ���������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileVersion');

--  zc_ObjectString_MobileConst_MobileAPKFileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobileConst_MobileAPKFileName', zc_Object_MobileConst(), '�������� ".apk" ����� ���������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobileConst_MobileAPKFileName');

--
--  zc_ObjectString_SheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SheetWorkTime_Comment', zc_Object_SheetWorkTime(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_Comment');

--  zc_ObjectString_SheetWorkTime_DayOffPeriod() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SheetWorkTime_DayOffPeriod', zc_Object_SheetWorkTime(), '������������� � ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffPeriod');

--  zc_ObjectString_SheetWorkTime_DayOffWeek() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SheetWorkTime_DayOffWeek', zc_Object_SheetWorkTime(), '��� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SheetWorkTime_DayOffWeek');

--  zc_ObjectString_GoodsListSale_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsListSale_GoodsKind', zc_Object_GoodsListSale(), '������ ���� ��� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListSale_GoodsKind');

--  zc_ObjectString_GoodsListIncome_GoodsKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsListIncome_GoodsKind', zc_Object_GoodsListIncome(), '������ ���� ��� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsListIncome_GoodsKind');

--  zc_ObjectString_GoodsGroup_UKTZED() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_UKTZED', zc_Object_GoodsGroup(), '��� ������ ����� � ��� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED');

--  zc_ObjectString_GoodsGroup_UKTZED_new() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED_new'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_UKTZED_new', zc_Object_GoodsGroup(), '����� ��� ������ ����� � ��� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_UKTZED_new');


--  zc_ObjectString_GoodsGroup_DKPP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_DKPP', zc_Object_GoodsGroup(), '������� ����� � ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_DKPP');

--  zc_ObjectString_GoodsGroup_TaxImport() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_TaxImport', zc_Object_GoodsGroup(), '������ ������������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxImport');

--  zc_ObjectString_GoodsGroup_TaxAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsGroup_TaxAction', zc_Object_GoodsGroup(), '��� ���� �������� �����-�������� ���������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsGroup_TaxAction');

--  zc_ObjectString_StorageLine_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StorageLine_Comment', zc_Object_StorageLine(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StorageLine_Comment');

--  zc_ObjectString_ArticleLoss_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ArticleLoss_Comment', zc_Object_ArticleLoss(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ArticleLoss_Comment');

--
--  zc_ObjectString_StickerGroup_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerGroup_Comment', zc_Object_StickerGroup(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerGroup_Comment');

--  zc_ObjectString_StickerType_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerType_Comment', zc_Object_StickerType(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerType_Comment');

--  zc_ObjectString_StickerTag_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerTag_Comment', zc_Object_StickerTag(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerTag_Comment');

--  zc_ObjectString_StickerSort_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerSort_Comment', zc_Object_StickerSort(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSort_Comment');

--  zc_ObjectString_StickerNorm_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerNorm_Comment', zc_Object_StickerNorm(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerNorm_Comment');

--  zc_ObjectString_StickerFile_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerFile_Comment', zc_Object_StickerFile(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerFile_Comment');

--  zc_ObjectString_StickerSkin_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerSkin_Comment', zc_Object_StickerSkin(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerSkin_Comment');

--  zc_ObjectString_StickerPack_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerPack_Comment', zc_Object_StickerPack(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerPack_Comment');

--  zc_ObjectString_Language_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Comment', zc_Object_Language(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Comment');

--  zc_ObjectString_Language_Value1() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value1', zc_Object_Language(), '�����:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value1');

--  zc_ObjectString_Language_Value2() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value2', zc_Object_Language(), '����� �� ����� ���������:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value2');

--  zc_ObjectString_Language_Value3() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value3', zc_Object_Language(), '�� ������� �������� ������ ��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value3');

--  zc_ObjectString_Language_Value4() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value4', zc_Object_Language(), '��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value4');

--  zc_ObjectString_Language_Value5() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value5', zc_Object_Language(), '�� ����������� ��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value5');

--  zc_ObjectString_Language_Value6() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value6', zc_Object_Language(), '��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value6');

--  zc_ObjectString_Language_Value7() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value7', zc_Object_Language(), '�� ���� ��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value7');

--  zc_ObjectString_Language_Value8() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value8', zc_Object_Language(), '������� ������� �� ���������� � 100��.��������:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value8');

--  zc_ObjectString_Language_Value9() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value9', zc_Object_Language(), '���� �� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value9');

--  zc_ObjectString_Language_Value10() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value10', zc_Object_Language(), '��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value10');

--  zc_ObjectString_Language_Value11() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value11', zc_Object_Language(), '���� �� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value11');

--  zc_ObjectString_Language_Value12() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value12', zc_Object_Language(), '��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value12');

--  zc_ObjectString_Language_Value13() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value13', zc_Object_Language(), '����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value13');

--  zc_ObjectString_Language_Value14() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value14'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value14', zc_Object_Language(), '��.' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value14');

--  zc_ObjectString_Language_Value15() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value15'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value15', zc_Object_Language(), '��������� �� �����:' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value15');

--  zc_ObjectString_Language_Value16() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value16'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value16', zc_Object_Language(), '��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value16');

--  zc_ObjectString_Language_Value17() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value17'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Language_Value17', zc_Object_Language(), '���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Language_Value17');

---
--  zc_ObjectString_StickerProperty_BarCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_StickerProperty_BarCode', zc_Object_StickerProperty(), '��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_StickerProperty_BarCode');


--  zc_ObjectString_DocumentTaxKind_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_Code', zc_Object_DocumentTaxKind(), '��� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Code');

--  zc_ObjectString_DocumentTaxKind_Goods() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Goods'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_Goods', zc_Object_DocumentTaxKind(), '������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Goods');

--  zc_ObjectString_DocumentTaxKind_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_Measure', zc_Object_DocumentTaxKind(), '��.���.' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_Measure');

--  zc_ObjectString_DocumentTaxKind_MeasureCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_MeasureCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DocumentTaxKind_MeasureCode', zc_Object_DocumentTaxKind(), '��� ��.���.' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DocumentTaxKind_MeasureCode');

--  zc_ObjectString_GoodsTypeKind_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsTypeKind_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsTypeKind_ShortName', zc_object_GoodsTypeKind(), '�������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsTypeKind_ShortName');

--  zc_ObjectString_OrderFinance_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_OrderFinance_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_OrderFinance_Comment', zc_object_OrderFinance(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_OrderFinance_Comment');



--  zc_ObjectString_PartnerExternal_ObjectCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerExternal_ObjectCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PartnerExternal_ObjectCode', zc_object_PartnerExternal(), '��� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerExternal_ObjectCode');

--  zc_ObjectString_JuridicalOrderFinance_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalOrderFinance_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_JuridicalOrderFinance_Comment', zc_object_JuridicalOrderFinance(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalOrderFinance_Comment');

--  zc_ObjectString_PersonalServiceList_ContentType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_ContentType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PersonalServiceList_ContentType', zc_Object_PersonalServiceList(), ' Content-Type' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_ContentType');

--  zc_ObjectString_PersonalServiceList_OnFlowType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_OnFlowType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PersonalServiceList_OnFlowType', zc_Object_PersonalServiceList(), '��� ���������� � �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PersonalServiceList_OnFlowType');

--  zc_ObjectString_FineSubject_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FineSubject_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_FineSubject_Comment', zc_Object_FineSubject(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FineSubject_Comment');

--  zc_ObjectString_ReceiptLevel_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptLevel_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ReceiptLevel_Comment', zc_Object_ReceiptLevel(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReceiptLevel_Comment');

--  zc_ObjectString_Reason_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Reason_Comment', zc_Object_Reason(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Comment');

--  zc_ObjectString_MobilePack_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobilePack_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MobilePack_Comment', zc_Object_MobilePack(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MobilePack_Comment');


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
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PairDay_Comment', zc_object_PairDay(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PairDay_Comment');

/*
--  zc_ObjectString_Area_TelegramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Area_TelegramId', zc_object_Area(), '������ ����������� � �������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramId');

 --  zc_ObjectString_Area_TelegramBotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramBotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Area_TelegramBotToken', zc_object_Area(), '����� ����������� �������� ���� � �������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_TelegramBotToken');
 */
 
--  zc_ObjectString_TelegramGroup_Id() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_Id'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_TelegramGroup_Id', zc_object_Area(), '������ ����������� � �������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_Id');

 --  zc_ObjectString_TelegramGroup_BotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_BotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_TelegramGroup_BotToken', zc_object_TelegramGroup(), '����� ����������� �������� ���� � �������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_TelegramGroup_BotToken');




 --  zc_ObjectString_PartionCell_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionCell_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PartionCell_Comment', zc_object_PartionCell(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionCell_Comment');


 --  zc_ObjectString_ViewPriceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ViewPriceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ViewPriceList_Comment', zc_object_ViewPriceList(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ViewPriceList_Comment');

 --  zc_ObjectString_ChoiceCell_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ChoiceCell_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ChoiceCell_Comment', zc_object_ChoiceCell(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ChoiceCell_Comment');

 --  zc_ObjectString_GoodsNormDiff_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsNormDiff_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsNormDiff_Comment', zc_object_GoodsNormDiff(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsNormDiff_Comment');
   
 --  zc_ObjectString_RouteNum_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RouteNum_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_RouteNum_Comment', zc_object_RouteNum(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RouteNum_Comment');







---!!! ������

--  zc_ObjectString_Goods_Code() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Code', zc_Object_Goods(), '��������� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Code');

--  zc_ObjectString_ImportSettings_Directory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportSettings_Directory', zc_Object_ImportSettings(), '���������� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettings_Directory');

--  zc_ObjectString_ImportType_ProcedureName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportType_ProcedureName', zc_Object_ImportType(), '��� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_ProcedureName');

--  zc_ObjectString_ImportTypeItems_ParamType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportTypeItems_ParamType', zc_Object_ImportTypeItems(), '��� ��������� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_ParamType');

--  zc_ObjectString_ImportTypeItems_UserParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportTypeItems_UserParamName', zc_Object_ImportTypeItems(), '���������������� �������� ��������� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportTypeItems_UserParamName');

--  zc_ObjectString_ImportSettingsItems_DefaultValue() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportSettingsItems_DefaultValue', zc_Object_ImportSettingsItems(), '�������� �� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportSettingsItems_DefaultValue');
  
--  zc_ObjectString_Goods_Foto() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Foto', zc_Object_Goods(), '���� � ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Foto');
  
--  zc_ObjectString_Goods_Thumb() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Thumb', zc_Object_Goods(), '���� � ������ ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Thumb');


--  zc_ObjectString_Email_ErrorTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Email_ErrorTo', zc_object_Email(), '���� ���������� ��������� �� ������ ��� �������� ������ � �/�' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Email_ErrorTo');


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
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalTools_ExternalUnit', zc_Object_DiscountExternalTools(), '������������� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_ExternalUnit');

--  zc_ObjectString_DiscountExternalJuridical_ExternalJuridical() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical', zc_Object_DiscountExternalJuridical(), '����������� ���� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalJuridical_ExternalJuridical');

--  zc_ObjectString_Goods_Pack() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Pack', zc_object_Goods(), '���� 䳿/ ��������� (5)(��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Pack');

--  zc_ObjectString_Goods_CodeATX() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_CodeATX', zc_object_Goods(), '��� ��� (7)(��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_CodeATX');

--  zc_ObjectString_Goods_ReestrSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ReestrSP', zc_object_Goods(), '� ������������� ���������� �� ��������� ���� (9)(��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrSP');

--  zc_ObjectString_Goods_ReestrDateSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ReestrDateSP', zc_object_Goods(), '���� ��������� ������ 䳿 ������������� ���������� �� ��������� ����(10)(��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ReestrDateSP');

--  zc_ObjectString_Goods_MakerSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_MakerSP', zc_object_Goods(), '������������ ���������, �����(8)(��)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerSP');

--  zc_ObjectString_User_ProjectMobile() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_ProjectMobile', '�������� � ��� ����-��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_ProjectMobile');

--  zc_ObjectString_User_MobileModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileModel', '������ ��� ����-��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileModel');

--  zc_ObjectString_User_MobileVesion() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesion', '������ ������� ����-��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesion');

--  zc_ObjectString_User_MobileVesionSDK() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_User(), 'zc_ObjectString_User_MobileVesionSDK', '������ SDK ����-��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_MobileVesionSDK');
  

--  zc_ObjectString_PartnerMedical_FIO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PartnerMedical_FIO', zc_object_PartnerMedical(), '��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartnerMedical_FIO');

--  zc_ObjectString_Unit_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Address', zc_object_Unit(), '����� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Address');

--  zc_ObjectString_Unit_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_GLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_GLN', zc_object_Unit(), 'GLN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_GLN');

--  zc_ObjectString_Unit_KATOTTG() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_KATOTTG'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_KATOTTG', zc_object_Unit(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_KATOTTG');

--  zc_ObjectString_Unit_AddressEDIN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AddressEDIN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_AddressEDIN', zc_object_Unit(), '����� ��� EDIN' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AddressEDIN');



--  zc_ObjectString_Contract_OrderSumm() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_OrderSumm', zc_Object_Contract(), '���������� � ����������� ����� ��� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderSumm');

--  zc_ObjectString_Contract_OrderTime() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Contract_OrderTime', zc_Object_Contract(), '������������ - ������������ ����� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Contract_OrderTime');

--  zc_ObjectString_Area_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Area_Email', zc_Object_Area(), '�� ����� ����� �������� ���� �� ������� ��� ����� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Area_Email');

--  zc_ObjectString_JuridicalArea_Email() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_JuridicalArea_Email', zc_Object_JuridicalArea(), '�� ����� ����� ���������� �� ���������� ���� �� ������� ��� ����� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_JuridicalArea_Email');

--  zc_ObjectString_PromoCode_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PromoCode_Comment', zc_Object_PromoCode(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PromoCode_Comment');

--  zc_ObjectString_Fiscal_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Fiscal_SerialNumber', zc_Object_Fiscal(), '���� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_SerialNumber');

--  zc_ObjectString_Fiscal_InvNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Fiscal_InvNumber', zc_Object_Fiscal(), '����� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Fiscal_InvNumber');

--  zc_ObjectString_ImportType_JSONParamName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ImportType_JSONParamName', zc_Object_ImportType(), '��� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ImportType_JSONParamName');
  

--  zc_ObjectString_ClientsByBank_OKPO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_OKPO', zc_Object_ClientsByBank(), '����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_OKPO');

--  zc_ObjectString_ClientsByBank_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_INN', zc_Object_ClientsByBank(), '���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_INN');

--  zc_ObjectString_ClientsByBank_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_Phone', zc_Object_ClientsByBank(), '��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Phone');

--  zc_ObjectString_ClientsByBank_ContactPerson() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_ContactPerson', zc_Object_ClientsByBank(), '���������� ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_ContactPerson');

--  zc_ObjectString_ClientsByBank_RegAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_RegAddress', zc_Object_ClientsByBank(), '����� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_RegAddress');

--  zc_ObjectString_ClientsByBank_SendingAddress() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_SendingAddress', zc_Object_ClientsByBank(), '����� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_SendingAddress');

--  zc_ObjectString_ClientsByBank_Accounting() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_Accounting', zc_Object_ClientsByBank(), '�����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Accounting');

--  zc_ObjectString_ClientsByBank_PhoneAccountancy() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_PhoneAccountancy', zc_Object_ClientsByBank(), '������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_PhoneAccountancy');

--  zc_ObjectString_ClientsByBank_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_ClientsByBank_Comment', zc_Object_ClientsByBank(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ClientsByBank_Comment');

--  zc_ObjectString_Asset_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Asset_SerialNumber', zc_Object_Asset(), 'Asset_SerialNumber' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_SerialNumber');

--  zc_ObjectString_CashRegister_SerialNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_SerialNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_SerialNumber', zc_Object_CashRegister(), '����� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_SerialNumber');

--  zc_ObjectString_HelsiEnum() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_HelsiEnum'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_HelsiEnum', zc_Object_HelsiEnum(), '�������� ������� � ����� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_HelsiEnum');

--  zc_ObjectString_User_Helsi_UserName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_UserName', zc_Object_User(), '��� ������������ �� ����� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserName');

--  zc_ObjectString_User_Helsi_UserPassword() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserPassword'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_UserPassword', zc_Object_User(), '������ ������������ �� ����� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_UserPassword');

--  zc_ObjectString_User_Helsi_KeyPassword() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_KeyPassword'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_KeyPassword', zc_Object_User(), '������ � ��������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_KeyPassword');

--  zc_ObjectString_User_Helsi_PasswordEHels() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_PasswordEHels'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Helsi_PasswordEHels', zc_Object_User(), '������ �-����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Helsi_PasswordEHels');

--  zc_ObjectString_Goods_Analog() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Analog'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Analog', zc_Object_Goods(), '�������� �������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Analog');

--  zc_ObjectString_Driver_E_Mail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Driver_E_Mail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Driver_E_Mail', zc_Object_Driver(), 'e-mail ��� �������� ������� �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Driver_E_Mail');
 
--  zc_ObjectString_PayrollType_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollType_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PayrollType_ShortName', zc_Object_PayrollType(), '�������� ������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollType_ShortName');

--  zc_ObjectString_Juridical_CBName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBName', zc_Object_Juridical(), '������ �������� ���������� ��� ������ �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBName');

--  zc_ObjectString_Juridical_CBMFO() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBMFO'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBMFO', zc_Object_Juridical(), '��� ��� ������ �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBMFO');

--  zc_ObjectString_Juridical_CBAccount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBAccount', zc_Object_Juridical(), '��������� ���� ��� ������ �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccount');

--  zc_ObjectString_Juridical_CBAccountOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccountOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBAccountOld', zc_Object_Juridical(), '��������� ���� ������ ��� ������ �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBAccountOld');

--  zc_ObjectString_Juridical_CBPurposePayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBPurposePayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Juridical_CBPurposePayment', zc_ObjectString_Juridical_CBPurposePayment(), '���������� ������� ��� ������ �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Juridical_CBPurposePayment');

--  zc_ObjectString_BankAccount_CBAccountOld() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccountOld'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BankAccount_CBAccountOld', zc_Object_BankAccount(), '���� ������ - ��� �������� � ������ ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BankAccount_CBAccountOld');


--  zc_ObjectString_Unit_Latitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Latitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Latitude', zc_object_Unit(), '�������������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Latitude');

--  zc_ObjectString_Unit_Longitude() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Longitude'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_Longitude', zc_object_Unit(), '�������������� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_Longitude');

--  zc_ObjectString_Unit_ListDaySUN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_ListDaySUN', zc_object_Unit(), '�� ����� ���� ������ �� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN');

--  zc_ObjectString_CashSettings_ShareFromPriceName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_ShareFromPriceName', zc_Object_CashSettings(), '�������� ���� � ��������� ������� ������� ����� ������ � ����� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceName');

--  zc_ObjectString_CashSettings_ShareFromPriceCode() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceCode'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_ShareFromPriceCode', zc_Object_CashSettings(), '�������� ����� ������� ������� ����� ������ � ����� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_ShareFromPriceCode');

--  zc_ObjectString_Unit_AccessKeyYF() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AccessKeyYF'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_AccessKeyYF', zc_object_Unit(), '���� �� ��� �������� ������ ����-����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_AccessKeyYF');

--  zc_ObjectString_Unit_ListDaySUN_pi() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN_pi'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_ListDaySUN_pi', zc_object_Unit(), '�� ����� ���� ������ ����������� ���2-�������.��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_ListDaySUN_pi');

--  zc_ObjectString_Unit_SUN_v1_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v1_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SUN_v1_Lock', zc_object_Unit(), '������ � ���-1 ��� 1)���������� ��� "�� ��� ���" 2)������ "������ ���" 3)������ "���� ���"' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v1_Lock');

--  zc_ObjectString_Unit_SUN_v2_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v2_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SUN_v2_Lock', zc_object_Unit(), '������ � ���-2 ��� 1)���������� ��� "�� ��� ���" 2)������ "������ ���" 3)������ "���� ���"' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v2_Lock');

--  zc_ObjectString_Unit_SUN_v4_Lock() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v4_Lock'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SUN_v4_Lock', zc_object_Unit(), '������ � ���-2-�� ��� 1)���������� ��� "�� ��� ���" 2)������ "������ ���" 3)������ "���� ���"' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SUN_v4_Lock');


--  zc_ObjectString_Buyer_Name() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Name'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Name', zc_Object_Buyer(), '������� ��� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Name');

--  zc_ObjectString_Buyer_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Phone', zc_Object_Buyer(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Phone');

--  zc_ObjectString_Buyer_EMail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_EMail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_EMail', zc_object_Buyer(), '����������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_EMail');

--  zc_ObjectString_Buyer_Address() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Address'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Address', zc_object_Buyer(), '����� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Address');

--  zc_ObjectString_Buyer_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Comment', zc_object_Buyer(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Comment');

--  zc_ObjectString_Buyer_DateBirth() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_DateBirth'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_DateBirth', zc_object_Buyer(), '���� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_DateBirth');

--  zc_ObjectString_Buyer_Sex() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Sex'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Buyer_Sex', zc_object_Buyer(), '���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Buyer_Sex');

--  zc_ObjectString_DriverSun_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DriverSun_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DriverSun_Phone', zc_Object_DriverSun(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DriverSun_Phone');
 
--  zc_ObjectString_CashRegister_ComputerName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ComputerName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_ComputerName', zc_Object_CashRegister(), '��� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ComputerName');

--  zc_ObjectString_CashRegister_BaseBoardProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_BaseBoardProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_BaseBoardProduct', zc_Object_CashRegister(), '����������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_BaseBoardProduct');
 
--  zc_ObjectString_CashRegister_ProcessorName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ProcessorName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_ProcessorName', zc_Object_CashRegister(), '���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_ProcessorName');

--  zc_ObjectString_CashRegister_DiskDriveModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_DiskDriveModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_DiskDriveModel', zc_Object_CashRegister(), '������� ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_DiskDriveModel');

--  zc_ObjectString_CashRegister_TaxRate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_TaxRate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_TaxRate', zc_Object_CashRegister(), '��������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_TaxRate');

--  zc_ObjectString_CashRegister_PhysicalMemory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_PhysicalMemory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashRegister_PhysicalMemory', zc_Object_CashRegister(), '����������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashRegister_PhysicalMemory');
 

--  zc_ObjectString_Hardware_BaseBoardProduct() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_BaseBoardProduct'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_BaseBoardProduct', zc_Object_Hardware(), '����������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_BaseBoardProduct');
 
--  zc_ObjectString_Hardware_ProcessorName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ProcessorName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_ProcessorName', zc_Object_Hardware(), '���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ProcessorName');

--  zc_ObjectString_Hardware_DiskDriveModel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_DiskDriveModel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_DiskDriveModel', zc_Object_Hardware(), '������� ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_DiskDriveModel');

--  zc_ObjectString_Hardware_PhysicalMemory() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_PhysicalMemory'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_PhysicalMemory', zc_Object_Hardware(), '����������� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_PhysicalMemory');
   
--  zc_ObjectString_Hardware_Identifier() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Identifier'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_Identifier', zc_Object_Hardware(), '�������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Identifier');

--  zc_ObjectString_Hardware_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_Comment', zc_Object_Hardware(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_Comment');

--  zc_ObjectString_Goods_AnalogATC() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_AnalogATC'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_AnalogATC', zc_Object_Goods(), '�������� �������� ������ ATC' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_AnalogATC');

--  zc_ObjectString_Goods_ActiveSubstance() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ActiveSubstance'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_ActiveSubstance', zc_Object_Goods(), '����������� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_ActiveSubstance');

--  zc_ObjectString_DiscountExternalTools_Token() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Token'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_DiscountExternalTools_Token', zc_Object_DiscountExternalTools(), 'API �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_DiscountExternalTools_Token');


--  zc_ObjectString_Unit_PromoForSale() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PromoForSale'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_PromoForSale', zc_object_Unit(), '������������� �������� ��� ���������� ������ � �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PromoForSale');

--  zc_ObjectString_BuyerForSale_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSale_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BuyerForSale_Phone', zc_Object_BuyerForSale(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSale_Phone');

--  zc_ObjectString_Hardware_ComputerName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ComputerName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Hardware_ComputerName', zc_Object_Hardware(), '��� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Hardware_ComputerName');
 
--  zc_ObjectString_Instructions_FileName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Instructions_FileName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Instructions_FileName', zc_Object_Instructions(), '��� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Instructions_FileName');

--  zc_ObjectString_User_LikiDnepr_UserEmail() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_UserEmail'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_LikiDnepr_UserEmail', zc_Object_User(), 'E-mail ��������� �-���� ��� ��� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_UserEmail');

--  zc_ObjectString_User_LikiDnepr_PasswordEHels() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_PasswordEHels'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_LikiDnepr_PasswordEHels', zc_Object_User(), '������ �-���� ��� ����������� ����� ��� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_LikiDnepr_PasswordEHels');


--  zc_ObjectString_BuyerForSite_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSite_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_BuyerForSite_Phone', zc_Object_BuyerForSite(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_BuyerForSite_Phone');

--  zc_ObjectString_RecalcMCSSheduler_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RecalcMCSSheduler_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_RecalcMCSSheduler_Comment', zc_Object_RecalcMCSSheduler(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_RecalcMCSSheduler_Comment');

--  zc_ObjectString_Personal_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Personal_Comment', zc_Object_Personal(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Comment');

--  zc_ObjectString_Personal_Code1C() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Code1C'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Personal_Code1C', zc_Object_Personal(), '��� 1�' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Personal_Code1C');

--  zc_ObjectString_PayrollTypeVIP_ShortName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollTypeVIP_ShortName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_PayrollTypeVIP_ShortName', zc_Object_PayrollTypeVIP(), '�������� ������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PayrollTypeVIP_ShortName');

--  zc_ObjectString_Goods_PromoBonusName() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_PromoBonusName'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_PromoBonusName', zc_Object_Goods(), '������������ �������� �������� �� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_PromoBonusName');

--  zc_ObjectString_MedicalProgramSP_ProgramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MedicalProgramSP_ProgramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_MedicalProgramSP_ProgramId', zc_Object_MedicalProgramSP(), '������������� ����������� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MedicalProgramSP_ProgramId');

--  zc_ObjectString_Unit_PharmacyManager() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManager'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_PharmacyManager', zc_object_Unit(), '��� ���. �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManager');

--  zc_ObjectString_Unit_PharmacyManagerPhone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManagerPhone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_PharmacyManagerPhone', zc_object_Unit(), '������� ���. �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_PharmacyManagerPhone');

--  zc_ObjectString_Unit_TokenKashtan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TokenKashtan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_TokenKashtan', zc_object_Unit(), '����� �������� ���� � ��� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TokenKashtan');

--  zc_ObjectString_Unit_TelegramId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TelegramId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_TelegramId', zc_object_Unit(), 'ID ������ � Telegram	' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_TelegramId');

--  zc_ObjectString_CashSettings_TelegramBotToken() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_TelegramBotToken'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_TelegramBotToken', zc_Object_CashSettings(), '����� �������� ����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_TelegramBotToken');

--  zc_ObjectString_SurchargeWages_Description() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SurchargeWages_Description'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_SurchargeWages_Description', zc_Object_SurchargeWages(), '��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SurchargeWages_Description');

--  zc_ObjectString_Education_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Education_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Education_NameUkr', zc_Object_Education(), '������������ �� ���������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Education_NameUkr');
  

--  zc_ObjectString_FormDispensing_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FormDispensing_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_FormDispensing_NameUkr', zc_Object_FormDispensing(), '�������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_FormDispensing_NameUkr');

--  zc_ObjectString_Goods_MakerUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_MakerUkr', zc_Object_Goods(), '������������� ���������� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_MakerUkr');


--  zc_ObjectString_GoodsWhoCan_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsWhoCan_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsWhoCan_NameUkr', zc_Object_GoodsWhoCan(), '�������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsWhoCan_NameUkr');

--  zc_ObjectString_GoodsMethodAppl_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsMethodAppl_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsMethodAppl_NameUkr', zc_Object_GoodsMethodAppl(), '�������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsMethodAppl_NameUkr');

--  zc_ObjectString_GoodsSignOrigin_NameUkr() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsSignOrigin_NameUkr'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GoodsSignOrigin_NameUkr', zc_Object_GoodsSignOrigin(), '�������� ����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_GoodsSignOrigin_NameUkr');

--  zc_ObjectString_Goods_Dosage() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Dosage'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Dosage', zc_Object_Goods(), '���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Dosage');

--  zc_ObjectString_Goods_Volume() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Volume'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_Volume', zc_Object_Goods(), '�����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_Volume');

--  zc_ObjectString_Goods_GoodsWhoCan() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GoodsWhoCan'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_GoodsWhoCan', zc_Object_Goods(), '���� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_GoodsWhoCan');

--  zc_ObjectString_Unit_SetDateRROList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SetDateRROList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Unit_SetDateRROList', zc_Object_Unit(), '�������� ��� ���� ��������� ������� �� ���' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Unit_SetDateRROList');

--  zc_ObjectString_InternetRepair_Provider() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Provider'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_Provider', zc_Object_InternetRepair(), '���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Provider');

--  zc_ObjectString_InternetRepair_ContractNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_ContractNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_ContractNumber', zc_Object_InternetRepair(), '����� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_ContractNumber');

--  zc_ObjectString_InternetRepair_Phone() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Phone'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_Phone', zc_Object_InternetRepair(), '�������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_Phone');

--  zc_ObjectString_InternetRepair_WhoSignedContract() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_WhoSignedContract'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_InternetRepair_WhoSignedContract', zc_Object_InternetRepair(), '��� ������� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_InternetRepair_WhoSignedContract');

--  zc_ObjectString_User_Language() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Language'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_User_Language', zc_Object_User(), '���� ������������ �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_User_Language');

--  zc_ObjectString_Goods_IdSP() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_IdSP'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_Goods_IdSP', zc_Object_Goods(), 'ID ���������� ������ � ��' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Goods_IdSP');

--  zc_ObjectString_CashSettings_SendCashErrorTelId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_SendCashErrorTelId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( 'zc_ObjectString_CashSettings_SendCashErrorTelId', zc_Object_CashSettings(), 'ID � �������� ��� �������� ������ �� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_CashSettings_SendCashErrorTelId');

--  zc_ObjectString_PartionGoods_PartNumber() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionGoods_PartNumber'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_PartionGoods(), 'zc_ObjectString_PartionGoods_PartNumber', ' �������� �����  (� �� ��� ��������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_PartionGoods_PartNumber');
  
--  zc_ObjectString_SubjectDoc_Short() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Short'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_Short', '����������� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Short');

--  zc_ObjectLink_SubjectDoc_Reason() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectLink_SubjectDoc_Reason', '������� �������� / �����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectLink_SubjectDoc_Reason');

--  zc_ObjectString_SubjectDoc_MovementDesc() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_MovementDesc'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_MovementDesc', '��� ���������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_MovementDesc');

--  zc_ObjectString_SubjectDoc_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_SubjectDoc(), 'zc_ObjectString_SubjectDoc_Comment', '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_SubjectDoc_Comment');


               
--  zc_ObjectString_Reason_Short() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Short'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (DescId, Code, ItemName)
  SELECT zc_Object_Reason(), 'zc_ObjectString_Reason_Short', '����������� ��������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Reason_Short');










  SELECT lpUpdate__ ('zc_ObjectString_Enum', 0, '������� ������-������' )
union all    SELECT lpUpdate__ ( 'zc_ObjectString_GUID', zc_Object_ReplServer(), '���� �������' )
union all 
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_Host', zc_Object_ReplServer(), '������' )
union all 
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_User', zc_Object_ReplServer(), '�����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_User');
union all 
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_Password', zc_Object_ReplServer(), '������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Password');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_Port', zc_Object_ReplServer(), '����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_Port');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_ReplServer_DataBase', zc_Object_ReplServer(), '���� ������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_ReplServer_DataBase');

union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_Comment', zc_Object_Asset(), 'Asset_Comment' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_Comment');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_FullName', zc_Object_Asset(), 'Asset_FullName' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_FullName');
union all
  SELECT lpUpdate__ ( 'zc_ObjectString_Asset_InvNumber', zc_object_Asset(), '����������� ����� �������� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_Asset_InvNumber');
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.10.13                                        *
 06.10.13                                        *
*/

-- ����
-- SELECT * FROM lpUpdate__ (ioId:= 0, inSession:= zfCalc_UserAdmin())





--  zc_ObjectString_MemberSheetWorkTime_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberSheetWorkTime_Comment', zc_Object_MemberSheetWorkTime(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberSheetWorkTime_Comment');

--  zc_ObjectString_MemberPersonalServiceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberPersonalServiceList_Comment', zc_Object_MemberPersonalServiceList(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPersonalServiceList_Comment');


--  zc_ObjectString_MemberExternal_DriverCertificate() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_DriverCertificate'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberExternal_DriverCertificate', zc_object_MemberExternal(), '������������ �������������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_DriverCertificate');

--  zc_ObjectString_MemberExternal_INN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_INN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberExternal_INN', zc_object_MemberExternal(), '��� ���.����(����������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_INN');

--  zc_ObjectString_MemberExternal_GLN() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_GLN'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberExternal_GLN', zc_object_MemberExternal(), 'GLN ���.����(����������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberExternal_GLN');


--  zc_ObjectString_MemberMinus_BankAccountTo() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_BankAccountTo'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_BankAccountTo', zc_object_MemberMinus(), '� ����� ���������� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_BankAccountTo');

--  zc_ObjectString_MemberMinus_DetailPayment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_DetailPayment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_DetailPayment', zc_object_MemberMinus(), '���������� �������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_DetailPayment');

--  zc_ObjectString_MemberMinus_ToShort() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_ToShort'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_ToShort', zc_object_MemberMinus(), '��. ���� (����������� ��������)' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_ToShort');

--  zc_ObjectString_MemberMinus_Number() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_Number'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberMinus_Number', zc_object_MemberMinus(), '� ��������������� �����' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberMinus_Number');




 --  zc_ObjectString_MemberReport_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberReport_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberReport_Comment', zc_object_MemberReport(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberReport_Comment');



--  zc_ObjectString_MemberBranch_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberBranch_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberBranch_Comment', zc_Object_MemberBranch(), '����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberBranch_Comment');


--  zc_ObjectString_MemberPriceList_Comment() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPriceList_Comment'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
--  ObjectStringDesc (Code, DescId, ItemName)
union all    SELECT lpUpdate__ ( zc_ObjectString_MemberPriceList_Comment', zc_Object_MemberPriceList(), ' 	����������' ) --  (SELECT * FROM ObjectStringDesc WHERE Code = 'zc_ObjectString_MemberPriceList_Comment');



