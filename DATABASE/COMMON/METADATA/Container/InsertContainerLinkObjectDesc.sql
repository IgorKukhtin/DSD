--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

-- !!! Меняем автоинкрементное поле !!!
/*
DO $$
BEGIN
PERFORM setval ('containerlinkobjectdesc_id_seq', (select max (id) + 1 from ContainerLinkObjectDesc));
END $$;
*/

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Account', 'Аналитика "Управленческие счета"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Account');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_ProfitLoss', 'Аналитика "Статьи отчета о прибылях и убытках"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_ProfitLoss');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_InfoMoney', 'Аналитика "Управленческие аналитики"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoney');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Unit', 'Аналитика "Подразделения"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Unit');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Goods', 'Аналитика "Товары"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Goods');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_GoodsKind', 'Аналитика "Виды товаров"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_GoodsKind');

insert into ContainerLinkObjectDesc(Code, ItemName)
 SELECT 'zc_ContainerLinkObject_InfoMoneyDetail', 'Аналитика "Управленческие аналитики(детализация с/с)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_InfoMoneyDetail');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Contract', 'Аналитика "Договора"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Contract');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PaidKind', 'Аналитика "Виды форм оплаты"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PaidKind');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Juridical', 'Аналитика "Юридические лица"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Juridical');
 
insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Car', 'Аналитика "Автомобили"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Car');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Personal', 'Аналитика "Сотрудники"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Personal');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PersonalStore', 'Аналитика "Сотрудники(экспедиторы)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalStore');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PersonalBuyer', 'Аналитика "Сотрудники(покупатели)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalBuyer');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PersonalGoods', 'Аналитика "Сотрудники(материально ответственные)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalGoods');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PersonalCash', 'Аналитика "Сотрудники(подотчетные лица)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalCash');

insert into ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_AssetTo', 'Аналитика "Основные средства(для которого закуплено ТМЦ)"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_AssetTo');

INSERT INTO ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PartionGoods', 'Аналитика "Партии товара"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionGoods');

INSERT INTO ContainerLinkObjectDesc(Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PartionMovement', 'Аналитика "Партии накладной"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PartionMovement');

INSERT INTO ContainerLinkObjectDesc (Code, ItemName)
  SELECT 'zc_ContainerLinkObject_Business', 'Аналитика <Бизнесы>' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_Business');

INSERT INTO ContainerLinkObjectDesc (Code, ItemName)
  SELECT 'zc_ContainerLinkObject_JuridicalBasis', 'Аналитика <Главное юридическое лицо>' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_JuridicalBasis');

INSERT INTO ContainerLinkObjectDesc (Code, ItemName)
  SELECT 'zc_ContainerLinkObject_PersonalSupplier', 'Аналитика <Сотрудники(поставщики)>' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Code = 'zc_ContainerLinkObject_PersonalSupplier');


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.13          * переход всего на НОВУЮ СХЕМУ
 03.07.13                                        * НОВАЯ СХЕМА
*/
