insert into ContainerDesc(Id, Code, ItemName)
SELECT zc_Container_Count(), 'Count', '—чета товарного учета количества' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Id = zc_Container_Count());

insert into ContainerDesc(Id, Code, ItemName)
SELECT zc_Container_Summ(), 'Summ', '—чета денежнного учета сумм' WHERE NOT EXISTS (SELECT * FROM ContainerDesc WHERE Id = zc_Container_Summ());
