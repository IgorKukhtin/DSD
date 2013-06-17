insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Account(), 'Account', 'Аналитика "Управленческие счета"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Account());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_ProfitLoss(), 'ProfitLoss', 'Аналитика "Статьи отчета о прибылях и убытках"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_ProfitLoss());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Business(), 'Business', 'Аналитика "Бизнесы"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Business());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_JuridicalBasis(), 'JuridicalBasis', 'Аналитика "Главное юридическое лицо"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_JuridicalBasis());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_InfoMoney(), 'InfoMoney', 'Аналитика "Управленческие аналитики"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_InfoMoney());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Unit(), 'Unit', 'Аналитика "Подразделения"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Unit());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Goods(), 'Goods', 'Аналитика "Товары"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Goods());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_GoodsKind(), 'GoodsKind', 'Аналитика "Виды товаров"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_GoodsKind());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_InfoMoneyDetail(), 'InfoMoneyDetail', 'Аналитика "Управленческие аналитики(детализация с/с)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_InfoMoneyDetail());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_InfoMoneyDetail(), 'InfoMoneyDetail', 'Аналитика "Управленческие аналитики(детализация с/с)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_InfoMoneyDetail());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Contract(), 'Contract', 'Аналитика "Договора"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Contract());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_PaidKind(), 'PaidKind', 'Аналитика "Виды форм оплаты"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_PaidKind());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Juridical(), 'Juridical', 'Аналитика "Юридические лица"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Juridical());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Juridical(), 'Juridical', 'Аналитика "Юридические лица"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Juridical());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Car(), 'Car', 'Аналитика "Автомобили"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Car());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Position(), 'Position', 'Аналитика "Должности"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Position());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Personal(), 'Personal', 'Аналитика "Сотрудники"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Personal());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_PersonalStore(), 'PersonalStore', 'Аналитика "Сотрудники(экспедиторы)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_PersonalStore());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_PersonalBuyer(), 'PersonalBuyer', 'Аналитика "Сотрудники(покупатели)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_PersonalBuyer());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_PersonalGoods(), 'PersonalGoods', 'Аналитика "Сотрудники(материально ответственные)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_PersonalGoods());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_PersonalCash(), 'PersonalCash', 'Аналитика "Сотрудники(подотчетные лица)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_PersonalCash());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_AssetTo(), 'AssetTo', 'Аналитика "Основные средства(для которого закуплено ТМЦ)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_AssetTo());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_PartionGoods(), 'PartionGoods', 'Аналитика "Партии товара"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_PartionGoods());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_PartionMovement(), 'PartionMovement', 'Аналитика "Партии накладной"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_PartionMovement());
