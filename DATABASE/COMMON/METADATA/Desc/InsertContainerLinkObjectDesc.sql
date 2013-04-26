insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Goods(), 'Goods', 'Аналитика "Товар"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Goods());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Unit(), 'Unit', 'Аналитика "Подразделение"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Unit());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Cash(), 'Cash', 'Аналитика "Касса"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Cash());

insert into ContainerLinkObjectDesc(Id, Code, ItemName)
SELECT zc_ContainerLinkObject_Account(), 'Account', 'Аналитика "Счета"' WHERE NOT EXISTS (SELECT * FROM ContainerLinkObjectDesc WHERE Id = zc_ContainerLinkObject_Account());
