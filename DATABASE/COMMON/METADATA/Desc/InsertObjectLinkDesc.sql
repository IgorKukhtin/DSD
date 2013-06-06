insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_RoleRight_Role(), 'RoleRight_Role', 'Ссылка на роль в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_RoleRight_Role());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_RoleRight_Process(), 'RoleRight_Process', 'Ссылка на процесс в справочнике указания ролей', zc_Object_RoleRight(), zc_Object_Process() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_RoleRight_Process());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_UserRole_Role(), 'UserRole_Role', 'Ссылка на роль в справочнике связи пользователей и ролей', zc_Object_UserRole(), zc_Object_Role() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_UserRole_Role());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_UserRole_User(), 'UserRole_User', 'Связь с пользователем в справочнике ролей пользователя', zc_Object_UserRole(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_UserRole_User());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Cash_Currency(), 'Cash_Currency', 'Связь кассы с валютой', zc_Object_Cash(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Cash_Currency());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Cash_Branch(), 'Cash_Branch', 'Связь кассы с филиалом', zc_Object_Cash(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Cash_Branch());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_JuridicalGroup_Parent(), 'JuridicalGroup_Parent', 'Связь группы юр лиц с группой юр лиц', zc_Object_JuridicalGroup(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_JuridicalGroup_Parent());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Juridical_JuridicalGroup(), 'Juridical_JuridicalGroup', 'Связь юр лица с группой юр лиц', zc_Object_Juridical(), zc_Object_JuridicalGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Juridical_JuridicalGroup());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Juridical_GoodsProperty(), 'Juridical_GoodsProperty', 'Связь юр лица с классификатором свойств товаров', zc_Object_Juridical(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Juridical_GoodsProperty());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Partner_Juridical(), 'Partner_Juridical', 'Связь контрагента с юр лицом', zc_Object_Partner(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Partner_Juridical());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Branch_Juridical(), 'Branch_Juridical', 'Связь филиала с юр лицом', zc_Object_Branch(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Branch_Juridical());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_UnitGroup_Parent(), 'UnitGroup_Parent', 'Связь группы подразделений с группой подразделений', zc_Object_UnitGroup(), zc_Object_UnitGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_UnitGroup_Parent());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Unit_UnitGroup(), 'Unit_UnitGroup', 'Связь подразделения с группой подразделений', zc_Object_Unit(), zc_Object_UnitGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Unit_UnitGroup());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Unit_Branch(), 'Unit_Branch', 'Связь подразделения с филиалом', zc_Object_Unit(), zc_Object_Branch() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Unit_Branch());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Bank_Juridical(), 'Bank_Juridical', 'Связь банка с юр лицом', zc_Object_Bank(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Bank_Juridical());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_GoodsGroup_Parent(), 'GoodsGroup_Parent', 'Связь группы товаров с группой товаров', zc_Object_GoodsGroup(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_GoodsGroup_Parent());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Goods_GoodsGroup(), 'Goods_GoodsGroup', 'Связь товаров с группой товаров', zc_Object_Goods(), zc_Object_GoodsGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Goods_GoodsGroup());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Goods_Measure(), 'Goods_Measure', 'Связь товаров с единицей измерения', zc_Object_Goods(), zc_Object_Measure() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Goods_Measure());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Goods_InfoMoney(), 'Goods_InfoMoney', 'Связь товаров с управленческой статьей', zc_Object_Goods(), zc_Object_InfoMoney() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Goods_InfoMoney());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_BankAccount_Juridical(), 'BankAccount_Juridical', 'Связь счета с юр. лицом', zc_Object_BankAccount(), zc_Object_Juridical() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_BankAccount_Juridical());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_BankAccount_Bank(), 'BankAccount_Bank', 'Связь счета банком', zc_Object_BankAccount(), zc_Object_Bank() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_BankAccount_Bank());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_BankAccount_Currency(), 'BankAccount_Currency', 'Связь счета с валютой', zc_Object_BankAccount(), zc_Object_Currency() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_BankAccount_Currency());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), 'GoodsPropertyValue_GoodsProperty', '', zc_Object_GoodsPropertyValue(), zc_Object_GoodsProperty() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_GoodsPropertyValue_GoodsProperty());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_GoodsPropertyValue_Goods(), 'GoodsPropertyValue_Goods', '', zc_Object_GoodsPropertyValue(), zc_Object_Goods() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_GoodsPropertyValue_Goods());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_GoodsPropertyValue_GoodsKind(), 'GoodsPropertyValue_GoodsKind', '', zc_Object_GoodsPropertyValue(), zc_Object_GoodsKind() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_GoodsPropertyValue_GoodsKind());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Account_AccountGroup(), 'Account_AccountGroup', '', zc_Object_Account(), zc_Object_AccountGroup() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Account_AccountGroup());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Account_AccountDirection(), 'Account_AccountDirection', '', zc_Object_Account(), zc_Object_AccountDirection() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Account_AccountDirection());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_Account_InfoMoneyDestination(), 'Account_InfoMoneyDestination', '', zc_Object_Account(), zc_Object_InfoMoneyDestination() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_Account_InfoMoneyDestination());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_UserFormSettings_Form(), 'UserFormSettings_Form', '', zc_Object_UserFormSettings(), zc_Object_Form() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_UserFormSettings_Form());

insert into ObjectLinkDesc(Id, Code, ItemName, DescId, ChildObjectDescId)
SELECT zc_ObjectLink_UserFormSettings_User(), 'UserFormSettings_User', '', zc_Object_UserFormSettings(), zc_Object_User() WHERE NOT EXISTS (SELECT * FROM ObjectLinkDesc WHERE Id = zc_ObjectLink_UserFormSettings_User());
