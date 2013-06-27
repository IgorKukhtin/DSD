insert into MovementItemDesc(Id, Code, ItemName)
SELECT zc_MovementItem_Goods(), 'Goods', 'Движение товаров' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Id = zc_MovementItem_Goods());

insert into MovementItemDesc(Id, Code, ItemName)
SELECT zc_MovementItem_In(), 'In', 'Приход из производства' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Id = zc_MovementItem_In());

insert into MovementItemDesc(Id, Code, ItemName)
SELECT zc_MovementItem_Out(), 'Out', 'Расход на производство' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemDesc WHERE Id = zc_MovementItem_Out());



--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
