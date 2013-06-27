insert into MovementItemLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementItemLink_GoodsKind(), 'GoodsKind', 'Виды товаров' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Id = zc_MovementItemLink_GoodsKind());

insert into MovementItemLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementItemLink_Partion(), 'Partion', 'Сущность c которой идет приход товара' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Id = zc_MovementItemLink_Partion());

insert into MovementItemLinkObjectDesc(Id, Code, ItemName)
SELECT zc_MovementItemLink_Receipt(), 'Receipt', 'Рецептуры' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemLinkObjectDesc WHERE Id = zc_MovementItemLink_Receipt());

--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!

