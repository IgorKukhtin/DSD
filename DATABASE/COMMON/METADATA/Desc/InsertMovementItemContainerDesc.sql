insert into MovementItemContainerDesc(Id, Code, ItemName)
SELECT zc_MovementItemContainer_Count(), 'Count', 'Проводки для товарного учета в количестве' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Id = zc_MovementItemContainer_Count());

insert into MovementItemContainerDesc(Id, Code, ItemName)
SELECT zc_MovementItemContainer_Summ(), 'Summ', 'Проводки для денежнного учета в суммах' WHERE NOT EXISTS (SELECT * FROM MovementItemContainerDesc WHERE Id = zc_MovementItemContainer_Summ());



--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
